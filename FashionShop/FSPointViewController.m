//
//  FSLikeViewController.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPointViewController.h"
#import "FSPointDetailCell.h"
#import "FSCommonUserRequest.h"
#import "FSPagedPoint.h"
#import "FSModelManager.h"
#import "FSConfiguration.h"
#import "FSCardBindViewController.h"
#import "FSCardRequest.h"
#import "FSCardInfo.h"
#import "FSPointMemberCardCell.h"
#import "FSPointExchangeListViewController.h"
#import "FSCardBindViewController.h"
#import "FSTopicViewController.h"

@interface FSPointViewController ()
{
    NSMutableArray *_likes;
    int _currentPage;
    BOOL _noMore;
    BOOL _inLoading;
}

@end

#define USER_POINT_TABLE_CELL @"userpointtablecell"
#define USER_POINT_CARD_MEMBER_CELL @"userpointmembercardcell"

@implementation FSPointViewController
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
    [_contentView registerNib:[UINib nibWithNibName:@"FSPointDetailCell" bundle:Nil] forCellReuseIdentifier:USER_POINT_TABLE_CELL];
    [_contentView registerNib:[UINib nibWithNibName:@"FSPointMemberCardCell" bundle:Nil] forCellReuseIdentifier:USER_POINT_CARD_MEMBER_CELL];
    _contentView.hidden = YES;
    [self preparePresent];
    NSArray *array = self.navigationController.viewControllers;
    if (array.count >= 2) {
        id con = array[array.count - 2];
        if ([con isKindOfClass:[FSTopicViewController class]]) {
            CGRect _rect = _contentView.frame;
            _rect.size.height -= NAV_HIGH;
            _rect.origin.y += NAV_HIGH;
            _contentView.frame = _rect;
        }
    }
}

-(void)viewDidUnload {
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![currentUser.isBindCard boolValue]) {
        UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sheepButton setTitle:@"绑定会员卡" forState:UIControlStateNormal];
        [sheepButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        sheepButton.titleLabel.font = ME_FONT(11);
        sheepButton.showsTouchWhenHighlighted = YES;
        [sheepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
        [sheepButton sizeToFit];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
        [self.navigationItem setRightBarButtonItem:item];
    }
    else{
        UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sheepButton setTitle:@"积点兑换" forState:UIControlStateNormal];
        [sheepButton addTarget:self action:@selector(pointExchange:) forControlEvents:UIControlEventTouchUpInside];
        sheepButton.titleLabel.font = ME_FONT(13);
        sheepButton.showsTouchWhenHighlighted = YES;
        [sheepButton setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
        [sheepButton sizeToFit];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
        [self.navigationItem setRightBarButtonItem:item];
    }
    [self prepareData];
}

-(void)onButtonClick:(UIButton*)sender
{
    FSCardBindViewController *con = [[FSCardBindViewController alloc] initWithNibName:@"FSCardBindViewController" bundle:nil];
    con.currentUser = currentUser;
    [self.navigationController pushViewController:con animated:YES];
}

-(void) prepareData
{
    if (!_likes)
    {
        _currentPage = 1;
        _inLoading = YES;
        FSCommonUserRequest *request = [self buildListRequest:RK_REQUEST_POINT_LIST nextPage:_currentPage isRefresh:NO];
        [self beginLoading:self.view];
        [request send:[FSPagedPoint class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (resp.isSuccess)
            {
                FSPagedPoint *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage)
                    _noMore = true;
                [self mergeLike:innerResp isInsert:false];
                [self bindRequest];
            }
            else
            {
                [self endLoading:self.view];
                [self reportError:resp.errorDescrip];
                _inLoading = NO;
                _contentView.hidden = NO;
            }
            _contentView.tableFooterView= [self createTableFooterView];
        }];
    }
    else{
        [self bindRequest];
    }
}

