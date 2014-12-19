//
//  FSPointExchangeListViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPointExchangeListViewController.h"
#import "FSExchangeDetailViewController.h"
#import "FSExchangeListCell.h"
#import "FSCommonRequest.h"
#import "FSExchangeRequest.h"
#import "FSPagedExchangeList.h"
#import "FSExchange.h"
#import "FSUser.h"

#define Point_Exchange_Cell_Indentifier @"FSExchangeListCell"

@interface FSPointExchangeListViewController ()
{
    NSMutableArray *_itemList;
    int _currentPage;
    BOOL _noMoreResult;
    BOOL _inLoading;
}

@end

@implementation FSPointExchangeListViewController

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
    self.title = NSLocalizedString(@"Point Activity List", nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _itemList = [@[] mutableCopy];
    [_contentView registerNib:[UINib nibWithNibName:@"FSExchangeListCell" bundle:nil] forCellReuseIdentifier:Point_Exchange_Cell_Indentifier];
    _contentView.backgroundView = nil;
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    
    _currentPage = 1;
    _noMoreResult = NO;
    _inLoading = NO;
    //加载数据
    FSExchangeRequest *request = [[FSExchangeRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_STOREPROMOTION_LIST;
    request.pageSize = COMMON_PAGE_SIZE;
    request.nextPage = _currentPage;
    [self beginLoading:_contentView];
    _inLoading = YES;
    [request send:[FSPagedExchangeList class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        [self endLoading:_contentView];
        _inLoading = NO;
        if (respData.isSuccess)
        {
            FSPagedExchangeList *result = respData.responseData;
            if (result.totalPageCount <= _currentPage+1)
                _noMoreResult = YES;
            [self fillProdInMemory:result.items isInsert:NO];
        }
        else
        {
            [self reportError:respData.errorDescrip];
        }
    }];
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods)
        return;
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_itemList indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
            if ([(FSExchange *)obj1 id] == [(FSExchange *)obj id])
            {
                return TRUE;
                *stop1 = TRUE;
            }
            return FALSE;
        }];
        if (index==NSNotFound)
        {
            [_itemList addObject:obj];
        }
    }];
    if (_itemList.count<1)
    {
        //加载空视图
        [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Coupon_None_Gift", nil)  originOffset:30];
    }
    else
    {
        [self hideNoResultImage:_contentView];
    }
    [_contentView reloadData];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSExchangeListCell *cell = [_contentView dequeueReusableCellWithIdentifier:Point_Exchange_Cell_Indentifier];
    if (cell == nil) {
        cell = [[FSExchangeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Point_Exchange_Cell_Indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:[_itemList objectAtIndex:indexPath.section]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSExchangeDetailViewController *controller = [[FSExchangeDetailViewController alloc] initWithNibName:@"FSExchangeDetailViewController" bundle:nil];
    FSExchange *item = _itemList[indexPath.section];
    controller.requestID = [item id];
    controller.title = [item name];
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [_dic setValue:@"代金券兑换列表页" forKey:@"来源页面"];
    [_dic setValue:[NSString stringWithFormat:@"%d", item.id] forKey:@"兑换活动ID"];
    [_dic setValue:item.name forKey:@"活动名称"];
    [[FSAnalysis instance] logEvent:CHECK_EXCHANGE_LIST_DETAIL withParameters:_dic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if(!_noMoreResult
       && !_inLoading
       && (scrollView.contentOffset.y+scrollView.frame.size.height) + 100 > scrollView.contentSize.height
       &&scrollView.contentOffset.y>0)
    {
        FSExchangeRequest *request = [[FSExchangeRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_STOREPROMOTION_LIST;
        request.pageSize = @COMMON_PAGE_SIZE;
        request.nextPage = [NSNumber numberWithInt:_currentPage];
        [self beginLoadMoreLayout:_contentView];
        _inLoading = YES;
        [request send:[FSPagedExchangeList class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
            [self endLoadMore:_contentView];
            _inLoading = NO;
            if (respData.isSuccess)
            {
                FSPagedExchangeList *result = respData.responseData;
                if (result.totalPageCount <= _currentPage+1)
                    _noMoreResult = YES;
                [self fillProdInMemory:result.items isInsert:NO];
                
                //统计
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                [_dic setValue:@"积点兑换活动列表" forKey:@"来源"];
                [_dic setValue:[NSString stringWithFormat:@"%d", _currentPage+1] forKey:@"页码"];
                [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
            }
            else
            {
                [self reportError:respData.errorDescrip];
            }
        }];
    }
}

@end
