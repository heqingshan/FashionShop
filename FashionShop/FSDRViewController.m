//
//  FSDRViewController.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSDRViewController.h"
#import "FSProdDetailCell.h"
#import "FSProDetailViewController.h"
#import "FSMeViewController.h"
#import "FSLikeViewController.h"

#import "FSCommonUserRequest.h"
#import "FSModelManager.h"
#import "FSProListRequest.h"
#import "FSLocationManager.h"
#import "FSBothItems.h"
#import "FSFavorRequest.h"
#import "FSCommonProRequest.h"
#import "FSPagedFavor.h"
#import "FSProdItemEntity.h"
#import "FSPLetterViewController.h"
#import "FSMessageViewController.h"
#import "FSProDetailViewController.h"

#define DR_DETAIL_CELL @"DRdetailcell"
#define DR_FAVOR_DETAIL_CELL @"DR_FAVOR_DETAIL_CELL"
#define  PROD_LIST_DETAIL_CELL_WIDTH 100
#define ITEM_CELL_WIDTH 100;
#define PROD_PAGE_SIZE 20;
#define LOADINGVIEW_HEIGHT 44

@interface FSDRViewController ()
{
    NSMutableArray *_items;
    FSUser *_daren;
    
    UIActivityIndicatorView *moreIndicator;
    
    int _prodPageIndex;   
    NSDate *_refreshLatestDate;
    NSDate * _firstLoadDate;
    bool _noMoreResult;
    BOOL _isInLoadingMore;
    BOOL _toDetail;//是否是去详情页
}

@end

