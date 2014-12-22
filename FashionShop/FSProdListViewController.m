//
//  FSProdListViewController.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProdListViewController.h"
#import "FSProdDetailCell.h"
#import "FSProdTagCell.h"
#import "FSProDetailViewController.h"
#import "FSProductListViewController.h"
#import "FSFeedbackViewController.h"
#import "FSCommonRequest.h"
#import "FSBrand.h"

#import "FSTag.h"
#import "FSProListRequest.h"
#import "FSResource.h"
#import "FSLocationManager.h"
#import "FSBothItems.h"
#import "FSModelManager.h"
#import "FSConfigListRequest.h"
#import "FSKeyword.h"

#import "NSString+Extention.h"

#define  PROD_LIST_TAG_CELL @"FSProdListTagCell"
#define PROD_LIST_DETAIL_CELL @"FSProdListDetailCell"
#define  PROD_LIST_DETAIL_CELL_WIDTH 100
#define LOADINGVIEW_HEIGHT 44
#define ITEM_CELL_WIDTH 100
#define DEFAULT_TAG_WIDTH 50
#define Tag_Swip_View_Tag 200
#define Default_SearchBar_Tag 201
#define Tag_Item_Height 27
#define Tag_View_Height 52

@implementation FSSearchBar

- (void)layoutSubviews {
    [NSString logControl:self];
    self.autoresizesSubviews = YES;
	NSUInteger numViews = [self.subviews count];
	for(int i = 0; i < numViews; i++) {
        id cc = [self.subviews objectAtIndex:i];
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_select.png"] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
            cancel = btn;
        }
        if ([cc isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *seg = (UISegmentedControl*)cc;
            [seg addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        }
	}
    
    [self setCancelButtonEnable:YES];
	[super layoutSubviews];
}

-(void)setCancelButtonEnable:(BOOL)_enable
{
    [cancel setEnabled:YES];
    if (cancel) {
        [cancel setEnabled:_enable];
    }
    else{
        NSUInteger numViews = [self.subviews count];
        for(int i = 0; i < numViews; i++) {
            id cc = [self.subviews objectAtIndex:i];
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setEnabled:_enable];
                cancel = btn;
            }
        }
    }
}

-(void)valueChanged:(UISegmentedControl *)sender
{
    if (_segmentDelegate && [_segmentDelegate respondsToSelector:@selector(segmentValueChanged:)]) {
        [_segmentDelegate segmentValueChanged:sender];
    }
}

-(void)ChangeSegmentFont:(UIView *)aView
{
    if ([aView isKindOfClass:[UILabel class]]) {
        UILabel *lb = (UILabel*)aView;
        [lb setTextAlignment:UITextAlignmentCenter];
        CGRect _rect = lb.frame;
        _rect.size.width = 103;
        lb.frame = _rect;
        [lb setFont:[UIFont systemFontOfSize:14]];
        lb.textColor = [UIColor blackColor];
        lb.shadowOffset = CGSizeMake(0, 0);
    }
    NSArray *na = [aView subviews];
    NSEnumerator *ne = [na objectEnumerator];
    UIView *subView;
    while (subView = [ne nextObject]) {
        [self ChangeSegmentFont:subView];
    }
}

@end

@interface FSProdListViewController ()
{
    NSMutableArray *_prods;
    NSMutableArray *_prodKeywords;
    NSMutableArray *_brandKeywords;
    NSMutableArray *_stores;
    NSMutableArray *_tags;
    
    BOOL _isInLoading;
    BOOL _firstTimeLoadDone;
    int _selectedTagIndex;
    int _prodPageIndex;
    CGFloat _actualTagWidth;
    NSInteger _selectedIndex;
    
    NSDate *_refreshLatestDate;
    NSDate * _firstLoadDate;
    FSTag * _currentTag;
    
    bool _noMoreResult;
    BOOL _isSearching;
    
    UIView *searchFilterView;
    BOOL isSwipToUp;
    BOOL isAnimating;
    
    UIImageView *imageTagBgV;
    FSTag *_currentSelTag;
    BOOL _isFirstSearch;
}

@property(nonatomic, strong, readwrite) FSSearchBar *searchBar;
@property(nonatomic, strong) UITableView *tableSearch;

@end

@implementation FSProdListViewController

