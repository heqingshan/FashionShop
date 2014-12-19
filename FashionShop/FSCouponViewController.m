//
//  FSLikeViewController.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCouponViewController.h"
#import "FSCouponDetailCell.h"
#import "FSCouponProDetailCell.h"
#import "FSCommonUserRequest.h"
#import "FSPagedCoupon.h"
#import "FSModelManager.h"
#import "FSCommonProRequest.h"
#import "FSLocationManager.h"
#import "FSDRViewController.h"

@interface FSCouponViewController ()
{
    FSGiftSortBy _currentSelIndex;
    
    NSMutableArray *_dataSourceList;
    NSMutableArray *_noMoreList;
    NSMutableArray *_pageIndexList;
    NSMutableArray *_refreshTimeList;
    BOOL _inLoading;
}

@end

#define USER_COUPON_TABLE_CELL @"FSCouponDetailCell"
#define USER_COUPON_PRO_TABLE_CELL @"FSCouponProDetailCell"

@implementation FSCouponViewController
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
    self.title = NSLocalizedString(@"My Promotion List",nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    [_contentView registerNib:[UINib nibWithNibName:@"FSCouponDetailCell" bundle:Nil] forCellReuseIdentifier:USER_COUPON_TABLE_CELL];
    [_contentView registerNib:[UINib nibWithNibName:@"FSCouponProDetailCell" bundle:Nil] forCellReuseIdentifier:USER_COUPON_PRO_TABLE_CELL];
    _currentSelIndex = SortByUnUsed;
    
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
        int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        FSCommonUserRequest *request = [self createRequest:currentPage];
        request.previousLatestDate = [_refreshTimeList objectAtIndex:_currentSelIndex];
        _inLoading = YES;
        [request send:[FSPagedCoupon class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            action();
            if (resp.isSuccess)
            {
                FSPagedCoupon *innerResp = resp.responseData;
                if (innerResp.totalPageCount <= currentPage)
                    [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
                [self mergeLike:innerResp isInsert:YES];
                
                [self setRefreshTime:[NSDate date] selectedSegmentIndex:_currentSelIndex];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }];
}

- (void)onButtonBack:(id)sender {
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
    FSCommonUserRequest *request = [self createRequest:currentPage];
    [self beginLoading:self.view];
    _inLoading = YES;
    [request send:[FSPagedCoupon class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:self.view];
        _inLoading = NO;
        if (resp.isSuccess)
        {
            FSPagedCoupon *innerResp = resp.responseData;
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

-(void) mergeLike:(FSPagedCoupon *)response isInsert:(BOOL)isinsert
{
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSCoupon *)obj1 valueForKey:@"id"] isEqualToValue:[(FSCoupon *)obj valueForKey:@"id" ]])
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
//            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Coupon_List", nil)  originOffset:20];
//        }
//        else
        {
            [self showNoResultImage:_contentView withImage:@"blank_coupon.png" withText:NSLocalizedString(@"TipInfo_Coupon_List", nil)  originOffset:100];
        }
    }
    else{
        [self hideNoResultImage:_contentView];
    }
}

-(FSCommonUserRequest *)createRequest:(int)index
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userToken = [FSUser localProfile].uToken;
    request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE];
    request.pageIndex =[NSNumber numberWithInt:index];
    request.sort = [NSNumber numberWithInt:_currentSelIndex+1];
    request.likeType = [NSNumber numberWithInt:_currentSelIndex+1];
    request.routeResourcePath = RK_REQUEST_COUPON_LIST;
    return request;
}

