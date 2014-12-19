//
//  FSProdListViewController.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProductListViewController.h"
#import "FSProdDetailCell.h"
#import "FSProDetailViewController.h"

#import "FSProListRequest.h"
#import "FSResource.h"
#import "FSLocationManager.h"
#import "FSBothItems.h"
#import "FSModelManager.h"

#define PROD_LIST_DETAIL_CELL @"FSProdListDetailCell"
#define  PROD_LIST_DETAIL_CELL_WIDTH 100
#define LOADINGVIEW_HEIGHT 44
#define ITEM_CELL_WIDTH 100
#define PROD_PAGE_SIZE 20

@interface FSProductListViewController ()
{
    NSMutableArray *_prods;
    PSUICollectionView *_productContent;
    
    UIActivityIndicatorView * moreIndicator;
    BOOL _isInLoading;
    BOOL _firstTimeLoadDone;
    int _prodPageIndex;

    NSDate *_refreshLatestDate;
    NSDate * _firstLoadDate;
    
    bool _noMoreResult;
    BOOL _isLoading;
    BOOL _isShowBrandStory;
    UIView *_brandShowView;
    float _contentOffsetY;
}

@end

@implementation FSProductListViewController

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
    [self prepareLayout];
    [self prepareData];
}

-(void) prepareData
{
    _prods = [@[] mutableCopy];
    [self zeroMemoryBlock];
    _prodPageIndex = 0;
    _refreshLatestDate = _firstLoadDate = [NSDate date];
    _isShowBrandStory = NO;
    
    FSProListRequest *request = nil;
    if (_pageType == FSPageTypeSearch) {
        request = [self buildListRequest:RK_REQUEST_PROD_SEARCH_LIST nextPage:1 isRefresh:NO];
    }
    else {
        request = [self buildListRequest:RK_REQUEST_PROD_LIST nextPage:1 isRefresh:NO];
    }
    [self beginLoading:_productContent];
    [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:_productContent];
        if (resp.isSuccess)
        {
            FSBothItems *result = resp.responseData;
            if (result.totalPageCount <= _prodPageIndex+1)
                _noMoreResult = TRUE;
            [_prods removeAllObjects];
            [self fillProdInMemory:result.prodItems isInsert:NO];
            [self showBrandButton];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void)showBrandButton
{
    if (_prods.count > 0 && FSPageTypeBrand == _pageType) {
        FSProdItemEntity *item = _prods[0];
        if (item.brandDesc && ![item.brandDesc isEqualToString:@""]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn addTarget:self action:@selector(showBrandDesc:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"品牌介绍" forState:UIControlStateNormal];
            btn.titleLabel.font = ME_FONT(13);
            btn.showsTouchWhenHighlighted = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
            [btn sizeToFit];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:btn]];
        }
    }
}

-(void)showBrandDesc:(UIButton*)sender
{
    if (_pageType != FSPageTypeBrand) {
        return;
    }
    if (!_isShowBrandStory) {//还没有展开，此时展开
        if (_prods.count > 0 && FSPageTypeBrand == _pageType)
        {
            FSProdItemEntity *item = _prods[0];
            NSString *brandDesc = item.brandDesc;
            int height = [brandDesc sizeWithFont:ME_FONT(12) constrainedToSize:CGSizeMake(295, 10000) lineBreakMode:NSLineBreakByCharWrapping].height;
            CGRect _rect = CGRectMake(0, 0, 320, height + 25);
            if (!_brandShowView) {
                _brandShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
                _brandShowView.clipsToBounds = YES;
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:_rect];
                imgV.image = [UIImage imageNamed:@"brand_story_bg.png"];
                [_brandShowView addSubview:imgV];
                UILabel *descLb = [[UILabel alloc] initWithFrame:CGRectInset(_rect, 12.5, 12.5)];
                descLb.tag = 200;
                descLb.backgroundColor = [UIColor clearColor];
                descLb.font = ME_FONT(12);
                descLb.numberOfLines = 0;
                descLb.lineBreakMode = NSLineBreakByCharWrapping;
                descLb.textColor = [UIColor colorWithHexString:@"#666666"];
                [_brandShowView addSubview:descLb];
                
                [self.view addSubview:_brandShowView];
            }
            _brandShowView.hidden = NO;
            UILabel *descLb = (UILabel*)[_brandShowView viewWithTag:200];
            if (descLb) {
                descLb.text = brandDesc;
            }
            _contentOffsetY = _productContent.contentOffset.y;
            [UIView animateWithDuration:0.33 animations:^{
                _brandShowView.frame = _rect;
                
                CGRect aRect = _productContent.frame;
                aRect.size.height -= _brandShowView.frame.size.height;
                aRect.origin.y += _brandShowView.frame.size.height;
            } completion:^(BOOL finished) {
                //nothing
            }];
        }
        else
        {
            return;
        }
    }
    else{
        if (!_brandShowView) {
            return;
        }
        [UIView animateWithDuration:0.33 animations:^{
            int height = _brandShowView.frame.size.height;
            CGRect _rect = _brandShowView.frame;
            _rect.size.height = 0;
            _brandShowView.frame = _rect;
            
            _rect = _productContent.frame;
            _rect.size.height += height;
            _rect.origin.y -= height;
        } completion:^(BOOL finished) {
            _brandShowView.hidden = YES;
        }];
    }
    
    _isShowBrandStory = !_isShowBrandStory;
}