@implementation FSDRViewController

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
    [self prepareData];
    
    CGRect origFrame = _imgView.frame;
    origFrame.origin.y = _segHeader.frame.origin.y - origFrame.size.height;
    _imgView.frame = origFrame;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"nav_bg_2.png"] forBarMetrics: UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _toDetail = NO;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (!_toDetail) {
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"top_title_bg"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (_toDetail) {
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"top_title_bg"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    [super viewDidDisappear:animated];
}

-(void) bindSegHeader
{
    [_segHeader setDelegate:self];
    UIImage *backgroundImage = [UIImage imageNamed:@"tab_two_bg_normal.png"];
    [_segHeader setBackgroundImage:backgroundImage];
    [_segHeader setContentEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [_segHeader setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segHeader setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [_segHeader setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonPressImage = [UIImage imageNamed:@"tab_two_bg_selected"];
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn1 setTitle:NSLocalizedString(@"Ta Like", nil) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn1.showsTouchWhenHighlighted = YES;
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn2 setTitle:NSLocalizedString(@"Ta Share", nil) forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn2.showsTouchWhenHighlighted = YES;
    
    if ([self isDR]) {
        [_segHeader setButtonsArray:@[btn1, btn2]];
    }
    else {
        [_segHeader setButtonsArray:@[btn1]];
    }
    _segHeader.selectedIndex = 0;
}

-(void)prepareData
{
    [self replaceBackItem];
    FSCommonUserRequest *request = [self createDRRequest];
    [self beginLoading:self.view];
    [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase * resp) {
        [self endLoading:self.view];
        if (resp.isSuccess)
        {
            _daren = resp.responseData;
            if ([_daren.uid intValue] == [[FSUser localProfile].uid intValue]) {
                _touchButn.hidden = YES;
            }
            else{
                _touchButn.hidden = NO;
            }
            [self presentData];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}
-(void) prepareLayout
{
    self.navigationItem.title = NSLocalizedString(@"Ta homepage", nil);
    
    SpringboardLayout *layout = [[SpringboardLayout alloc] init];
    layout.itemWidth = ITEM_CELL_WIDTH;
    layout.columnCount = 3;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.delegate = self;
    
    CGRect rect = _itemsContainer.frame;
    rect.size.height = APP_HIGH - TAB_HIGH - _segHeader.frame.origin.y - _segHeader.frame.size.height;
//    if (IOS7) {
//        rect.size.height += NAV_HIGH;
//    }
    NSArray *array = self.navigationController.viewControllers;
    if (array.count >= 2) {
        id con = array[array.count - 2];
        if ([con isKindOfClass:[FSProDetailViewController class]]) {
            rect.size.height += NAV_HIGH;
        }
    }
    _itemsContainer.frame = rect;
    _itemsView = [[PSUICollectionView alloc] initWithFrame:_itemsContainer.bounds collectionViewLayout:layout];
    _itemsView.backgroundColor = [UIColor whiteColor];
    [_itemsContainer addSubview:_itemsView];
    _itemsView.dataSource = self;
    _itemsView.delegate = self;
    [_itemsView registerClass:[FSProdDetailCell class] forCellWithReuseIdentifier:DR_DETAIL_CELL];
    [_itemsView registerClass:[FSFavorProCell class] forCellWithReuseIdentifier:DR_FAVOR_DETAIL_CELL];
    [self prepareRefreshLayout:_itemsView withRefreshAction:^(dispatch_block_t action) {
        [self refreshContent:TRUE withCallback:^{
            action();
        }];
    }];
    
   
}

-(void) presentData
{
    [self presentData:TRUE];
}

-(void) presentData:(BOOL)isUpdateCollection
{
    UIBarButtonItem *baritemSet= nil;
    if (!_daren.isLiked) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(doLike) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"+关注" forState:UIControlStateNormal];
        btn.titleLabel.font = ME_FONT(13);
        btn.showsTouchWhenHighlighted = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(doLikeRemove) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"取消关注" forState:UIControlStateNormal];
        btn.titleLabel.font = ME_FONT(13);
        btn.showsTouchWhenHighlighted = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    [self.navigationItem setRightBarButtonItem:baritemSet];
    
    if ([FSModelManager sharedModelManager].localLoginUid &&
        [_daren.uid intValue] == [[FSModelManager sharedModelManager].localLoginUid intValue])
    {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    }
    _thumLogo.ownerUser = _daren;
    _thumLogo.delegate = self;
    [_imgView setImageWithURL:_daren.logobgURL placeholderImage:[UIImage imageNamed:@"图形1bb.png"]];
    _lblNickie.text = _daren.nickie;
    _lblNickie.font = ME_FONT(14);
    [_lblNickie sizeToFit];
    [_btnLike setTitle:[NSString stringWithFormat:@"%d",_daren.likeTotal] forState:UIControlStateNormal];
    [_btnLike setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _btnLike.titleLabel.font = ME_FONT(9);
    [_btnFans setTitle:[NSString stringWithFormat:@"%d",_daren.fansTotal] forState:UIControlStateNormal];
    [_btnFans setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    _btnFans.titleLabel.font = ME_FONT(9);
    if (!isUpdateCollection)
        return;
    [self prepareLayout];
    [self bindSegHeader];
    
    [self beginLoading:self.view];
    
    _prodPageIndex = 1;
    FSEntityRequestBase *request = [self createListRequest:_prodPageIndex isRefresh:FALSE];
    if ([self isDR] && _segHeader.selectedIndex == 1)
    {
        [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:self.view];
            if (!resp.isSuccess)
                [self reportError:resp.errorDescrip];
            else
            {
                FSBothItems *result = resp.responseData;
                if (self.isInRefresh)
                    _refreshLatestDate = [[NSDate alloc] init];
                else
                {
                    if (result.totalPageCount < _prodPageIndex+1)
                        _noMoreResult = TRUE;
                }
                [self fillProdInMemory:result.prodItems isInsert:self.isInRefresh];
            }
        }];
    }
    else {
        [request send:[FSPagedDarenFavor class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:self.view];
            if (!resp.isSuccess)
                [self reportError:resp.errorDescrip];
            else
            {
                FSPagedDarenFavor *result = resp.responseData;
                if (self.isInRefresh)
                    _refreshLatestDate = [[NSDate alloc] init];
                else
                {
                    if (result.totalPageCount < _prodPageIndex+1)
                        _noMoreResult = TRUE;
                }
                [self fillFavorInMemory:result.items isInsert:self.isInRefresh];
            }
        }];
 
    }

}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if(!_items)
        _items = [@[] mutableCopy];
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_items indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1)
         {
              if ([[(FSProdItemEntity *)obj1 valueForKey:@"id"] isEqualToValue:[(FSProdItemEntity *)obj valueForKey:@"id"]])
             {
                 return TRUE;
                 *stop1 = TRUE;
             }
             return FALSE;
         }];
        if (index==NSNotFound)
        {
            if (!isinserted)
            {
                [_items addObject:obj];
            } else
            {
                [_items insertObject:obj atIndex:0];
            }
        }
    }];
    
    [_itemsView reloadData];
    if (!_items || _items.count<1)
    {
        //加载空视图
        [self showNoResultImage:_itemsView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_DR_Shared_List", nil)  originOffset:30];
    }
    else
    {
        [self hideNoResultImage:_itemsView];
    }
}

