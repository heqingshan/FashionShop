//
//  FSPointGiftListViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPointGiftListViewController.h"
#import "FSPointGiftDetailViewController.h"
#import "FSPointGiftListCell.h"
#import "FSCommonUserRequest.h"
#import "FSExchangeRequest.h"
#import "FSPagedGiftList.h"
#import "FSExchange.h"

#define Point_Gift_List_Cell_Indentifier @"PointGiftListCell"

@interface FSPointGiftListViewController ()
{
    FSGiftSortBy _currentSelIndex;
    
    NSMutableArray *_dataSourceList;
    NSMutableArray *_noMoreList;
    NSMutableArray *_pageIndexList;
    NSMutableArray *_refreshTimeList;
    BOOL _inLoading;
}

@end

@implementation FSPointGiftListViewController

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
    self.title = NSLocalizedString(@"Point Exchange List", nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    _currentSelIndex = 0;
    
    [self initArray];
    [self setFilterType];
    
    _currentSelIndex = SortByUnUsed;
    _contentView.backgroundView = nil;
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    
    [self prepareRefreshLayout:_contentView withRefreshAction:^(dispatch_block_t action) {
        if (_inLoading)
        {
            action();
            return;
        }
        int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        [self setPageIndex:currentPage selectedSegmentIndex:_segFilters.selectedIndex];
        FSExchangeRequest *request = [self createRequest:currentPage];
        _inLoading = YES;
        [request send:[FSPagedGiftList class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            action();
            if (resp.isSuccess)
            {
                FSPagedGiftList *innerResp = resp.responseData;
                if (innerResp.totalPageCount <= currentPage)
                    [self setNoMore:YES selectedSegmentIndex:_segFilters.selectedIndex];
                [self mergeLike:innerResp isInsert:NO];
                
                [self setRefreshTime:[NSDate date] selectedSegmentIndex:_segFilters.selectedIndex];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
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
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn1 setTitle:NSLocalizedString(@"ExchangeList_UnUsed", nil) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn1.showsTouchWhenHighlighted = YES;
    //[btn1 setTitleColor:[UIColor colorWithHexString:@"#007f06"] forState:UIControlStateNormal];
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn2 setTitle:NSLocalizedString(@"ExchangeList_Used", nil) forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn2.showsTouchWhenHighlighted = YES;
    //[btn2 setTitleColor:[UIColor colorWithHexString:@"#e5004f"] forState:UIControlStateNormal];
    
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn3 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn3 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn3 setTitle:NSLocalizedString(@"ExchangeList_Disable", nil) forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn3.showsTouchWhenHighlighted = YES;
    //[btn3 setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
    
    [_segFilters setButtonsArray:@[btn1, btn2, btn3]];
    _segFilters.selectedIndex = 0;
}

-(void)initArray
{
    _dataSourceList = [@[] mutableCopy];
    _pageIndexList = [@[] mutableCopy];
    _noMoreList = [@[] mutableCopy];
    _refreshTimeList = [@[] mutableCopy];
    
    for (int i = 0; i < 3; i++) {
        [_dataSourceList insertObject:[@[] mutableCopy] atIndex:i];
        [_pageIndexList insertObject:@1 atIndex:i];
        [_noMoreList insertObject:@NO atIndex:i];
        [_refreshTimeList insertObject:[NSDate date] atIndex:i];
    }
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

-(void) requestData
{
    int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
    [self setPageIndex:currentPage selectedSegmentIndex:_currentSelIndex];
    FSExchangeRequest *request = [self createRequest:currentPage];
    [self beginLoading:self.view];
    _inLoading = YES;
    [request send:[FSPagedGiftList class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:self.view];
        _inLoading = NO;
        if (resp.isSuccess)
        {
            FSPagedGiftList *innerResp = resp.responseData;
            if (innerResp.totalPageCount <= currentPage)
                [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
            [self mergeLike:innerResp isInsert:NO];
            
            [self setRefreshTime:[NSDate date] selectedSegmentIndex:_currentSelIndex];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void) mergeLike:(FSPagedGiftList *)response isInsert:(BOOL)isinsert
{
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSGiftListItem *)obj1 valueForKey:@"id"] isEqualToValue:[(FSGiftListItem *)obj valueForKey:@"id" ]])
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
        if (IOS7) {
            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Coupon_None_Gift", nil)  originOffset:20];
        }
        else
        {
            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Coupon_None_Gift", nil)  originOffset:100];
        }
    }
    else{
        [self hideNoResultImage:_contentView];
    }
}

-(FSExchangeRequest *)createRequest:(int)index
{
    FSExchangeRequest *request = [[FSExchangeRequest alloc] init];
    request.pageSize = COMMON_PAGE_SIZE;
    request.nextPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
    request.type = _currentSelIndex+1;
    request.userToken = [FSUser localProfile].uToken;
    request.routeResourcePath = RK_REQUEST_STOREPROMOTION_COUPON_LIST;
    return request;
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setSegFilters:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    return _likes?_likes.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSPointGiftListCell *cell = (FSPointGiftListCell*)[tableView dequeueReusableCellWithIdentifier:Point_Gift_List_Cell_Indentifier];
    if (cell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPointGiftListCell" owner:self options:nil];
        if (_array.count > 0) {
            cell = (FSPointGiftListCell*)_array[0];
        }
        else{
            cell = [[FSPointGiftListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Point_Gift_List_Cell_Indentifier];
        }
    }
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    [cell setData:_likes[indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSPointGiftDetailViewController *controller = [[FSPointGiftDetailViewController alloc] initWithNibName:@"FSPointGiftDetailViewController" bundle:nil];
    FSGiftListItem *item = [_dataSourceList[_currentSelIndex] objectAtIndex:indexPath.section];
    controller.requestID = item.id;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [_dic setValue:@"代金券列表页" forKey:@"来源页面"];
    [_dic setValue:item.promotion.name forKey:@"活动名称"];
    [_dic setValue:item.giftCode forKey:@"优惠券码"];
    [[FSAnalysis instance] logEvent:CHECK_CASH_COUPON_DETAIL withParameters:_dic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
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
        FSExchangeRequest *request = [self createRequest:currentPage+1];
        [request send:[FSPagedGiftList class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = FALSE;
            if (resp.isSuccess)
            {
                FSPagedGiftList *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=currentPage+1)
                    [self setNoMore:YES selectedSegmentIndex:_segFilters.selectedIndex];
                [self setPageIndex:currentPage+1 selectedSegmentIndex:_segFilters.selectedIndex];
                [self mergeLike:innerResp isInsert:NO];
                
                //统计
                NSString *value = _segFilters.selectedIndex==0?@"代金券列表-未使用":(_segFilters.selectedIndex==1?@"代金券列表-已使用":@"代金券列表-已无效");
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

#pragma mark -
#pragma mark AKSegmentedControlDelegate

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
        NSString *value = index == 0?@"未使用":(index == 1?@"已使用":@"已失效");
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"代金券列表页" forKey:@"来源页面"];
        [_dic setValue:value forKey:@"分类名称"];
        [[FSAnalysis instance] logEvent:CHECK_COUPONT_LIST_TAB withParameters:_dic];
    }
}

@end