-(void)initSearchBar
{
    //字体
    NSDictionary *textAttibutesUnSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIFont systemFontOfSize:14],UITextAttributeFont,
                                             [UIColor blackColor],UITextAttributeTextColor,
                                             [NSValue valueWithCGSize:CGSizeMake(0, 0)],UITextAttributeTextShadowOffset,nil];
    NSDictionary *textAttibutesSelected = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:14],UITextAttributeFont,
                                           [UIColor redColor],UITextAttributeTextColor,
                                           [NSValue valueWithCGSize:CGSizeMake(0, 0)],UITextAttributeTextShadowOffset,nil];
    [self.searchBar setScopeBarButtonTitleTextAttributes:textAttibutesUnSelected forState:UIControlStateNormal];
    [self.searchBar setScopeBarButtonTitleTextAttributes:textAttibutesSelected forState:UIControlStateSelected];
    
    self.searchBar.backgroundImage = [UIImage imageNamed:@"top_title_bg.png"];
    self.searchBar.backgroundColor = [UIColor blackColor];
    self.searchBar.clipsToBounds = YES;
    
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"search_input.png"] forState:UIControlStateNormal];
}

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
    [self prepareLayout];
    
    _isFirstSearch = YES;
    UISearchBar *_bar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, 320, 24)];
    _bar.placeholder = NSLocalizedString(@"Search Bar PlaceHolder String", nil);
    _bar.backgroundColor = [UIColor clearColor];
    _bar.delegate = self;
    _bar.tag = Default_SearchBar_Tag;
    [self.navigationItem setTitleView:_bar];
    for (UIView *subview in _bar.subviews) {
		if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
			[subview removeFromSuperview];
			break;
		}
	}
}