-(void) fillFavorInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if(!_items)
        _items = [@[] mutableCopy];
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_items indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1)
         {
             if ([[(FSProdItemEntity *)obj1 valueForKey:@"id"] isEqualToValue:[(FSFavor *)obj valueForKey:@"id"]])
             {
                 return TRUE;
                 *stop1 = TRUE;
             }
             return FALSE;
         }];
        if (index==NSNotFound)
        {
            if (!isinserted)
            {
                [_items addObject:obj];
            } else
            {
                [_items insertObject:obj atIndex:0];
            }
            
            
        }
    }];
    
    [_itemsView reloadData];
    if (!_items || _items.count<1)
    {
        //加载空视图
//        if (IOS7) {
//            [self showNoResultImage:_itemsView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_DR_Liked_List", nil)  originOffset:0];
//        }
//        else
        {
            [self showNoResultImage:_itemsView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_DR_Liked_List", nil)  originOffset:30];
        }
    }
    else
    {
        [self hideNoResultImage:_itemsView];
    }
}

-(FSCommonUserRequest *)createDRRequest
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userId =[NSNumber numberWithInt:_userId];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.routeResourcePath = RK_REQUEST_DAREN_DETAIL;
    return request;
}


-(FSEntityRequestBase *)createListRequest:(int)page isRefresh:(BOOL)isRefresh
{
    if (_daren.userLevelId == FSDARENUser && _segHeader.selectedIndex == 1)
    {
        FSProListRequest *request = [[FSProListRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_PROD_DR_LIST;
        request.longit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        if(isRefresh)
        {
            request.requestType = 0;
            request.previousLatestDate = _refreshLatestDate;
        }
        else
        {
            request.requestType = 1;
            request.previousLatestDate = _firstLoadDate;
        }
        request.nextPage = page;
        request.pageSize = COMMON_PAGE_SIZE;
        request.drUserId = [NSNumber numberWithInt:_userId];
        return request;
    }
    else
    {
        FSFavorRequest *request = [[FSFavorRequest alloc] init];
        //request.userToken = [FSModelManager sharedModelManager].loginToken;
        request.productType = FSSourceProduct;
        request.routeResourcePath = RK_REQUEST_FAVOR_PROD_LIST;//RK_REQUEST_FAVOR_LIST;
        request.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE] ;
        if (isRefresh)
            request.nextPage = @1;
        else
            request.nextPage =[NSNumber numberWithInt:page];
        request.userid = [NSNumber numberWithInt:_userId];
        return request;
        
    }
 
}

-(void)doLike
{
    [self doLike:FALSE];
}
-(void)doLikeRemove
{
    [self doLike:TRUE];
}

-(void)doLike:(BOOL)isRemove
{
    [FSModelManager localLogin:self withBlock:^{
        [self internalDoLike:isRemove];
    }];
}

-(void) internalDoLike:(BOOL)isRemove withCallback:(dispatch_block_t)cleanup
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.likeUserId =[NSString stringWithFormat:@"%@",_daren.uid];
    request.routeResourcePath =isRemove?RK_REQUEST_LIKE_REMOVE: RK_REQUEST_LIKE_DO;
    __block FSDRViewController *blockSelf = self;
    
    [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *respData){
        if (!respData.isSuccess)
        {
            [blockSelf updateProgress:respData.errorDescrip];
        }
        else
        {
            //FSUser *newUser =  respData.responseData;
            [blockSelf updateProgress:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
            blockSelf->_daren.isLiked = !isRemove;
            [blockSelf presentData:FALSE];
        }
        if (cleanup)
            cleanup();
    }];
    
    
}

