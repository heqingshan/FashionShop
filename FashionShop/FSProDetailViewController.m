//
//  FSProDetailViewController.m
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "FSModelManager.h"
#import "FSMeViewController.h"
#import "MBProgressHUD.h"
#import "FSProDetailView.h"
#import "FSProdDetailView.h"
#import "FSProCommentCell.h"
#import "FSProCommentInputView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FSDRViewController.h"
#import "FSProCommentHeader.h"
#import "FSProductListViewController.h"
#import "FSStoreDetailViewController.h"
#import "FSSearchViewController.h"
#import "FSProPostTitleViewController.h"
#import "CL_VoiceEngine.h"
#import "FSAudioShowView.h"
#import "FSImageBrowserView.h"
#import "FSBuyCenterViewController.h"
#import "FSPLetterViewController.h"
#import "FSMessageViewController.h"

#import "FSCouponRequest.h"
#import "FSFavorRequest.h"
#import "FSUser.h"
#import "FSCoupon.H"
#import "FSCommonProRequest.h"
#import "FSCommonCommentRequest.h"
#import "FSLocationManager.h"

#import "FSShareView.h"
#import "AWActionSheet.h"
#import "UIBarButtonItem+Title.h"
#import <PassKit/PassKit.h>
#import "NSData+Base64.h"
#import "NSString+Extention.h"

#import "EGOPhotoGlobal.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"

#import "FSGiftListViewController.h"
#import "FSCouponViewController.h"

#define PRO_DETAIL_COMMENT_INPUT_TAG 200
#define TOOLBAR_HEIGHT 44
#define PRO_DETAIL_COMMENT_INPUT_HEIGHT 63
#define PRO_DETAIL_COMMENT_HEADER_HEIGHT 30
#define Alert_Tag_Coupon 123

@interface FSProDetailViewController ()
{
    MBProgressHUD   *statusReport;
    id              proItem;
    int             currentPageIndex;
    BOOL            _inLoading;
    
    int             replyIndex;//回复索引
    BOOL            isReplyToAll;//是否是回复给所有人
    
    RecordState     _recordState;
    BOOL            _isRecording;
    NSDate*         _downTime;//按下时间
    NSInteger       _minRecordGap;//最小录制时间间隔
    BOOL            _isAudio;//是否是语音内容
    BOOL            _isPlaying;//是否正在播放声音
    FSAudioButton   *lastButton;
    NSTimer         *_timer;
    FSAudioShowView *_audioShowView;//音量检测视图
}

@end

@implementation FSProDetailViewController
@synthesize dataProviderInContext,navContext,indexInContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self beginPrepareData];
    
    _minRecordGap = 1.5;
    _isAudio = YES;
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(void) beginPrepareData
{
    [self doBinding:nil];
}

-(void) onButtonCancel
{
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

-(void) doBinding:(FSProItemEntity *)source
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];

    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonCancel)];
    UIBarButtonItem *baritemShare = [self createPlainBarButtonItem:@"share_icon.png" target:self action:@selector(doShare:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self.navigationItem setRightBarButtonItem:baritemShare];
    currentPageIndex = -1;
    replyIndex = -1;
    [self.paginatorView reloadData];
    self.currentPageIndex = indexInContext;
    
    if (!_audioShowView) {
        int height = 120;
        _audioShowView = [[FSAudioShowView alloc] initWithFrame:CGRectMake((APP_WIDTH - height)/2, (APP_HIGH - height)/2 - 70, height, height)];
        [self.view addSubview:_audioShowView];
        _audioShowView.hidden = YES;
    }
}

-(id)itemSource
{
    return [(id)self.paginatorView.currentPage data];
}

#pragma mark - SYPaginatorViewDataSource

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView {
	return navContext.count;
}