-(void)onSearch:(UIButton*)sender
{
    if (!_tableSearch) {
        self.searchBar = [[FSSearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.searchBar.placeholder = NSLocalizedString(@"Search Bar PlaceHolder String", nil);
        self.searchBar.delegate = self;
        self.searchBar.showsScopeBar = YES;
        self.searchBar.selectedScopeButtonIndex = 0;
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Hot Keys Desc", nil),NSLocalizedString(@"Hot Brands Desc", nil),NSLocalizedString(@"Stores", nil), nil];
        self.searchBar.tintColor = RGBCOLOR(246, 246, 246);
        self.searchBar.segmentDelegate = self;
        self.searchBar.showsCancelButton = YES;
        _selectedIndex = 0;
        [self initSearchBar];
        [self segmentValueChanged:nil];
        
        CGRect _rect = self.view.bounds;
        if(!IOS7) {
            _rect.size.height += NAV_HIGH;
        }
        _tableSearch = [[UITableView alloc] initWithFrame:_rect];
        _tableSearch.backgroundView = nil;
        _tableSearch.separatorColor = [UIColor lightGrayColor];
        _tableSearch.backgroundColor = APP_TABLE_BG_COLOR;
        _tableSearch.dataSource = self;
        _tableSearch.delegate = self;
        _tableSearch.showsVerticalScrollIndicator = YES;
        [self.view addSubview:_tableSearch];
    }
    self.wantsFullScreenLayout = NO;
    _tableSearch.contentOffset = CGPointMake(0, 0);
    if(!_isSearching){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.view addSubview:_tableSearch];
        _isSearching = YES;
    }
    else {
        [_tableSearch removeFromSuperview];
    }
    
    if (!_prodKeywords && !_brandKeywords) {
        _prodKeywords = nil;
        _brandKeywords = nil;
        _stores = nil;
        FSCommonRequest *request = [[FSCommonRequest alloc] init];
        [request setRouteResourcePath:RK_REQUEST_KEYWORD_LIST];
        __block FSProdListViewController *blockSelf = self;
        [request send:[FSKeyword class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (resp.isSuccess)
            {
                FSKeyword *result = resp.responseData;
                _prodKeywords = [NSMutableArray arrayWithArray:result.keyWords];
                _brandKeywords = [NSMutableArray arrayWithArray:result.brandWords];
                _stores = [NSMutableArray arrayWithArray:result.stores];
                [_tableSearch reloadData];
                [self.searchBar becomeFirstResponder];
            }
            else
            {
                [blockSelf reportError:resp.errorDescrip];
            }
        }];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if (!_firstTimeLoadDone)
    {
        if (_tags.count>0)
        {
            [_cvTags selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:TRUE scrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally];
            [self collectionView:_cvTags didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [self resetTagFrameIfNeed];
            _firstTimeLoadDone  = true;
        }
        else
        {
            [self prepareData];
        }
    }
    //统计
    [[FSAnalysis instance] logEvent:CHECK_DONGDONG_PAGE withParameters:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endLoading:self.view];
}

-(void) prepareData
{
    _prods = [@[] mutableCopy];
    _tags = theApp.allTags;
     _actualTagWidth = 0;
    [self zeroMemoryBlock];
    if (!_tags ||
        _tags.count<1)
    {
        [self beginLoading:_cvTags];
        __block FSProdListViewController *blockSelf = self;
        FSConfigListRequest *request = [[FSConfigListRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_CONFIG_TAG_ALL;
        [request send:[FSTag class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [blockSelf endLoading:_cvTags];
            if (_tags.count>0) {
                return;
            }
            NSMutableArray *array = [NSMutableArray array];
            int len = [resp.responseData count];
            for (int i = len-1; i >= 0; i--) {
                [array addObject:[resp.responseData objectAtIndex:i]];
            }
            theApp.allTags = array;
            _tags = theApp.allTags;
            [blockSelf endPrepareData];
        }];
    }
    else
    {
        [self endPrepareData];
    }
}

-(void)endPrepareData
{
    if (!_tags ||
        _tags.count<1)
        return;
    [_cvTags reloadData];
}

-(void) zeroMemoryBlock
{
    _prodPageIndex = 0;
    _noMoreResult= FALSE;
}

-(void)resetTagFrameIfNeed
{
    if (_actualTagWidth+5<self.view.frame.size.width)
    {
        CGFloat offset = self.view.frame.size.width - _actualTagWidth-5;
        CGRect origiFrame = _cvTags.frame;
        origiFrame.origin.x = offset/2;
        [_cvTags setFrame:origiFrame];
    }
}

-(void) prepareLayout
{
    [self initTagView];
    [self reCreateContentView];
    [self addSwipView];
}

-(void)initTagView {
    self.navigationItem.title = NSLocalizedString(@"Products", nil);
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(DEFAULT_TAG_WIDTH, Tag_Item_Height);
    layout.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    
    int lineCount = _tags.count/5 + (_tags.count%5==0?0:1);
    int height = (lineCount) * Tag_Item_Height;
    CGRect _tagRect = CGRectMake(0, 0, SCREEN_WIDTH, height + 5000);
    if (IOS7) {
        _tagRect.origin.y += NAV_HIGH;
    }
    
    imageTagBgV = [[UIImageView alloc] initWithFrame:_tagRect];
    NSString *vString = [[[UIDevice currentDevice] systemVersion] substringToIndex:1];
    if ([vString intValue] >= 6) {
        UIImage *image = [[UIImage imageNamed:@"tag_bg_2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        imageTagBgV.image = image;
    }
    else{
        imageTagBgV.image = [[UIImage imageNamed:@"tag_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(-5, 10, -5, 10)];
    }
    imageTagBgV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imageTagBgV];
    
    _tagRect.size.height = Tag_View_Height - 15;
    _cvTags = [[PSUICollectionView alloc] initWithFrame:_tagRect collectionViewLayout:layout];
    _cvTags.scrollEnabled = NO;
    [self.view addSubview:_cvTags];
    [_cvTags registerClass:[FSProdTagCell class] forCellWithReuseIdentifier:PROD_LIST_TAG_CELL];
    _cvTags.showsHorizontalScrollIndicator = NO;
    _cvTags.delegate = self;
    _cvTags.dataSource = self;
    _cvTags.clipsToBounds = YES;
    if ([vString intValue] >= 6) {
        _cvTags.backgroundColor = [UIColor clearColor];
    }
    else {
        _cvTags.backgroundColor = APP_TABLE_BG_COLOR;
    }
}

-(void)addSwipView
{
    CGRect _rect = _cvTags.bounds;
    _rect.size.height = 15;
    _rect.origin.y = _cvTags.frame.size.height + _cvTags.frame.origin.y;
    
    UIView *view = [[UIView alloc] initWithFrame:_rect];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:view.bounds];
    imageV.image = [UIImage imageNamed:@"tag_arrow.png"];
    imageV.tag = Tag_Swip_View_Tag + 30;
    [view addSubview:imageV];
    view.tag = Tag_Swip_View_Tag;
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gesture.direction = UISwipeGestureRecognizerDirectionUp;
    [_cvTags addGestureRecognizer:gesture];
    gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gesture.direction = UISwipeGestureRecognizerDirectionDown;
    [_cvTags addGestureRecognizer:gesture];
    
    UITapGestureRecognizer *viewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [view addGestureRecognizer:viewGesture];
    
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

-(void)reCreateContentView
{
    SpringboardLayout *clayout = [[SpringboardLayout alloc] init];
    clayout.itemWidth = ITEM_CELL_WIDTH;
    clayout.columnCount = 3;
    clayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    clayout.delegate = self;
    
    CGRect _contentRect = CGRectMake(0, _cvTags.frame.origin.y + Tag_View_Height, SCREEN_WIDTH, 0);
    _contentRect.size.height = APP_HIGH - TAB_HIGH - NAV_HIGH - _contentRect.origin.y;
    if (IOS7) {
        _contentRect.size.height += NAV_HIGH;
    }
    _cvContent = [[PSUICollectionView alloc] initWithFrame:_contentRect collectionViewLayout:clayout];
    [self.view addSubview:_cvContent];
    [_cvContent setCollectionViewLayout:clayout];
    _cvContent.backgroundColor = RGBCOLOR(242, 242, 242);
    _cvContent.delegate = self;
    _cvContent.dataSource = self;
    [_cvContent registerClass:[FSProdDetailCell class] forCellWithReuseIdentifier:PROD_LIST_DETAIL_CELL];
    [self prepareRefreshLayout:_cvContent withRefreshAction:^(dispatch_block_t action) {
        [self refreshContent:TRUE withCallback:^(){
            action();
        }];
    }];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        if (isSwipToUp) {
            [self dealTagViewShow];
        }
    }
    else if (gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        if (!isSwipToUp) {
            [self dealTagViewShow];
        }
    }
}

-(void)handleTapFrom:(UITapGestureRecognizer*)gesture
{
    [self dealTagViewShow];
}

-(void)dealTagViewShow
{
    if (isAnimating) {
        return;
    }
    UIView *view = [self.view viewWithTag:Tag_Swip_View_Tag];
    int lineCount = _tags.count/5 + (_tags.count%5==0?0:1);
    __block int height = (lineCount - 1) * (Tag_Item_Height + 10);
    __block int __height = 20 + (Tag_Item_Height + 10) * 7;
    if (isSwipToUp) {
        isAnimating = YES;
        [UIView animateWithDuration:0.25 animations:^{
            if (height > __height) {
                height = __height;
            }
            _cvTags.scrollEnabled = NO;
            CGRect _rect = view.frame;
            _rect.origin.y -= height;
            view.frame = _rect;
            
            _rect = _cvTags.frame;
            _rect.size.height -= height;
            _cvTags.frame = _rect;
            
            _rect = _cvContent.frame;
            _rect.origin.y -= height;
            _rect.size.height += height;
            _cvContent.frame = _rect;
            
            _cvTags.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            isAnimating = NO;
;
        }];
    }
    else{
        isAnimating = YES;
        [UIView animateWithDuration:0.25 animations:^{
            if (height > __height) {
                height = __height;
                _cvTags.scrollEnabled = YES;
            }
            else {
                _cvTags.scrollEnabled = NO;
            }
            CGRect _rect = view.frame;
            _rect.origin.y += height;
            view.frame = _rect;
            
            _rect = _cvTags.frame;
            _rect.size.height += height;
            _cvTags.frame = _rect;
            
            _rect = _cvContent.frame;
            _rect.origin.y += height;
            _rect.size.height -= height;
            _cvContent.frame = _rect;
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    isSwipToUp = !isSwipToUp;
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted needReload:(BOOL)shouldReload
{
    if (!prods)
        return;
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_prods indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
            if ([[(FSProdItemEntity *)obj1 valueForKey:@"id"] intValue] ==[[(FSProdItemEntity *)obj valueForKey:@"id"] intValue])
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
                [_prods addObject:obj];
                if (!shouldReload && !IOS7) {
                    NSIndexPath *path = [NSIndexPath indexPathForItem:_prods.count-1 inSection:0];
                    [_cvContent insertItemsAtIndexPaths:@[path]];
                }
//                NSIndexPath *path = [NSIndexPath indexPathForItem:_prods.count-1 inSection:0];
//                [_cvContent insertItemsAtIndexPaths:@[path]];
            }
            else
            {
                [_prods insertObject:obj atIndex:0];
                if (!shouldReload && !IOS7)
                    [_cvContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            //    [_cvContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            }
        }
    }];
    if (shouldReload || IOS7) {
      [_cvContent reloadData];
    }
//    if (shouldReload)
//        [_cvContent reloadData];
    
    if (_prods.count<1)
    {
        //加载空视图
        [self showNoResultImage:_cvContent withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_DongDong_ProductList", nil)   originOffset:60];
    }
    else
    {
        [self hideNoResultImage:_cvContent];
    }
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{    
    [self fillProdInMemory:prods isInsert:isinserted needReload:FALSE];
}

-(void)beginSwitchTag:(FSTag *)tag
{
    [self zeroMemoryBlock];
    [self beginLoading:self.view];
    _isInLoading = YES;
    _prodPageIndex = 0;
    _currentTag = tag;
    _refreshLatestDate = _firstLoadDate = [NSDate date];
    FSProListRequest *request =
    [self buildListRequest:RK_REQUEST_PROD_LIST nextPage:1 isRefresh:FALSE];
    __block FSProdListViewController *blockSelf = self;
    _cvContent.scrollEnabled = NO;
    [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:self.view];
        _cvContent.scrollEnabled = YES;
        _isInLoading = NO;
        if (resp.isSuccess)
        {
            FSBothItems *result = resp.responseData;
            if (result.totalPageCount <= blockSelf->_prodPageIndex+1)
                blockSelf->_noMoreResult = TRUE;
            [blockSelf->_prods removeAllObjects];
            
            [blockSelf fillProdInMemory:result.prodItems isInsert:FALSE needReload:TRUE];
            [blockSelf->_cvContent setContentOffset:CGPointZero];
            
            if (_cvTags.frame.size.height > 80) {
                isSwipToUp = YES;
                [self dealTagViewShow];
            }
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(FSProListRequest *)buildListRequest:(NSString *)route nextPage:(int)page isRefresh:(BOOL)isRefresh
{
    FSProListRequest *request = [[FSProListRequest alloc] init];
    request.routeResourcePath = route;
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

    request.tagid =[_currentTag valueForKey:@"id"];
    request.nextPage = page;
    request.pageSize = COMMON_PAGE_SIZE;
    return request;
}

-(void)refreshContent:(BOOL)isRefresh withCallback:(dispatch_block_t)callback
{
    int nextPage = 1;
    if (!isRefresh)
    {
        _prodPageIndex++;
        nextPage = _prodPageIndex +1;
    }
    FSProListRequest *request = [self buildListRequest:RK_REQUEST_PROD_LIST nextPage:nextPage isRefresh:isRefresh];
    __block FSProdListViewController *blockSelf = self;
    [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        callback();
        if (resp.isSuccess)
        {
            FSBothItems *result = resp.responseData;
            if (isRefresh)
                blockSelf->_refreshLatestDate = [[NSDate alloc] init];
            else
            {
                if (result.totalPageCount <= blockSelf->_prodPageIndex+1)
                   blockSelf-> _noMoreResult = TRUE;
            }
            [blockSelf fillProdInMemory:result.prodItems isInsert:isRefresh];
        }
        else
        {
            [blockSelf reportError:resp.errorDescrip];
        }
    }];
}

-(void)loadMore
{
    [self beginLoadMoreLayout:_cvContent];
    __block FSProdListViewController *blockSelf = self;
    _isInLoading = YES;
    [self refreshContent:FALSE withCallback:^{
        _isInLoading = NO;
        [blockSelf endLoadMore:_cvContent];
        
        //统计
        NSString *value = [NSString stringWithFormat:@"东东列表页-%@", _currentSelTag.name];
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:value forKey:@"来源"];
        [_dic setValue:[NSString stringWithFormat:@"%d", _prodPageIndex+1] forKey:@"页码"];
        [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
    }];
}

- (void)loadImagesForOnscreenRows
{
    if ([_prods count] > 0)
    {
        NSArray *visiblePaths = [_cvContent indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            id<ImageContainerDownloadDelegate> cell = (id<ImageContainerDownloadDelegate>)[_cvContent cellForItemAtIndexPath:indexPath];
            int width = ITEM_CELL_WIDTH;
            int height = [(PSUICollectionViewCell *)cell frame].size.height - 40;
            [cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (scrollView == _tableSearch) {
        [self.searchBar resignFirstResponder];
        [UIView animateWithDuration:0.8 animations:nil completion:^(BOOL finished) {
            [self.searchBar setCancelButtonEnable:YES];
        }];
    }
    else
    {
        [self loadImagesForOnscreenRows];
        
        if (!_noMoreResult && !_isInLoading &&
            (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
            && scrollView.contentSize.height>scrollView.frame.size.height
            &&scrollView.contentOffset.y>0)
        {
            [self loadMore];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - PSUICollectionView Datasource

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSLog(@"ProdListViewController viewDidLoad Method7");
    if (view == _cvTags && _tags.count > 0)
    {
        return _tags.count;
    }
    else if (view == _cvContent)
    {
        return _prods.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewCell * cell = nil;
    if (collectionView == _cvTags)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PROD_LIST_TAG_CELL forIndexPath:indexPath];
        FSTag *_tag = [_tags objectAtIndex:indexPath.row];
        [(FSProdTagCell *)cell setData:_tag];
        if (__IPHONE_OS_VERSION_MIN_REQUIRED < 60000) {
            UIView *v = [_cvTags viewWithTag:Tag_Swip_View_Tag];
            if (v) {
                [_cvTags bringSubviewToFront:v];
            }
        }
    }
    else if (collectionView == _cvContent)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:PROD_LIST_DETAIL_CELL forIndexPath:indexPath];
        FSProdItemEntity *_data = [_prods objectAtIndex:indexPath.row];
        [(FSProdDetailCell *)cell setData:_data];
        if (_data.promotionFlag) {
            [(FSProdDetailCell *)cell showProIcon];
        }
        else {
            [(FSProdDetailCell *)cell hidenProIcon];
        }
        if (_data.isCanBuyFlag) {
            [(FSProdDetailCell *)cell showProBag];
        }
        else {
            [(FSProdDetailCell *)cell hidenProBag];
        }
        int width = PROD_LIST_DETAIL_CELL_WIDTH;
        int height = cell.frame.size.height;
        [(id<ImageContainerDownloadDelegate>)cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
    }
    return cell;
}

#pragma mark - PSUICollectionViewDelegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _cvTags)
    {
        //首先结束上一次的loading动画
        [self endLoading:self.view];
        [[collectionView cellForItemAtIndexPath:indexPath] setSelected:TRUE];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:TRUE];
        FSTag *tag = [_tags objectAtIndex:indexPath.row];
        [self beginSwitchTag:tag];
        _currentSelTag = tag;
        
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic setValue:tag.name forKey:@"分类名称"];
        [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_TAB withParameters:_dic];
    }
    else if (collectionView == _cvContent)
    {
        FSProDetailViewController *detailViewController = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
        detailViewController.navContext = _prods;
        detailViewController.dataProviderInContext = self;
        detailViewController.indexInContext = indexPath.row;
        detailViewController.sourceType = FSSourceProduct;
        UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [self presentViewController:navControl animated:YES completion:nil];
        
        FSProdItemEntity *_item = [_prods objectAtIndex:indexPath.row];
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [_dic setValue:_item.title forKey:@"商品名称"];
        [_dic setValue:[NSString stringWithFormat:@"%d", _item.id] forKey:@"商品ID"];
        [_dic setValue:@"东东列表页" forKey:@"来源页面"];
        [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
        
        [[FSAnalysis instance] autoTrackPages:navControl];
    }
}

-(void)collectionView:(PSUICollectionView *)collectionView didEndDisplayingCell:(PSUICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cvContent)
    {
        [(FSProdDetailCell *)cell willRemoveFromView];
    }
//    else {
//        FSTag *_tag = [_tags objectAtIndex:indexPath.row];
//        if (_tag.id == _currentSelTag.id) {
//            [[collectionView cellForItemAtIndexPath:indexPath] setSelected:TRUE];
//        }
//    }
}

-(CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _cvTags &&
        theApp.allTags)
    {
        if (theApp.allTags.count > indexPath.row) {
            FSTag *_tag = (FSTag*)[theApp.allTags objectAtIndex:indexPath.row];
            if (_tag.name) {
                CGSize actualSize = [_tag.name sizeWithFont:ME_FONT(12)];
                CGFloat width = MAX(actualSize.width, DEFAULT_TAG_WIDTH);
                _actualTagWidth += width+5;
                return CGSizeMake(width, MAX(actualSize.height, Tag_Item_Height));
            }
            return CGSizeZero;
        }
    }
    return  CGSizeMake(ITEM_CELL_WIDTH, ITEM_CELL_WIDTH);
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSProdItemEntity * data = [_prods objectAtIndex:indexPath.row];
    FSResource * resource = data.resource && data.resource.count>0?[data.resource objectAtIndex:0]:nil;
    float totalHeight = 0.1f;
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

-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return view.sourceType;
    return FSSourceProduct;
}

-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return TRUE;
}

- (BOOL) isDeletionModeActiveForCollectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout
{
    return FALSE;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - TableView Delegate and DataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableSearch) {
        return self.searchBar;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableSearch) {
        return 88;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_selectedIndex == 0) {
        return _prodKeywords.count;
    }
    else if(_selectedIndex == 1){
        return _brandKeywords.count;
    }
    else{
        return _stores.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_selectedIndex == 0) {
        cell.textLabel.text = _prodKeywords[indexPath.row];
    }
    else if(_selectedIndex == 1){
        FSBrand *brand = _brandKeywords[indexPath.row];
        cell.textLabel.text = brand.name;
    }
    else{
        FSStore *store = _stores[indexPath.row];
        cell.textLabel.text = store.name;
    }
    cell.textLabel.font = FONT(15);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self toSearch:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _tableSearch) {
        return;
    }
    else
    {
        [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - Search Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.tag == Default_SearchBar_Tag) {
        [searchBar resignFirstResponder];
        [self performSelector:@selector(showKeyBoard) withObject:Nil afterDelay:0.34];
        [self onSearch:nil];
    }
}

-(void)showKeyBoard
{
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.tag != Default_SearchBar_Tag) {
        [self toSearch:-1];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    if (_isSearching && searchBar.tag != Default_SearchBar_Tag) {
        self.searchBar.text = @"";
        [searchBar resignFirstResponder];
        [_tableSearch removeFromSuperview];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _isSearching = NO;
    }
}

//type<0:搜索文本框中输入的内容
//type>=0:搜索热门关键词、热门品牌
-(void)toSearch:(int)type
{
    NSString *value = nil;
    //跳转搜索界面进行搜索
    FSProductListViewController *dr = [[FSProductListViewController alloc] initWithNibName:@"FSProductListViewController" bundle:nil];
    if (type < 0) {
        dr.keyWords = _searchBar.text;
        dr.pageType = FSPageTypeSearch;
        value = @"用户输入搜索";
    }
    else{
        if (_selectedIndex == 0) {//热门关键字
            dr.keyWords = _prodKeywords[type];
            dr.pageType = FSPageTypeSearch;
            value = @"关键词搜索";
        }
        else if(_selectedIndex == 1){//品牌搜索
            FSBrand *brand = _brandKeywords[type];
            dr.pageType = FSPageTypeBrand;
            dr.brand = brand;
            dr.keyWords = brand.name;
            value = @"热门品牌搜索";
        }
        else{
            FSStore *store = _stores[type];
            dr.store = store;
            dr.keyWords = store.name;
            dr.pageType = FSPageTypeStore;
            value = @"推荐实体店搜索";
        }
    }
    dr.titleName = dr.keyWords;
    dr.isModel = YES;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:dr];
    [self presentModalViewController:navControl animated:YES];
    
    //统计1
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:value forKey:@"来源"];
    [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST withParameters:_dic];
    
    //统计2
    NSMutableDictionary *_dic2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [_dic2 setValue:value forKey:@"搜索方式"];
    [_dic2 setValue:dr.keyWords forKey:@"搜索内容"];
    [[FSAnalysis instance] logEvent:COMMON_SEARCH withParameters:_dic2];
    
    [[FSAnalysis instance] autoTrackPages:navControl];
}

#pragma mark - MySegmentValueChangedDelegate

-(void)segmentValueChanged:(UISegmentedControl*)seg
{
    if (seg) {
        _selectedIndex = seg.selectedSegmentIndex;
    }
    [_tableSearch reloadData];
}



@end