-(void) zeroMemoryBlock
{
    _prodPageIndex = 0;
    _noMoreResult= FALSE;
}

-(void) prepareLayout
{
    if (_pageType == FSPageTypeBrand) {
        self.navigationItem.title = _brand.name;
    }
    else if(_pageType == FSPageTypeTopic) {
        self.navigationItem.title = _topic.name;
    }
    else if(_pageType == FSPageTypeSearch) {
        self.navigationItem.title = _titleName;
    }
    else if(_pageType == FSPageTypeCommon) {
        self.navigationItem.title = _titleName;
    }
    else{
        self.navigationItem.title = _titleName;
    }
    [self replaceBackItem];
    SpringboardLayout *clayout = [[SpringboardLayout alloc] init];
    clayout.itemWidth = ITEM_CELL_WIDTH;
    clayout.columnCount = 3;
    clayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    clayout.delegate = self;
    
    CGRect _con = CGRectMake(0, 0, APP_WIDTH, APP_WIDTH);
    double tabHeight = [self.navigationController tabBarController]?TAB_HIGH:0;
    double statusBarHeight = [UIApplication sharedApplication].statusBarHidden?0:20;
    _con.size.height = SCREEN_HIGH - NAV_HIGH - tabHeight - statusBarHeight;
    _productContent = [[PSUICollectionView alloc] initWithFrame:_con collectionViewLayout:clayout];
    [self.view addSubview:_productContent];
    
    _productContent.backgroundColor = [UIColor whiteColor];
    [_productContent registerClass:[FSProdDetailCell class] forCellWithReuseIdentifier:PROD_LIST_DETAIL_CELL];
    [self prepareRefreshLayout:_productContent withRefreshAction:^(dispatch_block_t action) {
        [self refreshContent:YES withCallback:^(){
            action();
        }];
        
    }];
    
    _productContent.delegate = self;
    _productContent.dataSource = self;
    
    if(IOS7 && _pViewController) {
        CGRect _rect = _productContent.frame;
        _rect.origin.y += NAV_HIGH;
        _productContent.frame = _rect;
    }
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
}

- (IBAction)onButtonBack:(id)sender {
    if (_isModel) {
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods)
        return;
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_prods indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
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
                [_prods addObject:obj];
                if (!IOS7) {
                    [_productContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_prods.count-1 inSection:0]]];
                }
                //[_productContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_prods.count-1 inSection:0]]];
            } else
            {
                [_prods insertObject:obj atIndex:0];
                if (!IOS7) {
                    [_productContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
                }
                //[_productContent insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
            }
        }
    }];
    if (IOS7) {
        [_productContent reloadData];
    }
    if (_prods.count<1)
    {
        //加载空视图
        [self showNoResultImage:_productContent withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_Product_List", nil)  originOffset:90];
    }
    else
    {
        [self hideNoResultImage:_productContent];
    }
}


