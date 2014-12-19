//
//  FSLikeViewController.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSLikeViewController.h"
#import "FSLikeDetailCell.h"
#import "FSCommonUserRequest.h"
#import "FSPagedLike.h"
#import "FSModelManager.h"
#import "FSDRViewController.h"

@interface FSLikeViewController ()
{
    NSMutableArray *_likes;
    int _currentPage;
    BOOL _noMore;
    BOOL _inLoading;
    UIRefreshControl *_refreshControl;
}

@end

#define USER_LIKE_TABLE_CELL @"userliketablecell"
@implementation FSLikeViewController
@synthesize currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [_contentView registerNib:[UINib nibWithNibName:@"FSLikeDetailCell" bundle:Nil] forCellReuseIdentifier:USER_LIKE_TABLE_CELL];
    [self prepareData];
    [self preparePresent];

}

-(void) prepareData
{
    if (!_likes)
    {
        [self beginLoading:_contentView];
        _currentPage = 1;
        FSCommonUserRequest *request = [self createRequest:_currentPage];
        [request send:[FSPagedLike class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:_contentView];
            if (resp.isSuccess)
            {
                FSPagedLike *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage)
                    _noMore = true;
                [self mergeLike:innerResp isInsert:false];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
}
-(void) preparePresent
{
    [self prepareRefreshLayout:_contentView withRefreshAction:^(dispatch_block_t action) {
        FSCommonUserRequest *request = [self createRequest:1];
        [request send:[FSPagedLike class] withRequest:request completeCallBack:^(FSEntityBase * resp) {
            action();
            if (resp.isSuccess)
            {
                FSPagedLike *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage)
                    _noMore = true;
                [self mergeLike:innerResp isInsert:true];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }];
    _contentView.dataSource = self;
    _contentView.delegate =self;
    
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    _contentView.backgroundView = nil;
}

-(void) mergeLike:(FSPagedLike *)response isInsert:(BOOL)isinsert
{
    if (!_likes)
    {
        _likes = [@[] mutableCopy];
    }
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSUser *)obj1 valueForKey:@"uid"] isEqualToValue:[(FSUser *)obj valueForKey:@"uid"]])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index == NSNotFound)
            {
                if (isinsert)
                    [_likes insertObject:obj atIndex:0];
                else
                    [_likes addObject:obj];
            }

        }];
        [_contentView reloadData];
    }
    if (_likes.count<1)
    {
        //加载空视图
        if (_likeType == 0) {
            [self showNoResultImage:_contentView withImage:@"blank_like.png" withText:NSLocalizedString(@"TipInfo_Liked_List", nil)  originOffset:100];
        }
        else {
            [self showNoResultImage:_contentView withImage:@"blank_like.png" withText:NSLocalizedString(@"TipInfo_Fans_List", nil)  originOffset:100];
        }
    }
    else
    {
        [self hideNoResultImage:_contentView];
    }
}

-(FSCommonUserRequest *)createRequest:(int)index
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
    request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE];
    request.pageIndex =[NSNumber numberWithInt:index];
    request.sort = @0;
    request.likeType = [NSNumber numberWithInt:_likeType];
    request.routeResourcePath = RK_REQUEST_LIKE_LIST;
    if (_searchById)
        request.userId = currentUser.uid;
    return request;
}
-(void) presentData
{
  
    [_contentView reloadData];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _likes?_likes.count:0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSLikeDetailCell *detailCell = [_contentView dequeueReusableCellWithIdentifier:USER_LIKE_TABLE_CELL];
    detailCell.data = [_likes objectAtIndex:indexPath.row];
    detailCell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return detailCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    
    if (indexPath.row %2==0)
    {
        cell.backgroundColor = PRO_LIST_NEAR_CELL1_BGCOLOR;
        
    } else
    {
        cell.backgroundColor = PRO_LIST_NEAR_CELL2_BGCOLOR;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *userId = [(FSUser *)[_likes objectAtIndex:indexPath.row] uid];
    FSDRViewController *dr = [[FSDRViewController alloc] initWithNibName:@"FSDRViewController" bundle:nil];
    dr.userId = [userId intValue];
    [self.navigationController pushViewController:dr animated:TRUE];
    [tableView deselectRowAtIndexPath:indexPath animated:FALSE];

    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:_likeType==0?@"关注列表页":@"粉丝列表页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_DAREN_DETAIL withParameters:_dic];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if (!_inLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
        &&scrollView.contentOffset.y>0
        && !_noMore)
    {
        _inLoading = TRUE;
        FSCommonUserRequest *request = [self createRequest:_currentPage+1];
        [request send:[FSPagedLike class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = FALSE;
            if (resp.isSuccess)
            {
                FSPagedLike *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage+1)
                    _noMore = true;
                _currentPage ++;
                [self mergeLike:innerResp isInsert:FALSE];
                
                //统计
                NSString *value = _likeType==0?@"关注列表页":@"粉丝列表页";
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                [_dic setValue:value forKey:@"来源"];
                [_dic setValue:[NSString stringWithFormat:@"%d", _currentPage] forKey:@"页码"];
                [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