- (SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex {
    NSString *identifier = NSStringFromClass([FSProDetailView class]);
    FSSourceType source = [dataProviderInContext proDetailViewSourceTypeFromContext:self forIndex:pageIndex];
	if (source == FSSourceProduct)
        identifier = NSStringFromClass([FSProdDetailView class]);
	FSDetailBaseView * view = (FSDetailBaseView*)[paginatorView dequeueReusablePageWithIdentifier:identifier];
	if (!view) {
        if (source == FSSourcePromotion)
            view = [[[NSBundle mainBundle] loadNibNamed:@"FSProDetailView" owner:self options:nil] lastObject];
        else {
            view = [[[NSBundle mainBundle] loadNibNamed:@"FSProdDetailView" owner:self options:nil] lastObject];
        }
    }
    [view setPType:source];
    CGRect _rect = view.myToolBar.frame;
    _rect.size.height = TAB_HIGH;
    view.myToolBar.frame = _rect;
    [view setToolBarBackgroundImage];

    if ([view respondsToSelector:@selector(imgThumb)])
    {
        [(FSThumView *)[(id)view imgThumb] setDelegate:self];
    }
    if ([view respondsToSelector:@selector(imgView)])
    {
        UIImageView *prodImage = (UIImageView *)[(id)view imgView];
        [prodImage setUserInteractionEnabled:TRUE];
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProImage:)];
        [prodImage addGestureRecognizer:imgTap];
    }
    if ([view respondsToSelector:@selector(btnTag)])
    {
        UIButton *tagButton = (UIButton *)[(id)view btnTag];
        [tagButton addTarget:self action:@selector(goTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    [[(id)view tbComment] registerNib:[UINib nibWithNibName:@"FSProCommentCell" bundle:nil] forCellReuseIdentifier:@"FSProCommentCell"];
    
    if (![(id)view audioButton].audioDelegate) {
        [(id)view audioButton].audioDelegate = self;
    }
    [(id)view svContent].delegate = self;
    [(id)view tbComment].delegate = self;
    [(id)view tbComment].dataSource = self;
    [(id)view svContent].scrollEnabled = TRUE;
    //view.showViewMask = TRUE;
    
	return view;
}

-(void) resetScrollViewSize:(FSDetailBaseView *)view
{
    [view resetScrollViewSize];
}

#pragma mark - SYPaginatorViewDelegate

- (void)paginatorView:(SYPaginatorView *)paginatorView didScrollToPageAtIndex:(NSInteger)pageIndex
{
    if (currentPageIndex== pageIndex)
        return;
    currentPageIndex= pageIndex;
    __block FSDetailBaseView * blockViewForRefresh = (FSDetailBaseView*)paginatorView.currentPage;
    __block FSProDetailViewController *blockSelf = self;
    _sourceType = blockViewForRefresh.pType;
    
    NSNumber * itemId = nil;
    if (_sourceFrom == 1) {
        itemId = [[navContext objectAtIndex:pageIndex] valueForKey:@"promotionid"];
    }
    else if(_sourceFrom == 2) {
        itemId = [[navContext objectAtIndex:pageIndex] valueForKey:@"sourceId"];
    }
    else{
        itemId = [[navContext objectAtIndex:pageIndex] valueForKey:@"id"];
    }
    [self beginLoading:blockViewForRefresh];
    _inLoading = YES;
    if ([dataProviderInContext respondsToSelector:@selector(proDetailViewNeedRefreshFromContext:forIndex:)] &&
        [dataProviderInContext proDetailViewNeedRefreshFromContext:self forIndex:pageIndex]==TRUE)
    {
        FSCommonProRequest *drequest = [[FSCommonProRequest alloc] init];
        drequest.uToken = [FSModelManager sharedModelManager].loginToken;
        drequest.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        drequest.lantit = [NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        Class respClass;
        if (blockViewForRefresh.pType == FSSourceProduct)
        {
            drequest.routeResourcePath = [NSString stringWithFormat:@"/product/%@",itemId];
            respClass = [FSProdItemEntity class];
        }
        else
        {
            drequest.routeResourcePath = [NSString stringWithFormat:@"/promotion/%@",itemId];
            respClass = [FSProItemEntity class];
        }
        [drequest setBaseURL:2];
        [drequest send:respClass withRequest:drequest completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:blockViewForRefresh];
            _inLoading = NO;
            if (resp.isSuccess)
            {
                [blockViewForRefresh setData:resp.responseData];
                if ([blockViewForRefresh respondsToSelector:@selector(imgThumb)])
                {
                    [(FSThumView *)[(id)blockViewForRefresh imgThumb] setDelegate:self];
                }
                [(FSProDetailView*)blockViewForRefresh audioButton].audioDelegate = self;
                NSString *navTitle = [blockViewForRefresh.data valueForKey:@"title"];
                if (blockSelf->_sourceType==FSSourcePromotion)
                    navTitle = NSLocalizedString(@"promotion detail", nil);
                [blockSelf.navigationItem setTitle:navTitle];
                [self resetScrollViewSize:blockViewForRefresh];
                [blockSelf delayLoadComments:[blockViewForRefresh.data valueForKey:@"id"]];
                //去除已经访问的评论
                [theApp removeCommentID:[NSString stringWithFormat:@"%@", [blockViewForRefresh.data valueForKey:@"id"]]];
                [self requestOperations:itemId];
            }
            else
            {
                [self onButtonCancel];
            }
        }];
    }
    else
    {
        [dataProviderInContext proDetailViewDataFromContext:self forIndex:pageIndex completeCallback:^(id input){
            [blockViewForRefresh setData:input];
            if ([blockViewForRefresh respondsToSelector:@selector(imgThumb)])
            {
                [(FSThumView *)[(id)blockViewForRefresh imgThumb] setDelegate:self];
            }
            [(FSProdDetailView*)blockViewForRefresh audioButton].audioDelegate = self;
            [self endLoading:blockViewForRefresh];
            _inLoading = NO;
            NSString *navTitle = [blockViewForRefresh.data valueForKey:@"title"];
            if (blockSelf->_sourceType==FSSourcePromotion)
                navTitle = NSLocalizedString(@"promotion detail", nil);
            [blockSelf.navigationItem setTitle:navTitle];
            [self resetScrollViewSize:blockViewForRefresh];
            [blockSelf delayLoadComments:[blockViewForRefresh.data valueForKey:@"id"]];
            [self resetScrollViewSize:blockViewForRefresh];
            //去除已经访问的评论
            [theApp removeCommentID:[NSString stringWithFormat:@"%@", [blockViewForRefresh.data valueForKey:@"id"]]];
            [self requestOperations:itemId];
        } errorCallback:^{
            [self onButtonCancel];
        }];
    }
    [self hideCommentInputView:nil];
    
    //请求操作
    //[self performSelector:@selector(requestOperations:) withObject:itemId afterDelay:.2f];
}

-(void)requestOperations:(NSNumber*)itemid
{
    FSDetailBaseView * blockViewForRefresh = (FSDetailBaseView*)self.paginatorView.currentPage;
    FSCommonProRequest *drequest = [[FSCommonProRequest alloc] init];
    drequest.routeResourcePath = blockViewForRefresh.pType == FSSourceProduct?RK_REQUEST_PROD_AVAILOPERATIONS:RK_REQUEST_PRO_AVAILOPERATIONS;
    drequest.pType = _sourceType;
    drequest.id = itemid;
    _inLoading = YES;
    drequest.uToken = [FSModelManager sharedModelManager].loginToken;
    [drequest send:[FSProdItemEntity class] withRequest:drequest completeCallBack:^(FSEntityBase *resp) {
        _inLoading = NO;
        if (resp.isSuccess)
        {
            FSProdItemEntity *item = resp.responseData;
            BOOL flag = item.isCouponed;
            [blockViewForRefresh updateToolBar:flag];
            if ([blockViewForRefresh.data isKindOfClass:[FSProdItemEntity class]])
            {
                FSProdDetailView *pView = (FSProdDetailView*)blockViewForRefresh;
                FSProdItemEntity *pProd = (FSProdItemEntity *)pView.data;
                pProd.isFavored = item.isFavored;
                pView.isCanTalk = item.isCanTalk;
                [pView setData:pProd];
                [pView resetScrollViewSize];
            } else if ([blockViewForRefresh.data isKindOfClass:[FSProItemEntity class]])
            {
                ((FSProItemEntity *)blockViewForRefresh.data).isFavored = item.isFavored;
            }
        }
    }];
}

-(void)delayLoadComments:(NSNumber *)proId
{
    __block FSDetailBaseView * blockViewForRefresh = (FSDetailBaseView*)self.paginatorView.currentPage;
    if (!blockViewForRefresh)
        return;
    __block FSProDetailViewController *blockSelf = self;
    FSCommonCommentRequest * request=[[FSCommonCommentRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_COMMENT_LIST;
    request.sourceid = proId;
    request.sourceType =[NSNumber numberWithInt:blockViewForRefresh.pType];//promotion
    request.nextPage = @1;
    request.pageSize = @100;
    request.refreshTime = [[NSDate alloc] init];
    request.rootKeyPath = @"data.comments";
    _inLoading = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [request send:[FSComment class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _inLoading = NO;
        if (resp.isSuccess)
        {
            [[blockViewForRefresh data] setComments:resp.responseData];
            replyIndex = -1;
            if (blockViewForRefresh && blockSelf)
                [[(id)blockViewForRefresh tbComment] reloadData];
        }
        else
        {
            NSLog(@"comment list failed");
        }
    }];
}

-(void)scrollToTableTop:(FSDetailBaseView*)blockViewForRefresh
{
    CGRect _rect = [(id)blockViewForRefresh tbComment].frame;
    _rect.size.height = 100;
    [[(id)blockViewForRefresh svContent] scrollRectToVisible:_rect animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(Class)convertSourceTypeToClass:(FSSourceType)pType
{
    switch (pType) {
        case FSSourceProduct:
            return [FSProdItemEntity class];
        case  FSSourcePromotion:
            return [FSProItemEntity class];
            
        default:
            break;
    }
    return nil;
}

-(void) internalGetCoupon:(dispatch_block_t) cleanup
{
    FSCouponRequest *request = [[FSCouponRequest alloc] init];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.productId = [[self.itemSource valueForKey:@"id"] intValue];
    request.productType = _sourceType ;
    request.includePass = [PKPass class]?TRUE:FALSE;
    request.rootKeyPath = @"data.coupon";
    
    __block FSProDetailViewController *blockSelf = self;
    [request send:[FSCoupon class] withRequest:request completeCallBack:^(FSEntityBase *respData){
        if(!respData.isSuccess)
        {
            [blockSelf updateProgress:respData.errorDescrip];
            if (cleanup)
                cleanup();
        }
        else
        {
            FSCoupon *coupon = respData.responseData;
            FSDetailBaseView *view = (FSDetailBaseView*)blockSelf.paginatorView.currentPage;
            if ([view.data isKindOfClass:[FSProdItemEntity class]])
            {
                ((FSProdItemEntity *)view.data).couponTotal ++;
            } else if ([view.data isKindOfClass:[FSProItemEntity class]])
            {
                 ((FSProItemEntity *)view.data).couponTotal ++;
            }
            FSUser *localUser = (FSUser *)[FSUser localProfile];
            localUser.couponsTotal ++;
            //add pass to passbook
            if (coupon.pass &&
                [PKPass class])
            {
                NSError *error = nil;
                NSString *passByte = coupon.pass;
                 PKPass *pass = [[PKPass alloc] initWithData:[NSData dataFromBase64String:passByte] error:&error];
                if (pass)
                {
                    PKAddPassesViewController *passController = [[PKAddPassesViewController alloc] initWithPass:pass];
                    [self presentViewController:passController animated:TRUE completion:nil];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Pass Add Tip Info", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                    alert.tag = Alert_Tag_Coupon;
                    [alert show];
                }
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Pass Add Tip Info", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                alert.tag = Alert_Tag_Coupon;
                [alert show];
            }
            [blockSelf updateProgressThenEnd:NSLocalizedString(@"coupon use instruction",nil) withDuration:2];
        }

    }];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
    FSDetailBaseView *view = (FSDetailBaseView*)blockSelf.paginatorView.currentPage;
    [_dic setValue:(_sourceType == FSSourceProduct?@"商品详情页":@"活动详情页") forKey:@"来源页面"];
    [_dic setValue:[view.data valueForKey:@"title"] forKey:@"标题"];
    [[FSAnalysis instance] logEvent:COMMON_GET_COUPON withParameters:_dic];
}

-(void) internalDoFavor:(UIBarButtonItem *)button
{
    FSFavorRequest *request = [[FSFavorRequest alloc] init];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.productId = [self.itemSource valueForKey:@"id"];
    request.productType = _sourceType ;
    __block BOOL favored = [[self.itemSource valueForKey:@"isFavored"] boolValue];
    if (favored)
    {
        request.routeResourcePath = _sourceType==FSSourceProduct?RK_REQUEST_FAVOR_PROD_REMOVE:RK_REQUEST_FAVOR_PRO_REMOVE;
    }
    FSDetailBaseView *view = (FSDetailBaseView*)self.paginatorView.currentPage;
    if ([view.data isKindOfClass:[FSProdItemEntity class]])
    {
        ((FSProdItemEntity *)view.data).isFavored = !favored;
    } else if ([view.data isKindOfClass:[FSProItemEntity class]])
    {
        ((FSProItemEntity *)view.data).isFavored = !favored;
    }

    button.enabled = false;
    __block FSProDetailViewController *blockSelf = self;
    
    [request send:[self convertSourceTypeToClass:_sourceType] withRequest:request completeCallBack:^(FSEntityBase *respData){
        if (respData.isSuccess)
        {
            FSDetailBaseView *view = (FSDetailBaseView*)blockSelf.paginatorView.currentPage;
            if ([view.data isKindOfClass:[FSProdItemEntity class]])
            {
                ((FSProdItemEntity *)view.data).isFavored = !favored;
                if (favored)
                    ((FSProdItemEntity *)view.data).likeCount --;
                else
                    ((FSProdItemEntity *)view.data).likeCount ++;
            }
            else if ([view.data isKindOfClass:[FSProItemEntity class]])
            {
                ((FSProItemEntity *)view.data).isFavored = !favored;
                if (favored)
                    ((FSProItemEntity *)view.data).favorTotal --;
                else
                    ((FSProItemEntity *)view.data).favorTotal ++;
            }

            if (favored &&
                [blockSelf.dataProviderInContext respondsToSelector:@selector(proDetailViewShouldPostNotification:)])
            {
                BOOL shouldPostMesg = [blockSelf.dataProviderInContext proDetailViewShouldPostNotification:blockSelf];
                if (shouldPostMesg)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:LN_FAVOR_UPDATED object:[blockSelf.navContext objectAtIndex:blockSelf.paginatorView.currentPageIndex] ];
                }
            }
        } 
        button.enabled = TRUE;
    }];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [_dic setValue:(_sourceType == FSSourceProduct?@"商品详情":@"活动详情") forKey:@"来源页面"];
    [_dic setValue:(favored?@"取消喜欢":@"喜欢") forKey:@"操作类型"];
    [_dic setValue:[view.data valueForKey:@"title"] forKey:@"标题"];
    [[FSAnalysis instance] logEvent:COMMON_LIKE_UNLIKE withParameters:_dic];
    
}

-(void) updateFavorButtonStatus:(UIBarButtonItem *)button canFavored:(BOOL)canfavored
{
    NSString *name = canfavored?@"bottom_nav_like_icon":@"bottom_nav_notlike_icon";
    UIImage *sheepImage = [UIImage imageNamed:name];
    if (!button.customView)
    {
        UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sheepButton setShowsTouchWhenHighlighted:YES];
        [sheepButton addTarget:self action:@selector(doFavor:) forControlEvents:UIControlEventTouchUpInside];
        button.customView = sheepButton;
    }
    UIButton *sheepButton = (UIButton*)button.customView;
    [sheepButton setImage:sheepImage forState:UIControlStateNormal];
    [sheepButton sizeToFit];
}

- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

- (IBAction)doComment:(id)sender {
    [FSModelManager localLogin:self withBlock:^{
        if (_inLoading) {
            return;
        }
        
        id currentView =  self.paginatorView.currentPage;
        isReplyToAll = YES;
        
        [self displayCommentInputView:currentView];
    }];
}

- (IBAction)doGetCoupon:(id)sender {
    if (_inLoading) {
        return;
    }
    
    [FSModelManager localLogin:self withBlock:^{
        [self startProgress:NSLocalizedString(@"coupon use instruction", nil) withExeBlock:^(dispatch_block_t callback){
            [self internalGetCoupon:callback];
        } completeCallbck:^{
            [self endProgress];
        }];
    }];
}

- (IBAction)doShare:(id)sender {
//    if (_inLoading) {
//        return;
//    }
    NSMutableArray *shareItems = [@[] mutableCopy];
    id view = self.paginatorView.currentPage;
    NSString *title = [self.itemSource valueForKey:@"title"];
    title = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"share prefix", nil),title];
    [shareItems addObject:title?title:@""];
    if ([view imgView].image != nil)
    {
        [shareItems addObject:[view imgView].image];
        if ([view imageURL]) {
            [shareItems addObject:[view imageURL]];
        }
    }
    
    [[FSShareView instance] shareBegin:self withShareItems:shareItems  completeHander:^(NSString *activityType, BOOL completed){
        if (completed)
        {
            [self reportError:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
        }
    }];
}

- (IBAction)showBrand:(id)sender {
    FSDetailBaseView * view = (FSDetailBaseView*)self.paginatorView.currentPage;
    FSBrand *tbrand = [view.data brand];
    FSProductListViewController *dr = [[FSProductListViewController alloc] initWithNibName:@"FSProductListViewController" bundle:nil];
    dr.brand = tbrand;
    dr.pageType = FSPageTypeBrand;
    [self.navigationController pushViewController:dr animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"活动详情页-品牌" forKey:@"来源"];
    [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST withParameters:_dic];
}

- (IBAction)goStore:(id)sender {
    FSDetailBaseView * view = (FSDetailBaseView*)self.paginatorView.currentPage;
    FSStore *store = [view.data store];
    FSStoreDetailViewController *sv = [[FSStoreDetailViewController alloc] initWithNibName:@"FSStoreDetailViewController" bundle:nil];
    sv.storeID = store.id;
    sv.title = store.name;
    [self.navigationController pushViewController:sv animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [_dic setValue:store.name forKey:@"实体店名称"];
    [_dic setValue:[NSString stringWithFormat:@"%d", store.id] forKey:@"实体店ID"];
    [_dic setValue:(_sourceType == FSSourceProduct?@"商品详情页":@"促销详情页") forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_STORE_DETAIL withParameters:_dic];
}

- (IBAction)dailPhone:(id)sender {
    FSDetailBaseView * view = (FSDetailBaseView*)self.paginatorView.currentPage;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", [view.data contactPhone]]];
	[[UIApplication sharedApplication] openURL:url];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:7];
    [_dic setValue:[view.data contactPhone] forKey:@"电话号码"];
    [_dic setValue:[[view.data brand] name] forKey:@"品牌"];
    [_dic setValue:[[view.data store] name] forKey:@"实体店名称"];
    [_dic setValue:[view.data title] forKey:@"商品名称"];
    [_dic setValue:[view.data fromUser].nickie forKey:@"商品上传者"];
    [_dic setValue:[view.data fromUser].uid forKey:@"商品上传者ID"];
    [_dic setValue:@"商品详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:DIAL_PRODUCT_PHONE withParameters:_dic];
}

- (IBAction)goDR:(NSNumber *)userid {

    FSDRViewController *dr = [[FSDRViewController alloc] initWithNibName:@"FSDRViewController" bundle:nil];
    dr.userId = [userid intValue];
    [self.navigationController pushViewController:dr animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:_sourceType==FSSourceProduct?@"商品详情页":@"促销详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_DAREN_DETAIL withParameters:_dic];
}

-(void) goTag:(id)sender
{
    
    if (![[self itemSource] respondsToSelector:@selector(tagId)])
    {
        return;
    }
    int input = [[[self itemSource] valueForKey:@"tagId"] intValue];
    FSSearchViewController *tag = [[FSSearchViewController alloc] initWithNibName:@"FSSearchViewController" bundle:nil];
    tag.searchTag = input;
    tag.navigationItem.title = [[self itemSource] valueForKey:@"title"];
    [self.navigationController pushViewController:tag animated:TRUE];
}

- (IBAction)doFavor:(id)sender {
    if (_inLoading) {
        return;
    }
    
    __block id view = self.paginatorView.currentPage;
    
    [FSModelManager localLogin:self withBlock:^{
        if ([view respondsToSelector:@selector(btnFavor)])
        {
            UIBarButtonItem *favorButton = [view btnFavor];
            [self internalDoFavor:favorButton];
        }
    }];
}

- (IBAction)contact:(id)sender {
    //跳转私信列表，需要提前登录
//    if (_inLoading) {
//        return;
//    }
    
    __block FSDetailBaseView * currentView = (FSDetailBaseView*)self.paginatorView.currentPage;
    FSUser * fromUser = [currentView.data valueForKey:@"fromUser"];
    if ([fromUser.uid intValue] == [[FSUser localProfile].uid intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"不能和自己联系" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [FSModelManager localLogin:self withBlock:^{
        //to private letter list
        FSProdItemEntity *_item = currentView.data;
        NSMutableString *msg = [NSMutableString stringWithFormat:@""];
        [msg appendFormat:@"商品名称:%@\n",_item.title];
        [msg appendFormat:@"品牌:%@\n", _item.brand.name];
        if (![NSString isNilOrEmpty:_item.upccode]) {
            [msg appendFormat:@"货号:%@\n", _item.upccode];
        }
        FSMessageViewController *viewController = [[FSMessageViewController alloc] init];
        viewController.touchUser = _item.fromUser;
        viewController.preSendMsg = msg;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
         [self presentViewController:nav animated:YES completion:nil];
        
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"商品详情页" forKey:@"来源页面"];
        [_dic setValue:viewController.touchUser.nickie forKey:@"私信对象名称"];
        [_dic setValue:viewController.touchUser.uid forKey:@"私信对象ID"];
        [[FSAnalysis instance] logEvent:CHECK_MESSAGE_PAGE withParameters:_dic];
    }];
}

- (IBAction)buy:(id)sender {
    //点击购买，需要提前登录
//    if (_inLoading) {
//        return;
//    }
    
    [FSModelManager localLogin:self withBlock:^{
        //to buy
        FSBuyCenterViewController *controller = [[FSBuyCenterViewController alloc] initWithNibName:@"FSBuyCenterViewController" bundle:nil];
        FSDetailBaseView * currentView = (FSDetailBaseView*)self.paginatorView.currentPage;
        FSProdItemEntity *_item = currentView.data;
        controller.productID = _item.id;
        [self.navigationController pushViewController:controller animated:YES];
        
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:6];
        [_dic setValue:_item.upccode forKey:@"商品货号"];
        [_dic setValue:_item.brand.name forKey:@"品牌"];
        [_dic setValue:_item.store.name forKey:@"实体店名称"];
        [_dic setValue:_item.title forKey:@"商品名称"];
        [_dic setValue:@"商品详情页" forKey:@"来源页面"];
        [_dic setValue:[NSString stringWithFormat:@"%.2f", [_item.price floatValue]] forKey:@"商品价格"];
        [[FSAnalysis instance] logEvent:PRODUCT_BUY_INFO withParameters:_dic];
    }];
}

-(void)didTapProImage:(id) sender
{
    if ([self numberOfImagesInSlides:nil]<=0)
        return;
    
    NSMutableArray *photoArray=[NSMutableArray arrayWithCapacity:[[self itemSource] resource].count];
    for(FSResource *res in [[self itemSource] resource])
    {
        if (res.type == 2) {
            continue;
        }
        MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[res absoluteUrl320] name:nil];
        [photoArray addObject:photo];
    }
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photoArray];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    int width = 100;
    photoController.beginRect = CGRectMake((APP_WIDTH-width)/2, (APP_HIGH-width)/2, width, width);
    photoController.source = self;
    //[self presentModalViewController:photoController animated:YES];
    [self presentViewController:photoController animated:YES completion:nil];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [_dic setValue:(_sourceType == FSSourceProduct?@"商品详情页":@"活动详情页") forKey:@"来源页面"];
    [_dic setValue:[[self itemSource] title] forKey:@"标题"];
    [[FSAnalysis instance] logEvent:CHECK_BIG_IMAGE withParameters:nil];
}

-(void)didTapImages:(id) sender
{
    UITapGestureRecognizer * tap = (UITapGestureRecognizer*)sender;
    FSDetailBaseView * view = (FSDetailBaseView*)self.paginatorView.currentPage;
    UIImageView *prodImage = (UIImageView *)[(id)view imgView];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [UIView animateWithDuration:0.3 animations:^{
        tap.view.frame = prodImage.frame;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

- (void) displayCommentInputView:(id)parent
{
    FSProCommentInputView *commentInput = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    if (!commentInput)
    {
        commentInput = [[[NSBundle mainBundle] loadNibNamed:@"FSProCommentInputView" owner:self options:nil] objectAtIndex:0];
        CGFloat height = PRO_DETAIL_COMMENT_INPUT_HEIGHT;
        commentInput.frame = CGRectMake(0, self.view.frame.size.height-TOOLBAR_HEIGHT-height, self.view.frame.size.width, height);
        commentInput.txtComment.delegate = self;
        
        [commentInput.btnComment addTarget:self action:@selector(saveComment:) forControlEvents:UIControlEventTouchUpInside];
        [commentInput.btnCancel addTarget:self action:@selector(clearComment:) forControlEvents:UIControlEventTouchUpInside];
        [commentInput.btnChange addTarget:self action:@selector(changeCommentType:) forControlEvents:UIControlEventTouchUpInside];
        commentInput.btnChange.showsTouchWhenHighlighted = YES;
        
        //设置按钮背景图片
        UIImage *image = [UIImage imageNamed:@"audio_btn_normal.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 50, image.size.height, image.size.width-50)];
        [commentInput.btnAudio setBackgroundImage:image forState:UIControlStateNormal];
        
        image = [UIImage imageNamed:@"audio_btn_sel.png"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 50, image.size.height, image.size.width-50)];
        [commentInput.btnAudio setBackgroundImage:image forState:UIControlStateHighlighted];
        
        [commentInput.btnAudio addTarget:self action:@selector(recordTouchDown:) forControlEvents:UIControlEventTouchDown];
        [commentInput.btnAudio addTarget:self action:@selector(recordTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [commentInput.btnAudio addTarget:self action:@selector(recordTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [commentInput.btnAudio addTarget:self action:@selector(recordTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [commentInput.btnAudio addTarget:self action:@selector(recordTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
        [self.view addSubview:commentInput];
        
        commentInput.tag = PRO_DETAIL_COMMENT_INPUT_TAG;
        if  (commentInput.opaque!=1)
        {
            commentInput.layer.opacity = 0;
            [UIView beginAnimations:@"fadein" context:(__bridge void *)([NSNumber numberWithFloat:commentInput.layer.opacity])];
            [UIView setAnimationDuration:0.5];
            commentInput.layer.opacity = 1;
            [UIView commitAnimations];
            commentInput.opaque = 1;
            [self.view bringSubviewToFront:commentInput];
        }

    }
    else if(isReplyToAll)
    {
        [self hideCommentInputView:parent];
    }
    [self changeCommentType:nil];
}

-(void) hideCommentInputView:(id)parent
{
    FSProCommentInputView *commentInput = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    //如果commentInput不为空，则
    if (commentInput)
    {
        commentInput.txtComment.text = @"";
        [commentInput.txtComment resignFirstResponder];
        [commentInput removeFromSuperview];
        if (commentInput.opaque!=0)
        {
            commentInput.layer.opacity = 1;
            [UIView beginAnimations:@"fadeout" context:(__bridge void *)([NSNumber numberWithFloat:commentInput.layer.opacity])];
            [UIView setAnimationDuration:0.3];
            commentInput.layer.opacity = 0;
            [UIView commitAnimations];
            [commentInput removeFromSuperview];
        }
    }
}
-(void)clearComment:(UIButton *)sender
{
    //隐藏输入区域
    [self hideCommentInputView:self.view];
    //取消任何回复特定用户的选项
    replyIndex = -1;
    id currentView =  self.paginatorView.currentPage;
    [[currentView tbComment] reloadData];
}

//当点击语音和文字的切换按钮时，更新显示元素
-(void)changeCommentType:(UIButton*)sender
{
    FSProCommentInputView *commentInput = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    if (commentInput) {
        if (commentInput.txtComment.isFirstResponder) {
            if (sender) {
                [commentInput.txtComment resignFirstResponder];
                [commentInput.btnChange setImage:[UIImage imageNamed:@"text_change_icon.png"] forState:UIControlStateNormal];
                [commentInput updateControls:2];
                _isAudio = YES;
            }
            else{
                [commentInput.btnChange setImage:[UIImage imageNamed:@"audio_change_icon.png"] forState:UIControlStateNormal];
                [commentInput updateControls:1];
                _isAudio = NO;
            }
        }
        else{
            if (sender) {
                [commentInput.txtComment becomeFirstResponder];
                [commentInput.btnChange setImage:[UIImage imageNamed:@"audio_change_icon.png"] forState:UIControlStateNormal];
                [commentInput updateControls:1];
                _isAudio = NO;
            }
            else{
                [commentInput.btnChange setImage:[UIImage imageNamed:@"text_change_icon.png"] forState:UIControlStateNormal];
                [commentInput updateControls:2];
                _isAudio = YES;
            }
        }
        if (isReplyToAll) {
            commentInput.replyLabel.text = NSLocalizedString(@"Reply All", nil);
        }
        else{
            //获取选中用户的ID；
            id currentView =  self.paginatorView.currentPage;
            FSDetailBaseView *parentView = (FSDetailBaseView *)[currentView tbComment].superview.superview;
            FSComment *item = (FSComment*)[[parentView.data comments] objectAtIndex:replyIndex];
            commentInput.replyLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Reply %@", nil), item.inUser.nickie];
        }
    }
}

-(NSString *)transformCommentText
{
    FSProCommentInputView *commentView = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    NSString *trimedText = [[commentView.txtComment.text stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    return trimedText;
}

-(void)saveComment:(UIButton *)sender
{
    FSProCommentInputView *commentView = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    [commentView.txtComment resignFirstResponder];
    if (!_isAudio) {
        NSString *trimedText = commentView.txtComment.text;//[self transformCommentText];
        if (trimedText.length>40 ||trimedText.length<1)
        {
            [self clearComment:nil];
            [self reportError:NSLocalizedString(@"PRO_COMMENT_LENGTH_NOTCORRECT", Nil)];
            return;
        }
    }
    
    [self startProgress:NSLocalizedString(@"FS_PRODETAIL_COMMING",nil) withExeBlock:^(dispatch_block_t callback){
        [self internalDoComent:callback];
    } completeCallbck:^{
        [self endProgress];
    }];
}

-(void) internalDoComent:(dispatch_block_t)callback
{
    FSProCommentInputView *commentView = (FSProCommentInputView*)[self.view viewWithTag:PRO_DETAIL_COMMENT_INPUT_TAG];
    NSString *commentText = commentView.txtComment.text;
    FSCommonCommentRequest *request = [[FSCommonCommentRequest alloc] init];
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.sourceid = [[(FSDetailBaseView *)self.paginatorView.currentPage data] valueForKey:@"id"];
    request.sourceType = [NSNumber numberWithInt:_sourceType];
    request.routeResourcePath = RK_REQUEST_COMMENT_SAVE;
    request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE];
    BOOL flag = _isAudio && (_recordFileName && ![_recordFileName isEqualToString:@""]);
    request.isAudio = flag;
    if (flag) {
        request.comment = nil;
        request.audioName = [kRecorderDirectory stringByAppendingPathComponent:_recordFileName];
    }
    else{
        request.comment = commentText;
        request.audioName = nil;
    }
    //回复特用户
    if (!isReplyToAll) {
        //获取选中用户的ID；
        id currentView =  self.paginatorView.currentPage;
        FSDetailBaseView *parentView = (FSDetailBaseView *)[currentView tbComment].superview.superview;
        FSComment *item = (FSComment*)[[parentView.data comments] objectAtIndex:replyIndex];
        request.replyuserID = item.inUser.uid;
        
        //回复其他人
        //sourcetype=3时，sourceid是comment的id
        request.sourceid = [NSNumber numberWithInt:item.commentid];
        request.sourceType = [NSNumber numberWithInt:FSSourceComment];
    }
    
    __block FSProDetailViewController *blockSelf = self;
    FSDetailBaseView *view = (FSDetailBaseView*)blockSelf.paginatorView.currentPage;
    [request upload:^(id data){
        [blockSelf updateProgress:NSLocalizedString(@"COMM_OPERATE_COMPL",nil)];
        //删除评论语音文件
        NSLock* tempLock = [[NSLock alloc]init];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:_recordFileName])
        {
            [[NSFileManager defaultManager] removeItemAtPath:_recordFileName error:nil];
        }
        [tempLock unlock];
        
        replyIndex = -1;
        _recordFileName = @"";
        if (callback) {
            callback();
        }
        
        if (data) {
            //创建FSComment对象
            NSMutableArray *oldComments = [[(FSDetailBaseView *)blockSelf.paginatorView.currentPage data] comments];
            if (!oldComments)
                oldComments = [@[] mutableCopy];
            FSComment *_comment = [[FSComment alloc] init];
            _comment.id = [[data objectForKey:@"commentid"] intValue];
            if (isReplyToAll) {
                _comment.replyUserID = nil;
                _comment.replyUserName = nil;
            }
            else{
                _comment.replyUserName = [data objectForKey:@"replycustomer_nickname"];
                _comment.replyUserID = [[data objectForKey:@"replycustomer_id"] intValue];
            }
            FSUser *user = [[FSUser alloc] init];
            id customer = [data objectForKey:@"customer"];
            if (customer) {
                user.uid = [NSNumber numberWithInt:[[customer objectForKey:@"id"] intValue]];
                user.thumnail = [customer objectForKey:@"logo"];
                user.nickie = [customer objectForKey:@"nickname"];
                if ([customer objectForKey:@"level"]) {
                    user.userLevelId = [[customer objectForKey:@"level"] intValue];
                }
                else {
                    user.userLevelId = FSNormalUser;
                }
                _comment.inUser = user;
            }
            
            _comment.indate = [NSDate date];
            if (_isAudio) {
                _comment.comment = nil;
                id items = [data objectForKey:@"resources"];
                NSLog(@"items:%@", items);
                if ([items count] > 0) {
                    id resources = [items objectAtIndex:0];
                    NSLog(@"resources:%@", resources);
                    FSResource *_resource = [[FSResource alloc] init];
                    _resource.domain = [resources objectForKey:@"domain"];
                    _resource.relativePath = [resources objectForKey:@"name"];
                    _resource.width = [[resources objectForKey:@"width"] intValue];
                    _resource.type = [[resources objectForKey:@"type"] intValue];
                    _comment.resources = [[NSMutableArray alloc] initWithObjects:_resource, nil];
                }
            }
            else{
                _comment.comment = commentView.txtComment.text;//[self transformCommentText];
            }
            [oldComments insertObject:_comment atIndex:0];
        }
        
        [[(id)blockSelf.paginatorView.currentPage tbComment] reloadData];
        __block FSDetailBaseView * blockViewForRefresh = (FSDetailBaseView*)self.paginatorView.currentPage;
        CGRect _rect = [(id)blockViewForRefresh tbComment].frame;
        if ([self IsBindPromotionOrProduct:blockViewForRefresh.data]) {
            _rect.size.height = 160;
        }
        else{
            _rect.size.height = 120;
        }
        [[(id)blockViewForRefresh svContent] scrollRectToVisible:_rect animated:YES];
        
        //隐藏输入框
        [self clearComment:nil];
        
    } error:^(id error){
        [blockSelf reportError:error];
        if (callback) {
            callback();
        }
    }];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:7];
    [_dic setValue:(_sourceType == FSSourceProduct?@"商品详情页":@"活动详情页") forKey:@"来源页面"];
    [_dic setValue:[view.data valueForKey:@"title"] forKey:@"标题"];
    [_dic setValue:commentText forKey:@"评论内容"];
    [_dic setValue:[NSNumber numberWithBool:flag] forKey:@"是否语音评论"];
    [_dic setValue:[NSNumber numberWithBool:isReplyToAll] forKey:@"是否回复所有人"];
    FSUser *user = [FSUser localProfile];
    [_dic setValue:user.uid forKey:@"用户ID"];
    [_dic setValue:user.nickie forKey:@"用户昵称"];
    [[FSAnalysis instance] logEvent:COMMON_COMMENT withParameters:_dic];
}

-(void)toEndProgress
{
    [self endProgress];
}

-(BOOL)IsBindPromotionOrProduct:(id)_item
{
    if (!_item) {
        return NO;
    }
    if ([_item isKindOfClass:[FSProdItemEntity class]]) {
        if (((FSProdItemEntity*)_item).promotions.count > 0) {
            return YES;
        }
    }
    else if([_item isKindOfClass:[FSProItemEntity class]]) {
        return [((FSProItemEntity*)_item).isProductBinded boolValue];
    }
    
    return NO;
}

-(BOOL)hasNextPage
{
    if (self.currentPageIndex == navContext.count - 1) {
        return NO;
    }
    return YES;
}

-(BOOL)hasPrePage
{
    if (self.currentPageIndex == 0) {
        return NO;
    }
    return YES;
}

#pragma mark - FSImageSlide datasource
-(int)numberOfImagesInSlides:(EGOPhotoViewController *)view
{
    return [[self itemSource] resource].count;
}
-(NSURL *)imageSlide:(EGOPhotoViewController *)view imageNameForIndex:(int)index
{
    return [(FSResource *)[[[self itemSource] resource] objectAtIndex:index] absoluteUrl320];
}
-(void)imageSlide:(EGOPhotoViewController *)view didShareTap:(BOOL)shared
{
    NSMutableArray *shareItems = [@[] mutableCopy];
    id curView = self.paginatorView.currentPage;
    NSString *title = [self.itemSource valueForKey:@"title"];
    [shareItems addObject:title?title:@""];
    if ([curView imgView].image != nil)
    {
        [shareItems addObject:[curView imgView].image];
    }
    
    [[FSShareView instance] shareBegin:view withShareItems:shareItems  completeHander:^(NSString *activityType, BOOL completed){
        if (completed)
        {
            [view reportError:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
        }
    }];
}
#pragma mark - FSThumbView delegate
-(void)didTapThumView:(id)sender
{
   if ([sender isKindOfClass:[FSThumView class]])
   {
       [self goDR:[(FSThumView *)sender ownerUser].uid];
   }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (_sourceType == FSSourceProduct) {
            if ([self IsBindPromotionOrProduct:parentView.data]) {
                //去活动详情
                FSProdItemEntity *_item = parentView.data;
                if (_item.promotions && _item.promotions.count > 0) {
                    FSProDetailViewController *detailView = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
                    detailView.navContext = _item.promotions;
                    detailView.sourceType = FSSourcePromotion;
                    detailView.indexInContext = 0;
                    detailView.dataProviderInContext = self;
                    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailView];
                    [self presentViewController:navControl animated:true completion:nil];
                    
                    //统计
                    FSProItemEntity *item = [_item.promotions objectAtIndex:0];
                    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:5];
                    [_dic setValue:item.title forKey:@"促销名称"];
                    [_dic setValue:[NSString stringWithFormat:@"%d", item.id] forKey:@"促销ID"];
                    [_dic setValue:item.store.name forKey:@"实体店名称"];
                    [_dic setValue:@"商品详情页" forKey:@"来源页面"];
                    [_dic setValue:item.startDate forKey:@"发布时间"];
                    [[FSAnalysis instance] logEvent:CHECK_PROLIST_DETAIL withParameters:_dic];
                    
                    [[FSAnalysis instance] autoTrackPages:navControl];
                }
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewSource delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        if (section == 0) {
            return nil;
        }
    }
    FSProCommentHeader * view = [[[NSBundle mainBundle] loadNibNamed:@"FSProCommentHeader" owner:self options:nil] lastObject];
    view.count = [[parentView.data comments] count];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self resetScrollViewSize:(FSDetailBaseView*)tableView.superview.superview];
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        return 2;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if (!parentView.data) {
        return 0;
    }
    int yOffset = PRO_DETAIL_COMMENT_HEADER_HEIGHT + 5;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        if (section == 0) {
            return 1;
        }
        yOffset += 70;
    }
    NSMutableArray *comments = [parentView.data comments];
    if (!comments ||
        comments.count<=0) {
        [self showNoResult:tableView withText:NSLocalizedString(@"no comments", Nil) originOffset:yOffset];
    }
    else
        [self hideNoResult:tableView];
    return comments?comments.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        if (indexPath.section == 0) {
            if (_sourceType == FSSourceProduct) {
                UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"FSSourceProduct_Promotion"];
                if (_cell == nil) {
                    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FSSourceProduct_Promotion"];
                    _cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    _cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
                FSProdItemEntity *_item = parentView.data;
                if (_item.promotions.count > 0) {
                    FSProItemEntity *_proItem = _item.promotions[0];
                    _cell.textLabel.text = _proItem.title;
                    _cell.textLabel.font = ME_FONT(12);
                    _cell.textLabel.textColor = [UIColor colorWithHexString:@"#181818"];
                    _cell.detailTextLabel.text = _proItem.descrip;
                    _cell.detailTextLabel.font = ME_FONT(12);
                    _cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#666666"];
                    _cell.detailTextLabel.numberOfLines = 2;
                    UILabel *_line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
                    _line.backgroundColor = RGBCOLOR(213, 213, 213);
                    [_cell addSubview:_line];
                }
                
                return _cell;
            }
            else {
                UITableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"FSSourcePromotion_Product"];
                if (_cell == nil) {
                    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FSSourcePromotion_Product"];
                    _cell.accessoryType = UITableViewCellAccessoryNone;
                    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    int xOffset = 50;
                    UIButton *btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnAttention.frame = CGRectMake(xOffset, 15, APP_WIDTH - xOffset * 2, 40);
                    [btnAttention setTitle:@"查看参与活动商品列表" forState:UIControlStateNormal];
                    [btnAttention setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
                    [btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btnAttention.titleLabel.font = [UIFont boldSystemFontOfSize:15];
                    [btnAttention addTarget:self action:@selector(clickToProductList:) forControlEvents:UIControlEventTouchUpInside];
                    [_cell addSubview:btnAttention];
                }
                return _cell;
            }
        }
    }
    FSProCommentCell *detailCell =  [tableView dequeueReusableCellWithIdentifier:@"FSProCommentCell"];
    detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [detailCell setData:[[parentView.data comments] objectAtIndex:indexPath.row]];
    detailCell.btnComment.tag = indexPath.row;
    [detailCell.btnComment addTarget:self action:@selector(replyComment:) forControlEvents:UIControlEventTouchUpInside];
    if (replyIndex != indexPath.row) {
        [detailCell.btnComment setImage:[UIImage imageNamed:@"comment_icon.png"] forState:UIControlStateNormal];
    }
    else{
        [detailCell.btnComment setImage:[UIImage imageNamed:@"comment_sel_icon.png"] forState:UIControlStateNormal];
    }
    if (!detailCell.audioButton.audioDelegate) {
        detailCell.audioButton.audioDelegate = self;
    }
    detailCell.imgThumb.delegate = self;
    [detailCell updateFrame];
   
    return detailCell;
}

-(void)clickToProductList:(UIButton*)sender
{
    FSDetailBaseView * currentView = (FSDetailBaseView*)self.paginatorView.currentPage;
    if ([self IsBindPromotionOrProduct:currentView.data]) {
        //去商品列表
        FSProItemEntity *_item = currentView.data;
        FSProductListViewController *dr = [[FSProductListViewController alloc] initWithNibName:@"FSProductListViewController" bundle:nil];
        dr.titleName = NSLocalizedString(@"Product List", nil);
        dr.commonID = _item.id;
        dr.pageType = FSPageTypeCommon;
        [self.navigationController pushViewController:dr animated:TRUE];
        
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic setValue:@"实体店详情页-参与活动商品列表" forKey:@"来源"];
        [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST withParameters:_dic];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        if (indexPath.section == 0) {
            if (_sourceType == FSSourceProduct) {
                return 70;
            }
            return 70;
        }
    }
    FSProCommentCell *cell = (FSProCommentCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    FSDetailBaseView *parentView = (FSDetailBaseView *)tableView.superview.superview;
    if ([self IsBindPromotionOrProduct:parentView.data]) {
        if (section == 0) {
            return 0;
        }
    }
    return PRO_DETAIL_COMMENT_HEADER_HEIGHT;
}

-(void)replyComment:(UIButton*)sender
{
    if(replyIndex == sender.tag) {
        replyIndex = -1;
        isReplyToAll = YES;
    }
    else{
        replyIndex = sender.tag;
        isReplyToAll = NO;
    }
    id currentView =  self.paginatorView.currentPage;
    [[currentView tbComment] reloadData];
    [self displayCommentInputView:currentView];
}

#pragma mark - UITEXTFIELD DELEGATE
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.superview.superview isKindOfClass:[FSProCommentInputView class]]) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if (textView.text.length > 39) {
            return NO;
        }
    }
    return YES;
}

- (void)viewDidUnload {
    if (lastButton) {
        [lastButton stop];
    }
    [self set_thumView:nil];
    [self setArrowLeft:nil];
    [self setArrowRight:nil];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (lastButton) {
        [lastButton stop];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - FSProDetailItemSourceProvider

-(void)proDetailViewDataFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index  completeCallback:(UICallBackWith1Param)block errorCallback:(dispatch_block_t)errorBlock
{
    FSProItemEntity *item =  [view.navContext objectAtIndex:index];
    if (item)
        block(item);
    else
        errorBlock();
    
}
-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return FSSourcePromotion;
}

-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return TRUE;
}

#pragma mark record function

- (BOOL)startToRecord
{
    if (_isRecording == NO)
    {
        [theApp initAudioRecoder];
        theApp.audioRecoder.clAudioDelegate = self;
        _isRecording = YES;
        _recordFileName = [NSString stringWithFormat:@"%f.m4a", [[NSDate date] timeIntervalSince1970]];
        theApp.audioRecoder.recorderingFileName = _recordFileName;
        return [theApp.audioRecoder startRecord];
    }
    return NO;
}

- (void)endRecord
{
//    [self updateProgress:@"语音文件生成中。。。"];
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [theApp.audioRecoder stopRecord];
        });
    });
    //dispatch_release(stopQueue);
}