-(void)bindRequest
{
    static int requestCount = 1;
    if ([currentUser.isBindCard boolValue]) {
        currentUser.cardInfo = nil;
        FSCardRequest *request = [[FSCardRequest alloc] init];
        request.userToken = currentUser.uToken;
        request.routeResourcePath = RK_REQUEST_USER_CARD_DETAIL;
        [request send:[FSCardInfo class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            if (!resp.isSuccess)
            {
                requestCount ++;
                if (requestCount > 5) {
                    [self reportError:resp.errorDescrip];
                    requestCount = 0;
                    _contentView.hidden = NO;
                    [self endLoading:self.view];
                }
                else{
                    [self bindRequest];
                }
            }
            else
            {
                _contentView.hidden = NO;
                [self endLoading:self.view];
                //显示绑定成功界面
                currentUser.isBindCard = @YES;
                currentUser.cardInfo = resp.responseData;
                [_contentView reloadData];
            }
        }];
    }
    else{
        _inLoading = NO;
        _contentView.hidden = NO;
        [self endLoading:self.view];
    }
}

-(void) preparePresent
{
    self.navigationItem.title = NSLocalizedString(@"points", nil);
    
    [self prepareRefreshLayout:_contentView withRefreshAction:^(dispatch_block_t action) {
        [self refreshContent:TRUE withCallback:^(){
            action();
        }];
    }];
    _contentView.dataSource = self;
    _contentView.delegate =self;
    
    _contentView.backgroundView = nil;
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
}

-(void)refreshContent:(BOOL)isRefresh withCallback:(dispatch_block_t)callback
{
    int nextPage = 1;
    if (!isRefresh)
    {
        _currentPage++;
        nextPage = _currentPage + 1;
    }
    else {
        [self zeroMemoryBlock];
    }
    _inLoading = YES;
    FSCommonUserRequest *request = [self buildListRequest:RK_REQUEST_POINT_LIST nextPage:nextPage isRefresh:isRefresh];
    __block FSPointViewController *blockSelf = self;
    [request send:[FSPagedPoint class] withRequest:request completeCallBack:^(FSEntityBase * resp) {
        callback();
        if (resp.isSuccess)
        {
            FSPagedPoint *innerResp = resp.responseData;
            if (innerResp.totalPageCount <= blockSelf->_currentPage+1)
                blockSelf-> _noMore = YES;
            [self mergeLike:innerResp isInsert:isRefresh];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
        _inLoading = NO;
    }];
}

-(void) zeroMemoryBlock
{
    _currentPage = 0;
    _noMore = NO;
    _inLoading = NO;
}

-(void)addTableHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 80)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 150, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.font = FONT(18);
    UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 100, 30)];
    total.backgroundColor = [UIColor clearColor];
    total.font = FONT(18);
    [view addSubview:total];
    _contentView.tableHeaderView = view;
}

-(UIView*)createTableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor clearColor];
    
    int xOffset = 30;
    int yOffset = 25;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(xOffset, yOffset, (320-xOffset*2), 40);
    [btn setTitle:NSLocalizedString(@"Point Exchange", nil) forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pointExchange:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:btn];
    return view;
}

-(void)pointExchange:(UIButton*)sender
{
    if (_inLoading) {
        return;
    }
    if (![currentUser.isBindCard boolValue]) {
        FSCardBindViewController *controller = [[FSCardBindViewController alloc] initWithNibName:@"FSCardBindViewController" bundle:nil];
        __block FSCardBindViewController *blockBindController = controller;
        blockBindController.currentUser = self.currentUser;
        blockBindController.completeCallBack = ^(BOOL isSuccess){
            [blockBindController popViewControllerAnimated:YES completion:^{
                if (!isSuccess)
                {
                    [self reportError:NSLocalizedString(@"COMM_OPERATE_FAILED", nil)];
                }
                else
                {
                    FSPointExchangeListViewController *controller = [[FSPointExchangeListViewController alloc] initWithNibName:@"FSPointExchangeListViewController" bundle:nil];
                    [blockBindController.navigationController pushViewController:controller animated:YES];
                }
            }];
        };
        [self.navigationController pushViewController:blockBindController animated:YES];
    }
    else{
        FSPointExchangeListViewController *controller = [[FSPointExchangeListViewController alloc] initWithNibName:@"FSPointExchangeListViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void) mergeLike:(FSPagedPoint *)response isInsert:(BOOL)isinsert
{
    if (!_likes)
    {
        _likes = [@[] mutableCopy];
    }
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSPoint *)obj1 valueForKey:@"id"] intValue] == [[(FSPoint *)obj valueForKey:@"id"] intValue])
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
    }
    [_contentView reloadData];
}