- (void)viewDidUnload {
    [self setSegFilters:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource

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
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    FSCoupon *coupon = [_likes objectAtIndex:indexPath.section];
    UITableViewCell *detailCell = nil;
    if (coupon.producttype == FSSourceProduct)
    {
        detailCell = [_contentView dequeueReusableCellWithIdentifier:USER_COUPON_TABLE_CELL];
        [(FSCouponDetailCell *)detailCell setData:coupon];
    } else
    {
        detailCell = [_contentView dequeueReusableCellWithIdentifier:USER_COUPON_PRO_TABLE_CELL];
        [(FSCouponProDetailCell *)detailCell setData:coupon];
    }
    return detailCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
    FSCouponProDetailCell *cell = (FSCouponProDetailCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSProDetailViewController *detailView = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
    NSMutableArray *_likes = _dataSourceList[_currentSelIndex];
    detailView.navContext = _likes;
    detailView.indexInContext = indexPath.row* [self numberOfSectionsInTableView:tableView] + indexPath.section;
    detailView.sourceType = [(FSCoupon *)[_likes objectAtIndex:detailView.indexInContext] producttype];
    detailView.dataProviderInContext = self;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailView];
    [self presentViewController:navControl animated:true completion:nil];
      [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
    
    //统计
    FSCoupon *coupon = [_likes objectAtIndex:indexPath.section];
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [_dic setValue:@"优惠券列表页" forKey:@"来源页面"];
    [_dic setValue:[NSString stringWithFormat:@"%d", coupon.promotion.id] forKey:@"活动ID"];
    [_dic setValue:coupon.promotion.title forKey:@"活动名称"];
    [_dic setValue:coupon.code forKey:@"优惠券码"];
    [[FSAnalysis instance] logEvent:CHECK_COUPON_DETAIL withParameters:_dic];
    
    [[FSAnalysis instance] autoTrackPages:navControl];
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
        FSCommonUserRequest *request = [self createRequest:currentPage+1];
        [request send:[FSPagedCoupon class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = FALSE;
            if (resp.isSuccess)
            {
                FSPagedCoupon *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=currentPage+1)
                    [self setNoMore:YES selectedSegmentIndex:_currentSelIndex];
                [self setPageIndex:currentPage+1 selectedSegmentIndex:_currentSelIndex];
                [self mergeLike:innerResp isInsert:NO];
                
                //统计
                NSString *value = _segFilters.selectedIndex==0?@"优惠券列表-未使用":(_segFilters.selectedIndex==1?@"优惠券列表-已使用":@"优惠券列表-已无效");
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

#pragma mark - FSProDetailItemSourceProvider

-(void)proDetailViewDataFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index completeCallback:(UICallBackWith1Param)block errorCallback:(dispatch_block_t)errorBlock
{
    __block FSCoupon * favorCurrent = [view.navContext objectAtIndex:index];
    /*
    FSCommonProRequest *request = [[FSCommonProRequest alloc] init];
    request.uToken = [FSModelManager sharedModelManager].loginToken;
    request.routeResourcePath = RK_REQUEST_PRO_DETAIL;
    request.id = [NSNumber numberWithInt:favorCurrent.productid];
    request.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
    request.lantit = [NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    Class respClass;
    if (favorCurrent.producttype == FSSourceProduct)
    {
        request.pType = FSSourceProduct;
        request.routeResourcePath = RK_REQUEST_PROD_DETAIL;
        respClass = [FSProdItemEntity class];
    }
    else
    {
        request.pType = FSSourcePromotion;
        request.routeResourcePath = RK_REQUEST_PRO_DETAIL;
        respClass = [FSProItemEntity class];
        
    }
    [request send:respClass withRequest:request completeCallBack:^(FSEntityBase *resp) {
        if (!resp.isSuccess)
        {
            [view reportError:NSLocalizedString(@"COMM_OPERATE_FAILED", nil)];
            errorBlock();
        }
        else
        {
            block(resp.responseData);
        }
    }];
     */
    
    FSCommonProRequest *drequest = [[FSCommonProRequest alloc] init];
    drequest.uToken = [FSModelManager sharedModelManager].loginToken;
    drequest.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
    drequest.lantit = [NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    Class respClass;
    if (favorCurrent.producttype == FSSourceProduct)
    {
        drequest.pType = FSSourceProduct;
        drequest.routeResourcePath = [NSString stringWithFormat:@"/product/%@",[NSNumber numberWithInt:favorCurrent.productid]];
        respClass = [FSProdItemEntity class];
    }
    else
    {
        drequest.pType = FSSourcePromotion;
        drequest.routeResourcePath = [NSString stringWithFormat:@"/promotion/%@",[NSNumber numberWithInt:favorCurrent.productid]];
        respClass = [FSProItemEntity class];
    }
    [drequest setBaseURL:2];
    [drequest send:respClass withRequest:drequest completeCallBack:^(FSEntityBase *resp) {
        if (!resp.isSuccess)
        {
            [view reportError:NSLocalizedString(@"COMM_OPERATE_FAILED", nil)];
            errorBlock();
        }
        else
        {
            block(resp.responseData);
        }
    }];
}

-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    FSCoupon * favorCurrent = [view.navContext objectAtIndex:index];
    return favorCurrent.producttype;
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
        NSString *value = index == 0?@"未使用":(index == 1?@"已使用":@"已失效");
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"优惠券列表页" forKey:@"来源页面"];
        [_dic setValue:value forKey:@"分类名称"];
        [[FSAnalysis instance] logEvent:CHECK_COUPONT_LIST_TAB withParameters:_dic];
    }
}

@end