-(void)endRecordAndDelete
{
//    [self updateProgress:@"语音文件生删除中。。。"];
    dispatch_queue_t stopQueue;
    stopQueue = dispatch_queue_create("stopQueue", NULL);
    dispatch_async(stopQueue, ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [theApp.audioRecoder stopAndDeleteRecord];
        });
    });
    //dispatch_release(stopQueue);
}

#pragma mark button action

- (IBAction)recordTouchDown:(id)sender
{
    if (_inLoading) {
        return;
    }
    
    if (_isRecording) {
        _recordState = PTRecording;
        return;
    }
    _downTime = [NSDate date];
    [sender setTitle:NSLocalizedString(@"Up To End Record", nil) forState:UIControlStateNormal];
    if (![self startToRecord]) {
        [self endRecord];
        return;
    }
    
    _recordState = PTRecording;
    if (lastButton) {
        [lastButton pause];
    }
    [_audioShowView showAudioView];
    [self startShowAnimation];
}

- (IBAction)recordTouchUpInside:(id)sender
{
    [self endTouch:sender];
}

- (IBAction)recordTouchUpOutside:(id)sender
{ 
    //删除录音
    [sender setTitle:NSLocalizedString(@"Down To Start Comment", nil) forState:UIControlStateNormal];
    _recordState = PTStartRecord;
    [self endRecordAndDelete];
    [self endShowAnimation];
}