-(FSProListRequest *)buildListRequest:(NSString *)route nextPage:(int)page isRefresh:(BOOL)isRefresh
{
    FSProListRequest *request = [[FSProListRequest alloc] init];
    request.routeResourcePath = route;
    if (_pageType == FSPageTypeBrand) {
        request.brandId = [_brand valueForKey:@"id"];
    }
    else if(_pageType == FSPageTypeTopic) {
        request.topicId = [NSNumber numberWithInt:_topic.topicId];
    }
    else if(_pageType == FSPageTypeSearch) {
        request.keyword = _keyWords;
        request.searchType = FSProdSortDefault;
        request.pageType = FSPageTypeSearch;
    }
    else if(_pageType == FSPageTypeCommon) {
        request.promotionId = [NSNumber numberWithInt:_commonID];
    }
    else if(_pageType == FSPageTypeStore) {
        request.storeid = _store.id;
    }
    if(_pageType != FSPageTypeSearch)
    {
        request.longit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    }
    
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
    FSProListRequest *request = nil;
    if (_pageType == FSPageTypeSearch) {
        request = [self buildListRequest:RK_REQUEST_PROD_SEARCH_LIST nextPage:nextPage isRefresh:isRefresh];
    }
    else {
        request = [self buildListRequest:RK_REQUEST_PROD_LIST nextPage:nextPage isRefresh:isRefresh];
    }
    [request send:[FSBothItems class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        callback();
        if (resp.isSuccess)
        {
            FSBothItems *result = resp.responseData;
            if (isRefresh)
                _refreshLatestDate = [[NSDate alloc] init];
            else
            {
                if (result.totalPageCount <= _prodPageIndex+1)
                    _noMoreResult = TRUE;
            }
            [self fillProdInMemory:result.prodItems isInsert:isRefresh];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void)loadMore
{
    [self beginLoadMoreLayout:_productContent];
    __block FSProductListViewController *blockSelf = self;
    _isLoading = YES;
    [self refreshContent:NO withCallback:^{
         [blockSelf endLoadMore:_productContent];
        _isLoading = NO;
        
        //统计
        NSString *value = nil;
        if (_pageType == FSPageTypeBrand) {
            value = @"商品列表页-品牌";
        }
        else if(_pageType == FSPageTypeTopic) {
            value = @"商品列表页-专题";
        }
        else if(_pageType == FSPageTypeStore) {
            value = @"商品列表页-实体店";
        }
        else if(_pageType == FSPageTypeSearch) {
            value = @"商品列表页-搜索";
        }
        else {
            value = @"商品列表页-其他";
        }
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
        NSArray *visiblePaths = [_productContent indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            id<ImageContainerDownloadDelegate> cell = (id<ImageContainerDownloadDelegate>)[_productContent cellForItemAtIndexPath:indexPath];
            int width = ITEM_CELL_WIDTH;
            int height = [(PSUICollectionViewCell *)cell frame].size.height;
            [cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height)];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    [self loadImagesForOnscreenRows];
    if (!_noMoreResult && !_isLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
        && scrollView.contentSize.height>scrollView.frame.size.height
        && scrollView.contentOffset.y>0)
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
        return _prods.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewCell * cell = nil;
    cell = [cv dequeueReusableCellWithReuseIdentifier:PROD_LIST_DETAIL_CELL forIndexPath:indexPath];
    FSProdItemEntity *_data = [_prods objectAtIndex:indexPath.row];
    [(FSProdDetailCell *)cell setData: _data];
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
   
    return cell;
}

#pragma mark - PSUICollectionViewDelegate

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSProDetailViewController *detailViewController = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
    detailViewController.navContext = _prods;
    detailViewController.dataProviderInContext = self;
    detailViewController.indexInContext = indexPath.row;
    detailViewController.sourceType = FSSourceProduct;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    [self presentViewController:navControl animated:YES completion:nil];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
    FSProdItemEntity *item = [_prods objectAtIndex:indexPath.row];
    [_dic setValue:nil forKey:@"商品名称"];
    [_dic setValue:[NSString stringWithFormat:@"%d", item.id] forKey:@"商品ID"];
    [_dic setValue:@"商品列表页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
    
    [[FSAnalysis instance] autoTrackPages:navControl];
}

-(void)collectionView:(PSUICollectionView *)collectionView didEndDisplayingCell:(PSUICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _productContent)
    {
        [(FSProdDetailCell *)cell willRemoveFromView];
    }
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSProdItemEntity * data = [_prods objectAtIndex:indexPath.row];
    FSResource * resource = data.resource&&data.resource.count>0?[data.resource objectAtIndex:0]:nil;
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
    FSProdItemEntity *item =  [view.navContext objectAtIndex:index];
    if (item)
        block(item);
    else
        errorBlock();
    
}
-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
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
@end