-(void) internalDoLike:(BOOL)isRemove
{
    FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.likeUserId =[NSString stringWithFormat:@"%@",_daren.uid];
    request.routeResourcePath =isRemove?RK_REQUEST_LIKE_REMOVE: RK_REQUEST_LIKE_DO;
    __block FSDRViewController *blockSelf = self;
    [self updateLikeButtonStatus:isRemove canClick:FALSE];
    self.navigationItem.rightBarButtonItem.enabled = false;
    [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *respData){
        if (!respData.isSuccess)
        {
            [blockSelf updateLikeButtonStatus:!isRemove canClick:FALSE];
        }
        else
        {
            blockSelf->_daren.isLiked = !isRemove;
            FSUser *localUser = (FSUser *)[FSUser localProfile];
            NSLog(@"localUser.likeTotal:%d", localUser.likeTotal);
            if (isRemove)
            {
                blockSelf->_daren.fansTotal--;
                if (blockSelf->_daren.fansTotal < 0) {
                    blockSelf->_daren.fansTotal = 0;
                }
                localUser.likeTotal --;
                if (localUser.likeTotal < 0) {
                    localUser.likeTotal = 0;
                }
            } else {
                blockSelf->_daren.fansTotal++;
                localUser.likeTotal ++;
            }
            [blockSelf->_btnFans setTitle:[NSString stringWithFormat:@"%d",blockSelf->_daren.fansTotal] forState:UIControlStateNormal];
        }
        self.navigationItem.rightBarButtonItem.enabled = true; 
    }];
}
-(void) updateLikeButtonStatus:(BOOL)canLike canClick:(BOOL)isClickable
{
    UIBarButtonItem *baritemSet= nil;
    if (canLike) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(doLike) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"+关注" forState:UIControlStateNormal];
        btn.titleLabel.font = ME_FONT(13);
        btn.showsTouchWhenHighlighted = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(doLikeRemove) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"取消关注" forState:UIControlStateNormal];
        btn.titleLabel.font = ME_FONT(13);
        btn.showsTouchWhenHighlighted = YES;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
        [btn sizeToFit];
        baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    [self.navigationItem setRightBarButtonItem:baritemSet];
    
}
-(BOOL)isDR
{
    return _daren.userLevelId == FSDARENUser;
}