- (IBAction)recordTouchDragEnter:(id)sender
{
    //显示语音动画按钮，隐藏回收按钮
    [_audioShowView showAudioView];
}

- (IBAction)recordTouchDragExit:(id)sender
{
    //显示回收按钮，隐藏语音动画按钮
    [_audioShowView showTrashView];
}

-(void)endTouch:(id)sender
{
    if(_recordState == PTRecording){
        NSInteger gap = [[NSDate date] timeIntervalSinceDate:_downTime];
        if (gap < _minRecordGap) {
            //显示提示时间太短对话框
            [self reportError:NSLocalizedString(@"Speak Too Short, Please Say Again", nil)];
            //重新设置为起始状态
            [sender setTitle:NSLocalizedString(@"Down To Start Comment", nil) forState:UIControlStateNormal];
            _recordState = PTStartRecord;
            [self endRecordAndDelete];
        }
        else{
            [sender setTitle:NSLocalizedString(@"Down To Start Comment", nil) forState:UIControlStateNormal];
            [self endRecord];
            id currentView =  self.paginatorView.currentPage;
            [[currentView tbComment] reloadData];
        }
    }
    else{
        [self endShowAnimation];
        NSLog(@"问题1");
    }
}

-(void)sendToService
{
    //直接发送
    [self saveComment:nil];
}

