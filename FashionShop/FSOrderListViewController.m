//
//  FSOrderListViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderListViewController.h"
#import "FSPurchaseRequest.h"
#import "FSOrderListCell.h"
#import "FSPagedOrder.h"
#import "FSOrder.h"
#import "FSOrderDetailViewController.h"

@interface FSOrderListViewController ()
{
    FSOrderSortBy _currentSelIndex;
    
    NSMutableArray *_dataSourceList;
    NSMutableArray *_noMoreList;
    NSMutableArray *_pageIndexList;
    NSMutableArray *_refreshTimeList;
    BOOL _inLoading;
}

@end

@implementation FSOrderListViewController

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
    
    self.title = NSLocalizedString(@"Pre Order List",nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _currentSelIndex = OrderSortByCarryOn;
    
    [self initArray];
    [self setFilterType];
    
    _contentView.backgroundView = nil;
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    
    [self prepareRefreshLayout:_contentView withRefreshAction:^(dispatch_block_t action) {
        if (_inLoading)
        {
            action();
            return;
        }
        int currentPage = 1;
        FSPurchaseRequest *request = [self createRequest:currentPage];
        _inLoading = YES;
        [request send:[FSPagedOrder class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            action();
            if (resp.isSuccess)
            {
                [self setPageIndex:currentPage selectedSegmentIndex:_currentSelIndex];
                FSPagedOrder *innerResp = resp.responseData;
                if (innerResp.totalPageCount <= currentPage)
                    [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
                [self mergeLike:innerResp isInsert:NO];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

-(void)initArray
{
    _dataSourceList = [@[] mutableCopy];
    _pageIndexList = [@[] mutableCopy];
    _noMoreList = [@[] mutableCopy];
    _refreshTimeList = [@[] mutableCopy];
    
    for (int i = 0; i < 4; i++) {
        [_dataSourceList insertObject:[@[] mutableCopy] atIndex:i];
        [_pageIndexList insertObject:@1 atIndex:i];
        [_noMoreList insertObject:@NO atIndex:i];
        [_refreshTimeList insertObject:[NSDate date] atIndex:i];
    }
}

-(void) setFilterType
{
    [_segFilters setDelegate:self];
    UIImage *backgroundImage = [UIImage imageNamed:@"tab_two_bg_normal.png"];
    [_segFilters setBackgroundImage:backgroundImage];
    [_segFilters setContentEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [_segFilters setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segFilters setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [_segFilters setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonPressImage = [UIImage imageNamed:@"tab_two_bg_selected"];
    UIButton *btn0 = [[UIButton alloc] init];
    [btn0 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn0 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn0 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn0 setTitle:NSLocalizedString(@"Order List UnPay", nil) forState:UIControlStateNormal];
    btn0.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn0.showsTouchWhenHighlighted = YES;
    
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn1 setTitle:NSLocalizedString(@"Order List Carry On", nil) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn1.showsTouchWhenHighlighted = YES;
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn2 setTitle:NSLocalizedString(@"Order List Completion", nil) forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn2.showsTouchWhenHighlighted = YES;
    
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn3 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn3 setTitle:NSLocalizedString(@"Order List Disable", nil) forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn3.showsTouchWhenHighlighted = YES;
    
    [_segFilters setButtonsArray:@[btn0,btn1, btn2, btn3]];
    _segFilters.selectedIndex = 0;
}

- (void)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) requestData
{
    int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
    [self setPageIndex:currentPage selectedSegmentIndex:_currentSelIndex];
    FSPurchaseRequest *request = [self createRequest:currentPage];
    [self beginLoading:self.view];
    _inLoading = YES;
    [request send:[FSPagedOrder class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:self.view];
        _inLoading = NO;
        if (resp.isSuccess)
        {
            FSPagedOrder *innerResp = resp.responseData;
            if (innerResp.totalPageCount <= currentPage)
                [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
            [self mergeLike:innerResp isInsert:NO];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void)setPageIndex:(int)_index selectedSegmentIndex:(NSInteger)_selIndexSegment
{
    NSNumber * nsNum = [NSNumber numberWithInt:_index];
    [_pageIndexList replaceObjectAtIndex:_selIndexSegment withObject:nsNum];
}

-(void)setNoMore:(BOOL)_more selectedSegmentIndex:(NSInteger)_selIndexSegment
{
    NSNumber * nsNum = [NSNumber numberWithBool:_more];
    [_noMoreList replaceObjectAtIndex:_selIndexSegment withObject:nsNum];
}

-(void)setRefreshTime:(NSDate*)_date selectedSegmentIndex:(NSInteger)_selIndexSegment
{
    [_refreshTimeList replaceObjectAtIndex:_selIndexSegment withObject:_date];
}

-(void) mergeLike:(FSPagedOrder *)response isInsert:(BOOL)isinsert
{
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    if (!isinsert) {
        [_likes removeAllObjects];
    }
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSOrderInfo *)obj1 valueForKey:@"orderno"] isEqualToString:[(FSOrderInfo *)obj valueForKey:@"orderno" ]])
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
    [self showBlankIcon];
}

-(void)showBlankIcon
{
    NSMutableArray *tmpPros = [_dataSourceList objectAtIndex:_currentSelIndex];
    if (tmpPros.count < 1) {
//        if (IOS7) {
//            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Order_List_None", nil)  originOffset:20];
//        }
//        else
        {
            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Order_List_None", nil)  originOffset:100];
        }
        
    }
    else{
        [self hideNoResultImage:_contentView];
    }
}

-(FSPurchaseRequest *)createRequest:(int)index
{
    FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
    request.uToken = [FSModelManager sharedModelManager].loginToken;
    request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE];
    request.nextPage =[NSNumber numberWithInt:index];
    request.type = _currentSelIndex;
    request.routeResourcePath = RK_REQUEST_ORDER_LIST;
    return request;
}

#pragma mark - UITableViewDelegate && UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_dataSourceList || _dataSourceList.count == 0) {
        return 0;
    }
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    return _likes?_likes.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_dataSourceList || _dataSourceList.count == 0) {
        return 0;
    }
    return 1;
}

#define Order_List_Cell_Indentifier @"FSOrderListCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSOrderListCell *cell = (FSOrderListCell*)[tableView dequeueReusableCellWithIdentifier:Order_List_Cell_Indentifier];
    if (cell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
        if (_array.count > 0) {
            cell = (FSOrderListCell*)_array[0];
        }
        else{
            cell = [[FSOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Order_List_Cell_Indentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.priceLb.textColor = [UIColor colorWithHexString:@"#007f06"];
    cell.orderNumber.textColor = [UIColor colorWithHexString:@"#007f06"];
    cell.crateDate.textColor = [UIColor colorWithHexString:@"#007f06"];
    
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    FSOrderInfo *order = [_likes objectAtIndex:indexPath.section];
    [(FSOrderListCell *)cell setData:order];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSOrderDetailViewController *detailView = [[FSOrderDetailViewController alloc] initWithNibName:@"FSOrderDetailViewController" bundle:nil];
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    FSOrderInfo *item = _likes[indexPath.section];
    detailView.orderno = item.orderno;
    [self.navigationController pushViewController:detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [_dic setValue:@"订单列表页" forKey:@"来源页面"];
    [_dic setValue:[NSString stringWithFormat:@"%@", item.orderno] forKey:@"订单号"];
    [[FSAnalysis instance] logEvent:CHECK_ORDER_DETAIL withParameters:_dic];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    BOOL _noMore = [[_noMoreList objectAtIndex:_currentSelIndex] boolValue];
    if(!_inLoading
       && (scrollView.contentOffset.y+scrollView.frame.size.height) + 150 > scrollView.contentSize.height
       &&scrollView.contentOffset.y>0
       && !_noMore)
    {
        _inLoading = TRUE;
        int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        FSPurchaseRequest *request = [self createRequest:currentPage+1];
        [request send:[FSPagedOrder class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = FALSE;
            if (resp.isSuccess)
            {
                FSPagedOrder *innerResp = resp.responseData;
                if (innerResp.totalPageCount <= currentPage+1)
                    [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
                [self setPageIndex:currentPage+1 selectedSegmentIndex:_currentSelIndex];
                [self mergeLike:innerResp isInsert:YES];
                
                //统计
                NSString *value = _segFilters.selectedIndex==0?@"订单列表-进行中":(_segFilters.selectedIndex==1?@"订单列表-已完成":@"订单列表-已失效");
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                [_dic setValue:value forKey:@"来源"];
                [_dic setValue:[NSString stringWithFormat:@"%d", currentPage+1] forKey:@"页码"];
                [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
}

#pragma mark - AKSegmentedControlDelegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl == _segFilters){
        if (_inLoading) {
            return;
        }
        if(_currentSelIndex == index)
        {
            return;
        }
        _currentSelIndex = index;
        NSMutableArray *source = [_dataSourceList objectAtIndex:index];
        if (source == nil || source.count<=0)
        {
            [self requestData];
        }
        else{
            [self showBlankIcon];
            [_contentView reloadData];
            [_contentView setContentOffset:CGPointZero];
        }
        
        //统计
        NSString *value = index == 0?@"进行中":(index == 1?@"已完成":@"已失效");
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"订单列表页" forKey:@"来源页面"];
        [_dic setValue:value forKey:@"分类名称"];
        [[FSAnalysis instance] logEvent:CHECK_ORDERLIST_TAB withParameters:_dic];
    }
}

@end