-(void)refreshContent:(BOOL)isRefresh withCallback:(dispatch_block_t)callback
{
    int nextPage = 1;
    if (!isRefresh)
    {
        _prodPageIndex++;
        nextPage = _prodPageIndex;
    }
    else {
        _prodPageIndex = 1;
        _noMoreResult = NO;
        [_items removeAllObjects];
    }
    FSEntityRequestBase *request = [self createListRequest:nextPage isRefresh:isRefresh];
    if ([self isDR] && _segHeader.selectedIndex == 1)
    {
        [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            callback();
            if (resp.isSuccess)
            {
                FSBothItems *result = resp.responseData;
                if (isRefresh)
                    _refreshLatestDate = [[NSDate alloc] init];
                else
                {
                    if (result.totalPageCount < _prodPageIndex+1)
                        _noMoreResult = TRUE;
                }
                [self fillProdInMemory:result.prodItems isInsert:isRefresh];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    } else
    {
        [request send:[FSPagedDarenFavor class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            callback();
            if (resp.isSuccess)
            {
                FSPagedDarenFavor *result = resp.responseData;
                if (isRefresh)
                    _refreshLatestDate = [[NSDate alloc] init];
                else
                {
                    if (result.totalPageCount < _prodPageIndex+1)
                        _noMoreResult = TRUE;
                }
                [self fillFavorInMemory:result.items isInsert:isRefresh];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];

    }
    
}

-(void)loadMore
{
    [self beginLoadMoreLayout:_itemsView];
    _isInLoadingMore = TRUE;
    
    [self refreshContent:FALSE withCallback:^{
        [self endLoadMore:_itemsView];
        _isInLoadingMore = FALSE;
        
        //统计
        NSString *value = _segHeader.selectedIndex==0?@"达人详情页-Ta喜欢":@"达人详情页-Ta分享";
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:value forKey:@"来源"];
        [_dic setValue:[NSString stringWithFormat:@"%d", _prodPageIndex+1] forKey:@"页码"];
        [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
    }];
}


- (void)loadImagesForOnscreenRows
{
    if ([_items count] > 0)
    {
        NSArray *visiblePaths = [_itemsView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            id<ImageContainerDownloadDelegate> cell = (id<ImageContainerDownloadDelegate>)[_itemsView cellForItemAtIndexPath:indexPath];
            int width = ITEM_CELL_WIDTH;
            int height = [(PSUICollectionViewCell *)cell frame].size.height - 40;
            [cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
            
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    [self loadImagesForOnscreenRows];
    if (!_noMoreResult &&
        !_isInLoadingMore &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 150> scrollView.contentSize.height
        && scrollView.contentSize.height>scrollView.frame.size.height
        &&scrollView.contentOffset.y>0)
    {
        [self loadMore];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - PSUICollectionView Datasource

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return _items.count;
    
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = ([self isDR] && _segHeader.selectedIndex == 1)?DR_DETAIL_CELL:DR_FAVOR_DETAIL_CELL;
    PSUICollectionViewCell * cell = [cv dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (_items.count <= 0) {
        return cell;
    }
    id item = [_items objectAtIndex:indexPath.row];
    [(id)cell setData:item];
    if (_segHeader.selectedIndex == 0) {
        if ([item isKindOfClass:[FSProdItemEntity class]]) {
            FSProdItemEntity *_fav = (FSProdItemEntity*)item;
            if (_fav.hasPromotion) {
                [(FSFavorProCell *)cell showProIcon];
            }
            else {
                [(FSFavorProCell *)cell hidenProIcon];
            }
        }
    }
    else if(_segHeader.selectedIndex == 1){
        if ([item isKindOfClass:[FSProdItemEntity class]]) {
            FSProdItemEntity *_fav = (FSProdItemEntity*)item;
            if (_fav.hasPromotion) {
                [(FSProdDetailCell *)cell showProIcon];
            }
            else {
                [(FSProdDetailCell *)cell hidenProIcon];
            }
            if (_fav.isCanBuyFlag) {
                [(FSProdDetailCell *)cell showProBag];
            }
            else {
                [(FSProdDetailCell *)cell hidenProBag];
            }
        }
    }
    int width = PROD_LIST_DETAIL_CELL_WIDTH;
    int height = cell.frame.size.height;
    [(id<ImageContainerDownloadDelegate>)cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
    
    return cell;
}

#pragma mark - PSUICollectionViewDelegate


- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSProDetailViewController *detailViewController = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
    int index = indexPath.row*[self numberOfSectionsInCollectionView:collectionView] + indexPath.section;
    detailViewController.navContext = _items;
    detailViewController.dataProviderInContext = self;
    detailViewController.indexInContext = index;
    detailViewController.sourceType = FSSourceProduct;
    _toDetail = YES;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self presentViewController:navControl animated:YES completion:nil];
    
    if (detailViewController.sourceType == FSSourceProduct) {
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic setValue:@"达人详情页" forKey:@"来源页面"];
        [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
    }
    
    [[FSAnalysis instance] autoTrackPages:navControl];
}

-(void)collectionView:(PSUICollectionView *)collectionView didEndDisplayingCell:(PSUICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(willRemoveFromView)])
        [(id)cell willRemoveFromView];
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * resources = nil;
    if ([self isDR] && _segHeader.selectedIndex == 1)
    {
        resources = [[_items objectAtIndex:indexPath.row] resource];
    } else
    {
        resources = [(FSProdItemEntity *)[_items objectAtIndex:indexPath.row] resource];
    }
    FSResource * resource = resources&&resources.count>0?[resources objectAtIndex:0]:nil;
    float totalHeight = 0.0f;
    if (resource &&
        resource.width>0 &&
        resource.height>0)
    {
        int cellWidth = ITEM_CELL_WIDTH;
        float imgHeight = (cellWidth * resource.height)/(resource.width);
        totalHeight = totalHeight+imgHeight;
    } else
    {
        totalHeight = CollectionView_Default_Height;
    }
    return totalHeight;
}


#pragma FSProDetailItemSourceProvider
-(void)proDetailViewDataFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index  completeCallback:(UICallBackWith1Param)block errorCallback:(dispatch_block_t)errorBlock
{
    if ([self isDR] && _segHeader.selectedIndex == 1)
    {
        FSProdItemEntity *item =  [view.navContext objectAtIndex:index];
        if (item)
            block(item);
        else
            errorBlock();
    }
    else {
        __block FSProdItemEntity * favorCurrent = [view.navContext objectAtIndex:index];
        
        FSCommonProRequest *drequest = [[FSCommonProRequest alloc] init];
        drequest.uToken = [FSModelManager sharedModelManager].loginToken;
        drequest.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        drequest.lantit = [NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        Class respClass;
        drequest.pType = FSSourceProduct;
        drequest.routeResourcePath = [NSString stringWithFormat:@"/product/%@",[NSNumber numberWithInt:favorCurrent.id]];
        respClass = [FSProdItemEntity class];
        /*
        if (favorCurrent.sourceType == FSSourceProduct)
        {
            drequest.pType = FSSourceProduct;
            drequest.routeResourcePath = [NSString stringWithFormat:@"/product/%@",[NSNumber numberWithInt:favorCurrent.sourceId]];
            respClass = [FSProdItemEntity class];
        }
        else
        {
            drequest.pType = FSSourcePromotion;
            drequest.routeResourcePath = [NSString stringWithFormat:@"/promotion/%@",[NSNumber numberWithInt:favorCurrent.sourceId]];
            respClass = [FSProItemEntity class];
        }
         */
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
}

-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return FSSourceProduct;
}
-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return [self isDR] && _segHeader.selectedIndex == 1;
}

- (BOOL) isDeletionModeActiveForCollectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout
{
    return FALSE;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setItemsContainer:nil];
    [self setThumLogo:nil];
    [self setSegHeader:nil];
    [self setImgView:nil];
    [self setTouchButn:nil];
    [super viewDidUnload];
}
- (IBAction)goLikeView:(id)sender {
    FSLikeViewController *likeView = [[FSLikeViewController alloc] initWithNibName:@"FSLikeViewController" bundle:nil];
    likeView.likeType = 0;
    likeView.currentUser = _daren;
    likeView.searchById = true;
    likeView.navigationItem.title = NSLocalizedString(@"Ta likes persons", nil);
    [self.navigationController pushViewController:likeView animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"达人详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_LIKE_LIST withParameters:nil];
}

- (IBAction)goFanView:(id)sender {
    FSLikeViewController *likeView = [[FSLikeViewController alloc] initWithNibName:@"FSLikeViewController" bundle:nil];
    likeView.likeType = 1;
    likeView.currentUser = _daren;
    likeView.searchById = TRUE;
    likeView.navigationItem.title = NSLocalizedString(@"Ta fans", nil);
    [self.navigationController pushViewController:likeView animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"达人详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_FANS_LIST withParameters:_dic];
}

- (IBAction)contact:(id)sender {
    FSMessageViewController *viewController = [[FSMessageViewController alloc] init];
    viewController.touchUser = _daren;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:YES completion:nil];
    
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [_dic setValue:@"达人详情页" forKey:@"来源页面"];
    [_dic setValue:viewController.touchUser.nickie forKey:@"私信对象名称"];
    [_dic setValue:viewController.touchUser.uid forKey:@"私信对象ID"];
    [[FSAnalysis instance] logEvent:CHECK_MESSAGE_PAGE withParameters:_dic];
}

#pragma mark - FSThumbView Delegate

-(void)didTapThumView:(id)sender
{
    FSAvatarHDViewController *controller = [[FSAvatarHDViewController alloc] init];
    [controller setImageURL:_thumLogo.ownerUser.thumnailUrlOrigin];
    controller.avatarImg = [_thumLogo getThumbImage];
    CGRect _rect = _thumLogo.frame;
    _rect.origin.y += NAV_HIGH;
    controller.beginRect = _rect;
    controller.delegate = self;
    [self presentViewController:controller animated:NO completion:nil];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [_dic setValue:@"达人详情页" forKey:@"来源页面"];
    [_dic setValue:nil forKey:@"标题"];
    [[FSAnalysis instance] logEvent:CHECK_BIG_IMAGE withParameters:_dic];
}

#pragma mark - FSAvatarHDViewDelegate

-(void)hiddenHDUserImg:(FSAvatarHDViewController*)controller
{
    [controller dismissViewControllerAnimated:NO completion:nil];
    UIImageView *_imgV = [[UIImageView alloc] initWithImage:controller.avatarImg];
    _imgV.contentMode = UIViewContentModeScaleAspectFill;
    _imgV.clipsToBounds = YES;
    CGRect _rect = controller.avatarImgV.frame;
    _rect.origin.y -= NAV_HIGH;
    _imgV.frame = _rect;
    [self.view addSubview:_imgV];
    _rect = controller.beginRect;
    _rect.origin.y -= NAV_HIGH;
    
    [UIView animateWithDuration:0.3 animations:^{
        _imgV.frame = _rect;
    } completion:^(BOOL finished) {
        [_imgV removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark AKSegmentedControlDelegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl == _segHeader){
        [self beginLoading:self.view];
        [self refreshContent:YES withCallback:^{
            [self endLoading:self.view];
        }];
    }
}

@end