-(FSCommonUserRequest *)buildListRequest:(NSString *)route nextPage:(int)page isRefresh:(BOOL)isRefresh
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userToken =[FSModelManager sharedModelManager].loginToken;
    request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE];
    request.pageIndex =[NSNumber numberWithInt:page];
    request.sort = @0;
    request.routeResourcePath = route;
    request.requestType = 1;
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
    if ([currentUser.isBindCard boolValue]) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([currentUser.isBindCard boolValue] && section == 0) {
        return 1;
    }
    else{
        return _likes?_likes.count:0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([currentUser.isBindCard boolValue] && indexPath.section == 0) {
        if (!currentUser.cardInfo) {
            return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        FSPointMemberCardCell *detailCell = [_contentView dequeueReusableCellWithIdentifier:USER_POINT_CARD_MEMBER_CELL];
        detailCell.cardType.text = [NSString stringWithFormat:NSLocalizedString(@"Member Card Type:%@-%@", nil), currentUser.cardInfo.type,currentUser.cardInfo.cardLevel];
        detailCell.cardNumber.text = [NSString stringWithFormat:NSLocalizedString(@"Member Card Number:%@", nil), currentUser.cardInfo.cardNo];
        detailCell.totalPoint.text = [NSString stringWithFormat:NSLocalizedString(@"Member Card Point:%@", nil), [currentUser.cardInfo.amount stringValue]];
        return detailCell;
    }
    else{
        FSPointDetailCell *detailCell = [_contentView dequeueReusableCellWithIdentifier:USER_POINT_TABLE_CELL];
        detailCell.data = [_likes objectAtIndex:indexPath.row];
        return detailCell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([currentUser.isBindCard boolValue] && indexPath.section == 0) {
        return 110;
    }
    else{
        FSPoint *point = [_likes objectAtIndex:indexPath.row];
        CGFloat baseHeight = 45;
        CGSize newSize = [point.getReason sizeWithFont:ME_FONT(14) constrainedToSize:CGSizeMake(200, 200) lineBreakMode:NSLineBreakByWordWrapping];
        return MAX(newSize.height+20, baseHeight);
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
    
    if ([currentUser.isBindCard boolValue] && indexPath.section == 0) {
        
    }
    else{
        if (indexPath.row %2==0)
        {
            cell.backgroundColor = PRO_LIST_NEAR_CELL1_BGCOLOR;
            
        } else
        {
            cell.backgroundColor = PRO_LIST_NEAR_CELL2_BGCOLOR;
        }
    }
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_likes.count <= 0) {
        return 0;
    }
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 30)];
    view.image = [UIImage imageNamed:@"list_title_bg.png"];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 30)];
    title.backgroundColor = [UIColor clearColor];
    title.font = BFONT(14);
    title.textColor = [UIColor colorWithHexString:@"#6f5e6c"];
    if (section == 0) {
        title.text = NSLocalizedString(@"Member Card Point Desc", nil);
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectMake(APP_WIDTH-10-100, 0, 100, 30)];
        total.textAlignment = UITextAlignmentRight;
        total.backgroundColor = [UIColor clearColor];
        total.font = BFONT(14);
        total.textColor = [UIColor whiteColor];
        [view addSubview:total];
    }
    else{
        title.text = NSLocalizedString(@"App Point Desc", nil);
    }
    [view addSubview:title];
    return view;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [super scrollViewDidScroll:scrollView];
    
    if(!_noMore
       && !_inLoading
       && (scrollView.contentOffset.y+scrollView.frame.size.height) + 100 > scrollView.contentSize.height
       &&scrollView.contentOffset.y>0)
    {
        [self loadMore];
    }
}

-(void)loadMore{
    if (_inLoading)
        return;
    __block FSPointViewController *blockSelf = self;
    [self beginLoadMoreLayout:_contentView];
    _inLoading = YES;
    [self refreshContent:NO withCallback:^{
        [blockSelf endLoadMore:blockSelf.contentView];
        _inLoading = NO;
    }];
}

@end