#pragma mark - FSAudioDelegate

-(void)clickAudioButton:(FSAudioButton*)aButton
{
    if (lastButton) {
        if (lastButton != aButton) {
            [lastButton stop];
        }
    }
    lastButton = aButton;
}

#pragma mark - Record Animation

-(void)startShowAnimation
{
    //开启音量检测
    theApp.audioRecoder.audioRecorder.meteringEnabled = YES;
    //设置定时检测
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval: 0.1
                                         target: self
                                       selector: @selector( levelTimerCallback:)
                                       userInfo: nil
                                        repeats: YES];
    }
    [_timer fire];
    _audioShowView.hidden = NO;
}

#define AudioLabel_Height 47

//音量检测
- (void)levelTimerCallback:(NSTimer *)timer
{
    //刷新音量数据
    [theApp.audioRecoder.audioRecorder updateMeters];
    //获取音量的平均值
    CGFloat averagePower = [theApp.audioRecoder.audioRecorder averagePowerForChannel:0];
    averagePower = abs(averagePower);
    if (averagePower > AudioLabel_Height) {
        averagePower = AudioLabel_Height;
    }
    averagePower = AudioLabel_Height - averagePower;
    if (averagePower < 5) {
        averagePower = 5;
    }
    
    //更改UI的图形效果
    [_audioShowView updateAudioLabelFrame:averagePower];
}

-(void)endShowAnimation
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _audioShowView.hidden = YES;
}

#pragma mark - FSCL_AudioDelegate

-(void)stopRecorderEnd:(CL_AudioRecorder *)_record
{
    _isRecording = NO;
    [self endShowAnimation];
    [self sendToService];
}

-(void)stopAndDelRecorderEnd:(CL_AudioRecorder*)_record
{
    _isRecording = NO;
    [self endShowAnimation];
}

-(void)errorRecorderDidOccur:(CL_AudioRecorder*)_record
{
    _isRecording = NO;
    [self endShowAnimation];
}

#pragma mark - PKAddPassesViewControllerDelegate
//-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Pass Add Tip Info", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//    alert.tag = Alert_Tag_Coupon;
//    [alert show];
//}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Alert_Tag_Coupon && buttonIndex == 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UITabBarController *root = [storyBoard instantiateInitialViewController];
        root.selectedIndex = 3;
    }
}

@end
