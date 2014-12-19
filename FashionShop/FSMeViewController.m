//
//  FSMeViewController.m
//  FashionShop
//
//  Created by gong yi on 11/8/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSMeViewController.h"
#import "FSLocalPersist.h"
#import "FSConfiguration.h"
#import "FSUserLoginRequest.h"
#import "FSUserProfileRequest.h"
#import "FSFavorRequest.h"
#import "FSUser.h"
#import "FSFavor.h"
#import "FSPagedFavor.h"
#import "FSBothItems.h"
#import "FSFavorProCell.h"
#import "FSCoupon.h"
#import "FSPagedItem.h"
#import "FSItemBase.h"
#import "FSPointViewController.h"
#import "FSLikeViewController.h"
#import "FSCommonUserRequest.h"
#import "FSThumnailRequest.h"
#import "FSCommonUserRequest.h"
#import "FSProPostMainViewController.h"
#import "FSCommonProRequest.h"
#import "FSLoadMoreRefreshFooter.h"
#import "FSMoreViewController.h"
#import "FSGiftListViewController.h"
#import "FSMyCommentController.h"

#import "FSModelManager.h"
#import "FSLocationManager.h"
#import "UIImageView+WebCache.h"
#import "TCWBEngine.h"
#import <PassKit/PassKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

#define LOGIN_FROM_3RDPARTY_ACTION @"LOGIN_FROM_3RDPARTY"
#define LOGIN_GET_USER_PROFILE @"LOGIN_GET_USERPROFILE"
#define LOGIN_GET_USER_LIKE @"LOGIN_GET_USERLIKEPRO"
#define LOGIN_GET_USER_SHARE @"LOGIN_GET_USERSHARE"
#define I_LIKE_COLUMNS 3;
#define ITEM_CELL_WIDTH 100;
#define LOADINGVIEW_HEIGHT 44
#define REFRESHINGVIEW_HEIGHT 60
#define Favorite_Delete_Alert_Tag 1010
#define Actionsheet_Publish_Tag 1020
#define Actionsheet_Delete_Tag 1021
#define Actionsheet_Takephoto_Tag 1022

@interface MyActionSheet : UIActionSheet
@property (nonatomic, strong) id object;
@end

@implementation MyActionSheet
@synthesize object;
@end

@interface FSMeViewController ()
{
    UIView          *_loginView;
    UIView          *_userProfileView;
    SinaWeibo       *_weibo;
    TCWBEngine      *_qq;
    FSQQConnectActivity *_qqConnect;
    NSMutableDictionary *_dataSourceProvider;
    bool            _isLogined;
    
    FSUser          *_userProfile;
    NSMutableArray  *_likePros;
    bool            _isFirstLoad;
    BOOL            isDeletionModeActive;
    BOOL            _isInLoading;
    BOOL            _IsRequestUserInfo;
    BOOL            _isInRefreshing;
    int             _favorPageIndex;
    BOOL            _noMoreFavor;
    UIActivityIndicatorView *moreIndicator;
    UIImagePickerController *_camera;
    
    int             _takePhotoSource;//1:头像更改；2:更改me的主页背景
    BOOL            _toDetail;//是否是去详情页
}

@end

@implementation FSMeViewController
@synthesize completeCallBack;

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
   
    _dataSourceProvider = [@{} mutableCopy];
    [self ensureDataContext];
    __block FSMeViewController *blockSelf = self;
    [_dataSourceProvider setValue:^(FSUserLoginRequest *request){
        [blockSelf beginLoading:blockSelf->_tbScroll];
        blockSelf->_IsRequestUserInfo = YES;
        [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *response) {
            [blockSelf endLoading:blockSelf->_tbScroll];
            blockSelf->_IsRequestUserInfo = NO;
            if (!response.isSuccess)
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(false);
                }
            }
            else
            {
                blockSelf->_userProfile = (FSUser *)response.responseData;
                [blockSelf->_userProfile save];
                
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(true);
                }
                else
                {
                    [blockSelf displayUserProfile];
                }
                //发送userid和devicetoken给服务器
                [theApp registerDevicePushNotification];
                
                //set User id
                FSUser *user = [FSUser localProfile];
                if (user && user.uid) {
                    [[FSAnalysis instance] setUserID:[NSString stringWithFormat:@"%@", user.uid]];
                }
            }
            
        }];
        
        
    } forKey:LOGIN_FROM_3RDPARTY_ACTION];
    
    [_dataSourceProvider setValue:^(FSUserProfileRequest *request){
        [blockSelf beginLoading:blockSelf->_tbScroll];
        blockSelf->_IsRequestUserInfo = YES;
        [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *response) {
            [blockSelf endLoading:blockSelf->_tbScroll];
            blockSelf->_IsRequestUserInfo = NO;
            if (!response.isSuccess)
            {
                [FSUser removeUserProfile];
                [blockSelf displayUserLogin];
                
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(false);
                }
                else {
                    [blockSelf reportError:response.errorDescrip];
                }
            }
            else
            {
                blockSelf->_userProfile = (FSUser *)response.responseData;
                
                [blockSelf->_userProfile save];
                [blockSelf displayUserProfile];
                
                //set User id
                FSUser *user = [FSUser localProfile];
                if (user && user.uid) {
                    [[FSAnalysis instance] setUserID:[NSString stringWithFormat:@"%@", user.uid]];
                }
            }
            
        }];
        
        
    } forKey:LOGIN_GET_USER_PROFILE];
    
    [_dataSourceProvider setValue:^(FSFavorRequest *request,dispatch_block_t uicallback){
        [request send:[FSPagedFavor class] withRequest:request completeCallBack:^(FSEntityBase *response) {
            if (!response.isSuccess)
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(false);
                }
                else {
                    [blockSelf reportError:response.errorDescrip];
                }
            }
            else
            {
                FSPagedFavor *innerResp = response.responseData;
                if (innerResp.totalPageCount<blockSelf->_favorPageIndex+1)
                    blockSelf->_noMoreFavor = TRUE;
                else
                    blockSelf->_noMoreFavor = FALSE;
                [blockSelf fillFavorList:innerResp.items isInsert:blockSelf->_isInRefreshing];
            }
            if (uicallback)
                uicallback();
        }];
    } forKey:LOGIN_GET_USER_LIKE];
    
    [_dataSourceProvider setValue:^(FSFavorRequest *request,dispatch_block_t uicallback){
        [request send:[FSPagedItem class] withRequest:request completeCallBack:^(FSEntityBase *response) {
            if (!response.isSuccess)
            {
                if (blockSelf->completeCallBack!=nil)
                {
                    blockSelf->completeCallBack(false);
                }
                else {
                    [blockSelf reportError:response.errorDescrip];
                }
            }
            else
            {
                FSPagedItem *innerResp = response.responseData;
                if (innerResp.totalPageCount<blockSelf->_favorPageIndex+1)
                    blockSelf->_noMoreFavor = TRUE;
                else
                    blockSelf->_noMoreFavor = FALSE;
                [blockSelf fillItemslist:innerResp.items isInsert:blockSelf->_isInRefreshing];
            }
            if (uicallback)
                uicallback();
        }];
    } forKey:LOGIN_GET_USER_SHARE];
    
    NSArray *views =[[NSBundle mainBundle] loadNibNamed:@"FSLoginView" owner:self options:nil];
    _loginView = [views objectAtIndex:0];
//    if (IOS7 && ![UIDevice isRunningOniPhone5]) {
//        CGRect rect = _loginView.frame;
//        rect.origin.y -= NAV_HIGH;
//        _loginView.frame = rect;
//    }
    views = [[NSBundle mainBundle] loadNibNamed:@"FSUserProfileView" owner:self options:nil];

    _userProfileView = [views objectAtIndex:0];
//    if (IOS7) {
//        CGRect rect = _userProfileView.frame;
//        rect.origin.y -= NAV_HIGH;
//        _userProfileView.frame = rect;
//    }
    _isFirstLoad = true;
    [self switchView];
}

-(void)dealloc
{
    [self unregisterKVO];
    [self unregisterLocalNotification];
}

- (void)viewDidUnload {
    [self setLikeView:nil];
    [self setLikeContainer:nil];
    [self setThumbImg:nil];
    [self setImgLevel:nil];
    [self setSegHeader:nil];
    [self setBtnHeaderBg:nil];
    [self setTbScroll:nil];
    [self setBtnHeaderImgV:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"nav_bg_2.png"] forBarMetrics: UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    _toDetail = NO;
    if (!_IsRequestUserInfo && _likePros.count <= 0) {
        [self switchView];
    }
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (!_toDetail) {
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"top_title_bg"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        //if(!IOS7)
            self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (_toDetail) {
        [self.navigationController.navigationBar setBackgroundImage: [UIImage imageNamed: @"top_title_bg"] forBarMetrics: UIBarMetricsDefault];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    }
    [super viewDidDisappear:animated];
}

#pragma mark - Self Define Method

-(void) switchView
{
    if (_isFirstLoad)
        _isFirstLoad = false;
     _isLogined = [FSModelManager sharedModelManager].isLogined;
    if(!_isLogined)
    {
        [self displayUserLogin];
    }
    else
    {
        _userProfile = [FSUser localProfile];
        if (_userProfile == nil)
        {
            FSUserProfileRequest *request = [[FSUserProfileRequest alloc] init];
            request.userToken = [FSModelManager sharedModelManager].loginToken;
            ((DataSourceProviderRequestBlock)[_dataSourceProvider objectForKey:LOGIN_GET_USER_PROFILE])(request);
        } else
        {
            [self displayUserProfile];
        }
    }
}

-(void)didFavorRemoved:(id)favorValue
{
    FSFavor *favor =[favorValue valueForKey:@"object"];
    int index = [_likePros indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(FSFavor *)obj valueForKey:@"id"] isEqualToValue:[favor valueForKey:@"id"]])
        {
            *stop = TRUE;
            return TRUE;
        }
        return FALSE;
    }];
    if (index ==NSNotFound)
        return;
    [_likePros removeObjectAtIndex:index];
//    if (!IOS7) {
//        [_likeView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
//    }
    [_likeView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    [_likeView reloadData];
}

-(void)didItemPublished:(id)itemObj
{
    [self egoRefreshTableHeaderDidTriggerRefresh:nil];
}

-(void)didCustomerChanged:(id)user
{
    FSUser *newUser = [user valueForKey:@"object"];
    if (!newUser)
        return;
    
    _userProfile.nickie = [newUser nickie];
    _userProfile.phone = [newUser phone];
    _userProfile.gender = [newUser gender];
    _userProfile.signature = [newUser signature];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateCustomerChangeUI:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateCustomerChangeUI:keyPath];
	}
}
-(void)updateCustomerChangeUI:(NSString *)keyPath
{
    if([keyPath isEqualToString:@"nickie"])
    {
        _lblNickie.text = _userProfile.nickie;
        [_lblNickie sizeToFit];
        
        //更新达人标志位置
        CGRect origFrame = _imgLevel.frame;
        origFrame.origin.x = _lblNickie.frame.origin.x+_lblNickie.frame.size.width+4;
        origFrame.origin.y = (_lblNickie.frame.size.height - origFrame.size.height)/2 + _lblNickie.frame.origin.y;
        _imgLevel.frame = origFrame;
    }
    else if ([keyPath isEqualToString:@"pointsTotal"]) {
        //   [_btnPoints setTitle:[NSString stringWithFormat:@"%d",_userProfile.pointsTotal] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"couponsTotal"]) {
        [_btnCoupons setTitle:[NSString stringWithFormat:@"%d",_userProfile.couponsTotal] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"likeTotal"]) {//我关注的
        [_btnLike setTitle:[NSString stringWithFormat:@"%d", _userProfile.likeTotal] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"fansTotal"]) {//粉丝
        [_btnFans setTitle:[NSString stringWithFormat:@"%d",_userProfile.fansTotal] forState:UIControlStateNormal];
    }
}
-(void) displayUserLogin
{
    [_loginView removeFromSuperview];
    [self.view addSubview:_loginView];
    if (self.presentingViewController)
    {
        UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon" target:self action:@selector(onButtonCancel)];
        [self.navigationItem setLeftBarButtonItem:baritemCancel];
    }
    if (_userProfileView!=nil){
        [_userProfileView removeFromSuperview];
    }
    if (self.navigationItem)
    {
        [self.navigationItem setRightBarButtonItem:nil];
        self.navigationItem.title = NSLocalizedString(@"Login title", nil);
    }
    
}


- (IBAction)doLogin:(id)sender {
    _toDetail = YES;
    _weibo =[[FSModelManager sharedModelManager] instantiateWeiboClient:self];
    [_weibo logIn];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"新浪微博登录" forKey:@"登录方式"];
    [[FSAnalysis instance] logEvent:USER_LOGIN withParameters:_dic];
}

- (IBAction)doSuggest:(id)sender {
    UIActionSheet *suggestSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Publish product", nil),nil];
    suggestSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    suggestSheet.tag = Actionsheet_Publish_Tag;
    [suggestSheet showInView:_btnSuggest];
}

- (IBAction)doShowLikes:(id)sender {
    [self filterAccount:0];
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_LIKE_LIST withParameters:_dic];
}

- (IBAction)doShowFans:(id)sender {
    [self filterAccount:1];
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_FANS_LIST withParameters:_dic];
}

- (IBAction)doShowPoints:(id)sender {
    [self filterAccount:3];
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_EXCHANGE_LIST withParameters:_dic];
}

- (IBAction)doShowCoupons:(id)sender {
    [self filterAccount:2];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_GIFT_LIST withParameters:_dic];
}

- (IBAction)doLoginQQWeiBo:(id)sender {
    if (!_qq)
    {
        _qq = [[TCWBEngine alloc] initWithAppKey:QQ_WEIBO_APP_KEY andSecret:QQ_WEIBO_APP_SECRET_KEY andRedirectUrl:QQ_WEIBO_APP_REDIRECT_URI];
        _qq.rootViewController = self;
        
    }
    _toDetail = YES;
    [_qq logInWithDelegate:self onSuccess:@selector(onQQLoginSuccess) onFailure:@selector(onQQLoginFail:)];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"腾讯微博登录" forKey:@"登录方式"];
    [[FSAnalysis instance] logEvent:USER_LOGIN withParameters:_dic];
}

- (IBAction)doLoginQQ:(id)sender
{
    if (!_qqConnect) {
        _qqConnect = [FSQQConnectActivity sharedInstance];
        _qqConnect.qqDelegate = self;
    }
    [_qqConnect authorize];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"QQ登录" forKey:@"登录方式"];
    [[FSAnalysis instance] logEvent:USER_LOGIN withParameters:_dic];
}

- (IBAction)attentionXHYT:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ATTENTION_XHYT_URL]];
    
//    NSString *str = [NSString stringWithFormat:@"weixin://qr/%@",ATTENTION_XHYT_URL];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"登录页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:ATTETION_XHYT withParameters:_dic];
}

- (void) displayUserProfile {
    [_userProfileView removeFromSuperview];
    [self.view addSubview:_userProfileView];
    [self bindUserProfile];
    [self setSegHeader];
    if (_loginView!=nil)
    {
        [_loginView removeFromSuperview];
    }
    [self registerKVO];
    [self registerLocalNotification];
    [self initBarButtons];
}

-(void)initBarButtons
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(onSetting) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
    btn.titleLabel.font = ME_FONT(13);
    btn.showsTouchWhenHighlighted = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_right_normal.png"] forState:UIControlStateNormal];
    [btn sizeToFit];
    UIBarButtonItem *baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn setImage:[UIImage imageNamed:@"message.png"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(clickToMyComment:) forControlEvents:UIControlEventTouchUpInside];
    [msgBtn setShowsTouchWhenHighlighted:YES];
    [msgBtn sizeToFit];
    UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(msgBtn.frame.size.width - 26, 0, 15, 15)];
    dotView.image = [UIImage imageNamed:@"dot.png"];
    dotView.tag = 4001;
    dotView.hidden = YES;
    [msgBtn addSubview:dotView];
    UIBarButtonItem *baritemletter = [[UIBarButtonItem alloc] initWithCustomView:msgBtn];
    
    NSArray *_array = [NSArray arrayWithObjects:baritemSet,baritemletter, nil];
    [self.navigationItem setRightBarButtonItems:_array];
    
    int totalCount = [theApp newCommentCount] + [theApp newCommentCount_pletter];
    if (totalCount > 0) {
        [self showDotIcon:YES];
    }
}

-(void)clickToMyComment:(UIButton*)sender
{
    FSMyCommentController *controller = [[FSMyCommentController alloc] initWithNibName:@"FSMyCommentController" bundle:nil];
    [self.navigationController pushViewController:controller animated:true];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:USER_LETTER withParameters:_dic];
}

-(void) setSegHeader
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
    [btn1 setTitle:NSLocalizedString(@"User_Profile_Like", nil) forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn1.showsTouchWhenHighlighted = YES;
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn2 setTitle:NSLocalizedString(@"i shared", nil) forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn2.showsTouchWhenHighlighted = YES;
    
    if (_userProfile.userLevelId==FSDARENUser) {
        [_segHeader setButtonsArray:@[btn1, btn2]];
        _segHeader.selectedIndex = 1;
    }
    else {
        [_segHeader setButtonsArray:@[btn1]];
        _segHeader.selectedIndex = 0;
    }
    _isInRefreshing = NO;
    [self loadILike];
}

-(void) ensureDataContext
{
    _likePros = nil;
    _isLogined = FALSE;
    _isFirstLoad=FALSE;
    isDeletionModeActive=FALSE;
    _isInLoading=FALSE;
    _isInRefreshing=FALSE;
    _favorPageIndex=0;
    _noMoreFavor=FALSE;
    [self unregisterKVO];
    
}
-(void) bindUserProfile
{
    self.navigationItem.title = NSLocalizedString(@"Homepage title", nil);
    _btnSuggest.layer.opacity = _userProfile.userLevelId==FSDARENUser?1:0;
    UIEdgeInsets _inset = _btnSuggest.contentEdgeInsets;
    _inset.left = 20;
    _btnSuggest.contentEdgeInsets = _inset;
    [_btnSuggest setTitle:@"发布" forState:UIControlStateNormal];
    
    _lblNickie.text = _userProfile.nickie;
    [_lblNickie sizeToFit];
    CGRect origFrame = _imgLevel.frame;
    origFrame.origin.x = _lblNickie.frame.origin.x+_lblNickie.frame.size.width+4;
    origFrame.origin.y = (_lblNickie.frame.size.height - origFrame.size.height)/2 + _lblNickie.frame.origin.y;
    _imgLevel.frame = origFrame;
    if (_userProfile.userLevelId!=FSDARENUser)
        [_imgLevel removeFromSuperview];
    _thumbImg.ownerUser = _userProfile;
    _thumbImg.showCamera = true;
    _thumbImg.delegate = self;
    
    [_btnHeaderBg addTarget:self action:@selector(handleChangeHeaderBg:) forControlEvents:UIControlEventTouchUpInside];
    origFrame = _btnHeaderBg.frame;
    [_btnHeaderBg setTitle:@"" forState:UIControlStateNormal];
    origFrame.origin.y = _segHeader.frame.origin.y - origFrame.size.height;
    _btnHeaderBg.frame = origFrame;
    _btnHeaderImgV.frame = origFrame;
    [_btnHeaderImgV setImageWithURL:_userProfile.logobgURL placeholderImage:[UIImage imageNamed:@"图形1bb.png"]];
    
    origFrame = _tbScroll.frame;
    origFrame.size.height = APP_HIGH - NAV_HIGH - TAB_HIGH;
    _tbScroll.frame = origFrame;
    
    _btnLike.titleLabel.font = ME_FONT(10);
    _btnLike.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnLike setTitle:[NSString stringWithFormat:@"%d",_userProfile.likeTotal] forState:UIControlStateNormal];
    
    _btnFans.titleLabel.font = ME_FONT(10);
    _btnFans.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnFans setTitle:[NSString stringWithFormat:@"%d",_userProfile.fansTotal] forState:UIControlStateNormal];
    _btnCoupons.titleLabel.font = ME_FONT(10);
    _btnCoupons.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnCoupons setTitle:[NSString stringWithFormat:@"%d",_userProfile.couponsTotal] forState:UIControlStateNormal];
    
    _segHeader.selectedIndex = 0;
    
    SpringboardLayout *layout = [[SpringboardLayout alloc] init];
    layout.itemWidth = ITEM_CELL_WIDTH;
    layout.columnCount = I_LIKE_COLUMNS;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.delegate = self;
    CGRect rect = _likeContainer.frame;
    rect.size.height = APP_HIGH - TAB_HIGH - _segHeader.frame.origin.y - _segHeader.frame.size.height;
    _likeContainer.frame = rect;
    _likeView = [[PSUICollectionView alloc] initWithFrame:_likeContainer.bounds collectionViewLayout:layout];
    _likeView.backgroundColor = [UIColor whiteColor];
    [_likeContainer addSubview:_likeView];
    
    [_likeView registerClass:[FSFavorProCell class] forCellWithReuseIdentifier:@"FSFavorProCell"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
    longPress.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endDeletionMode:)];
    tap.delegate = self;
    [_likeView addGestureRecognizer:longPress];
    [_likeView addGestureRecognizer:tap];
    
    [self prepareRefreshLayout:_likeView withRefreshAction:^(dispatch_block_t action) {
        _isInRefreshing = YES;
        [self loadILike:NO nextPage:1 withCallback:^{
            _isInRefreshing = NO;
            action();
        }];
    }];
    
    _likeView.delegate = self;
    _likeView.dataSource = self;
}

-(void)handleChangeHeaderBg:(UIButton*)sender
{
    _takePhotoSource = 2;
    UIActionSheet *suggestSheet = [[UIActionSheet alloc] initWithTitle:@"修改Me的主页背景" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从图片库中选择",nil];
    suggestSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    suggestSheet.tag = Actionsheet_Takephoto_Tag;
    [suggestSheet showInView:_btnSuggest];
}

-(void) loadILike
{
    if (_isInLoading) {
        return;
    }
    _favorPageIndex = 1;
    _isInLoading = YES;
    _isInRefreshing = YES;
    [self loadILike:YES nextPage:_favorPageIndex  withCallback:^{
        _isInLoading = NO;
        _isInRefreshing = NO;
        [_likeView setContentOffset:CGPointMake(0, 0) animated:NO];
    }];
}

-(void) loadILike:(BOOL)showProgress nextPage:(int)pageIndex withCallback:(dispatch_block_t)callback
{
    if (showProgress) {
        [self beginLoading:_tbScroll];
        _likeView.scrollEnabled = NO;
    }
    _favorPageIndex = pageIndex;
    FSEntityRequestBase *request = [self createRequest:pageIndex];
    NSString *blockKey = _segHeader.selectedIndex==0?LOGIN_GET_USER_LIKE:LOGIN_GET_USER_SHARE;
    ((DataSourceProviderRequest2Block)[_dataSourceProvider objectForKey:blockKey])(request,^{
        if (showProgress) {
            [self endLoading:_tbScroll];
            _likeView.scrollEnabled = YES;
        }
        if (callback)
            callback();
    });
    
}

-(FSEntityRequestBase *)createRequest:(int)page
{
    if (_userProfile.userLevelId == FSDARENUser && _segHeader.selectedIndex == 1)
    {
        FSCommonUserRequest *request = [[FSCommonUserRequest alloc] init];
        request.userToken = _userProfile.uToken;
        request.routeResourcePath = RK_REQUEST_PRO_BOTH_LIST;
        request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE] ;
        request.pageIndex =[NSNumber numberWithInt:page];
        return request;
        
    } else
    {
        FSFavorRequest *request = [[FSFavorRequest alloc] init];
        request.userToken = _userProfile.uToken;
        request.productType = FSSourceAll;
        request.routeResourcePath = RK_REQUEST_FAVOR_LIST;
        request.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        request.pageSize = [NSNumber numberWithInt:COMMON_PAGE_SIZE] ;
        request.nextPage =[NSNumber numberWithInt:page];
        return request;
    }
}

-(void)loadMore
{
    [self beginLoadMoreLayout:_tbScroll];
    __block FSMeViewController *blockSelf = self;
    _isInRefreshing = NO;
    _isInLoading = YES;
    [self loadILike:FALSE nextPage:++_favorPageIndex withCallback:^{
        [blockSelf endLoadMore:blockSelf->_tbScroll];
        _isInLoading = NO;
        
        //统计
        NSString *value = _segHeader.selectedIndex==0?@"Me的主页-我喜欢":@"Me的主页-我分享";
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:value forKey:@"来源"];
        [_dic setValue:[NSString stringWithFormat:@"%d", _favorPageIndex] forKey:@"页码"];
        [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
    }];
}

-(void)fillFavorList:(NSArray *)list isInsert:(BOOL)isInsert
{
    if (!_likePros)
    {
        _likePros = [@[] mutableCopy];
    }
    if (isInsert)
        [_likePros removeAllObjects];
    if (list)
    {
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likePros indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSFavor *)obj1 valueForKey:@"id"] isEqualToValue:[(FSFavor *)obj valueForKey:@"id"]])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index== NSNotFound)
            {
                [_likePros addObject:obj];
                if (!isInsert && !IOS7)
                {
                    [_likeView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_likePros.count-1 inSection:0]]];
                }
                //[_likeView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_likePros.count-1 inSection:0]]];
            }
        }];
        if ((isInsert && !IOS7) || IOS7){
            [_likeView reloadData];
            [self resetScrollViewSize];
        }
//        [_likeView reloadData];
//        [self resetScrollViewSize];
        
        if (_likePros.count<1)
        {
            //加载空视图
            [self showNoResultImage:_likeView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_Me_Liked_List", nil)  originOffset:30];
        }
        else
        {
            [self hideNoResultImage:_likeView];
        }
    }
}
-(void)fillItemslist:(NSArray *)list isInsert:(BOOL)isInsert
{
    if (!_likePros)
    {
        _likePros = [@[] mutableCopy];
    }
    if (isInsert)
        [_likePros removeAllObjects];
    if (list)
    {
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likePros indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([(FSItemBase *)obj1 sourceId] ==[(FSItemBase *)obj sourceId] &&
                    [(FSItemBase *)obj1 sourceType]==[(FSItemBase *)obj sourceType])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index== NSNotFound)
            {
                [_likePros addObject:obj];
                if (!isInsert && !IOS7)
                {
                    [_likeView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_likePros.count-1 inSection:0]]];
                }
                //[_likeView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_likePros.count-1 inSection:0]]];
            }
        }];
        if ((isInsert && !IOS7) || IOS7) {
            [_likeView reloadData];
            [self resetScrollViewSize];
        }
//        [_likeView reloadData];
//        [self resetScrollViewSize];
        
        if (_likePros.count<1)
        {
            //加载空视图
            [self showNoResultImage:_likeView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_Me_Shared_List", nil)  originOffset:30];
        }
        else
        {
            [self hideNoResultImage:_likeView];
        }
    }
}

-(void)filterAccount:(int)index
{
    switch (index) {
        case 0:
        {
            FSLikeViewController *likeView = [[FSLikeViewController alloc] initWithNibName:@"FSLikeViewController" bundle:nil];
            likeView.likeType = 0;
            likeView.navigationItem.title = NSLocalizedString(@"Me likes persons", nil);
            [self.navigationController pushViewController:likeView animated:TRUE];
            break;
        }
        case 1:
        {
            FSLikeViewController *likeView = [[FSLikeViewController alloc] initWithNibName:@"FSLikeViewController" bundle:nil];
            likeView.likeType = 1;
            likeView.navigationItem.title = NSLocalizedString(@"Me fans", nil);
            [self.navigationController pushViewController:likeView animated:TRUE];
            break;
        }
        case 2:
        {
            FSGiftListViewController *couponView = [[FSGiftListViewController alloc] initWithNibName:@"FSGiftListViewController" bundle:nil];
            couponView.currentUser = _userProfile;
            [self.navigationController pushViewController:couponView animated:true];
            break;
        }
        case 3:
        {
            FSPointViewController *pointView = [[FSPointViewController alloc] initWithNibName:@"FSPointViewController" bundle:nil];
            pointView.currentUser = _userProfile;
            [self.navigationController pushViewController:pointView animated:TRUE];
            break;
        }
            
        default:
            break;
    }
    
}

-(void) bindContentView
{
    [_likeView reloadData];
}

-(void)onButtonCancel
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)onSetting
{
    FSMoreViewController *controller = [[FSMoreViewController alloc] initWithNibName:@"FSMoreViewController" bundle:nil];
    controller.delegate = self;
    controller.currentUser = _userProfile;
    [self.navigationController pushViewController:controller animated:true];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"Me的主页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:USER_MORE withParameters:_dic];
}

-(void)uploadThumnail:(UIImage *)image
{
    if (_takePhotoSource == 1) {
        [self startProgress:NSLocalizedString(@"upload thumnail now", nil) withExeBlock:^(dispatch_block_t callback){
            [self internalUploadThumnail:image CallBack:callback];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"Me的主页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:USER_THUMB_IMAGE_UPLOAD withParameters:_dic];
        } completeCallbck:^{
            [self endProgress];
        }];
    }
    else{
        [self startProgress:NSLocalizedString(@"upload me background now", nil) withExeBlock:^(dispatch_block_t callback){
            [self internalUploadThumnail:image CallBack:callback];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"Me的主页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:USER_BACKGROUND_IMAGE_UPLOAD withParameters:_dic];
        } completeCallbck:^{
            [self endProgress];
        }];
    }
}

-(void)internalUploadThumnail:(UIImage *)image CallBack:(dispatch_block_t)callback
{
    FSThumnailRequest *request = [[FSThumnailRequest alloc] init];
    request.uToken = _userProfile.uToken;
    request.image = image;
    request.type = 1;
    if (_takePhotoSource == 2) {
        request.type = 2;
    }
    request.routeResourcePath = RK_REQUEST_THUMNAIL_UPLOAD;
    [request upload:^(id result){
        callback();
        _userProfile.thumnail = result;
        if (_takePhotoSource == 1) {
            [_thumbImg reloadThumb:_userProfile.thumnailUrl];
        }
        else{
            _btnHeaderImgV.image = image;
        }
        
    } error:^(id error){
        callback();
        [self updateProgress:error];
    }];
}

#pragma UIImagePicker delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.image"])
	{
		UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [NSThread detachNewThreadSelector:@selector(cropImage:) toTarget:self withObject:image];
    }
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

- (void)cropImage:(UIImage *)image {
    int whSize = 0;
    if (_takePhotoSource == 1) {
        whSize = 200;
    }
    else{
        whSize = 320;
    }
    CGSize newSize = CGSizeMake(whSize, whSize*image.size.height/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    [self uploadThumnail:newImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIImagePickerController *)inUserCamera
{
    return _camera;
}

#pragma mark - KVO & Notification

-(void)registerLocalNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCustomerChanged:) name:LN_USER_UPDATED object:nil];
    if (_userProfile.userLevelId==FSDARENUser)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didItemPublished:) name:LN_ITEM_UPDATED object:nil];
    } else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFavorRemoved:) name:LN_FAVOR_UPDATED object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:@"ReceivePushNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:@"ReceivePushNotification_pletter" object:nil];
}

-(void)unregisterLocalNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receivePushNotification:(NSNotification*)notification
{
    int totalCount = [theApp newCommentCount] + [theApp newCommentCount_pletter];
    if (totalCount > 0) {
        [self showDotIcon:YES];
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", totalCount];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalCount];
    }
    else{
        self.navigationController.tabBarItem.badgeValue = nil;
        [self showDotIcon:NO];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}

-(void)showDotIcon:(BOOL)flag
{
    NSArray *array = self.navigationItem.rightBarButtonItems;
    if (array.count > 0) {
        UIBarButtonItem *item = array[0];
        UIView *view = [item.customView viewWithTag:4001];
        if (view) {
            view.hidden = !flag;
            [item.customView bringSubviewToFront:view];
        }
        else{
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width - 26, 0, 15, 15)];
            dotView.image = [UIImage imageNamed:@"dot.png"];
            dotView.tag = 4001;
            dotView.hidden = !flag;
            [item.customView addSubview:dotView];
            [item.customView bringSubviewToFront:dotView];
        }
    }
}

-(void)registerKVO
{
    [_userProfile addObserver:self forKeyPath:@"nickie" options:NSKeyValueObservingOptionNew context:NULL];
    [_userProfile addObserver:self forKeyPath:@"pointsTotal" options:NSKeyValueObservingOptionNew context:NULL];
    [_userProfile addObserver:self forKeyPath:@"couponsTotal" options:NSKeyValueObservingOptionNew context:NULL];
    [_userProfile addObserver:self forKeyPath:@"likeTotal" options:NSKeyValueObservingOptionNew context:NULL];
    [_userProfile addObserver:self forKeyPath:@"fansTotal" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)unregisterKVO
{
    [_userProfile removeObserver:self forKeyPath:@"nickie"];
    [_userProfile removeObserver:self forKeyPath:@"pointsTotal"];
    [_userProfile removeObserver:self forKeyPath:@"couponsTotal"];
    [_userProfile removeObserver:self forKeyPath:@"likeTotal"];
    [_userProfile removeObserver:self forKeyPath:@"fansTotal"];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == Actionsheet_Publish_Tag) {
        switch (buttonIndex) {
            case 0:
            {
                _toDetail = YES;
                FSProPostMainViewController *uploadController = [[FSProPostMainViewController alloc] initWithNibName:@"FSProPostMainViewController" bundle:nil];
                uploadController.currentUser = _userProfile;
                /*
                [uploadController setAvailableFields:ImageField|TitleField|BrandField|TagField|StoreField|SaleField];
                [uploadController setMustFields:ImageField|TitleField|BrandField|TagField|StoreField|SaleField];
                 */
                [uploadController setAvailableFields:ImageField|TitleField|BrandField|TagField|StoreField];
                [uploadController setMustFields:ImageField|TitleField|BrandField|TagField|StoreField];
                [uploadController setRoute:RK_REQUEST_PROD_UPLOAD];
                uploadController.publishSource = FSSourceProduct;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:uploadController];
                uploadController.navigationItem.title = NSLocalizedString(@"Publish product", nil);
                [self presentViewController:navController animated:TRUE completion:nil];
                
                //统计
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [_dic setValue:@"Me的主页" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:USER_PUBLISH withParameters:_dic];
                
                [[FSAnalysis instance] autoTrackPages:navController];
                
                break;
            }
            default:
                break;
        }
    }
    else if (actionSheet.tag == Actionsheet_Delete_Tag && buttonIndex == 0) {
        MyActionSheet *sheet = (MyActionSheet*)actionSheet;
        UIButton *sender = (UIButton*)sheet.object;
        FSFavorProCell * cell = (FSFavorProCell *)sender.superview.superview;
        if (cell)
        {
            FSEntityRequestBase *request = nil;
            if (_userProfile.userLevelId == FSDARENUser && _segHeader.selectedIndex == 1) {
                FSCommonProRequest * removeRequest = [[FSCommonProRequest alloc] init];
                removeRequest.uToken = _userProfile.uToken;
                removeRequest.id = [NSNumber numberWithInt:[(FSItemBase *)[(FSFavorProCell *)cell data] sourceId]];
                
                removeRequest.pType = [(FSItemBase *)[(FSFavorProCell *)cell data] sourceType];
                removeRequest.routeResourcePath = removeRequest.pType==FSSourceProduct?RK_REQUEST_PROD_REMOVE:RK_REQUEST_PRO_REMOVE;
                request = removeRequest;
                
            } else
            {
                FSFavorRequest * removeRequest = [[FSFavorRequest alloc] init];
                removeRequest.userToken = _userProfile.uToken;
                removeRequest.id = [NSNumber numberWithInt:[(FSFavor *)[(FSFavorProCell *)cell data] id]];
                removeRequest.routeResourcePath = RK_REQUEST_FAVOR_REMOVE;
                request = removeRequest;
            }
            [self beginLoading:_tbScroll];
            [request send:[FSModelBase class] withRequest:request completeCallBack:^(FSEntityBase * resp){
                [self endLoading:_tbScroll];
                if (!resp.isSuccess)
                {
                    [self reportError:NSLocalizedString(@"COMM_OPERATE_FAILED", nil)];
                }
                else
                {
                    FSProdItemEntity *item = [(FSFavorProCell *)cell data];
                    [_likePros removeObject:item];
//                    if (!IOS7) {
//                        [_likeView deleteItemsAtIndexPaths:@[[_likeView indexPathForCell:cell]]];
//                    }
                    [_likeView deleteItemsAtIndexPaths:@[[_likeView indexPathForCell:cell]]];
                    [_likeView reloadData];
                    if (_likePros.count<1)
                    {
                        //加载空视图
                        if (_segHeader.selectedIndex == 0) {
                            [self showNoResultImage:_likeView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_Me_Liked_List", nil)  originOffset:30];
                        }
                        else{
                            [self showNoResultImage:_likeView withImage:@"blank_bag.png" withText:NSLocalizedString(@"TipInfo_Me_Shared_List", nil)  originOffset:30];
                        }
                    }
                    else
                    {
                        [self hideNoResultImage:_likeView];
                    }
                    
                    if (_segHeader.selectedIndex == 0) {
                        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
                        [_dic setValue:@"Me的主页" forKey:@"来源页面"];
                        [_dic setValue:@"取消喜欢" forKey:@"操作类型"];
                        [[FSAnalysis instance] logEvent:COMMON_LIKE_UNLIKE withParameters:_dic];
                    }
                    else{
                        [[FSAnalysis instance] logEvent:COMMON_SHARE_DEL withParameters:nil];
                    }
                }
            }];
            
        }
    }
    else if(actionSheet.tag == Actionsheet_Takephoto_Tag) {
        switch (buttonIndex) {
            case 0:
            {
                //照片拍摄
                _camera = [[UIImagePickerController alloc] init];
                _camera.delegate = self;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    _toDetail = YES;
                    _camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                    _camera.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
                    _camera.allowsEditing = YES;
                    [self presentViewController:_camera animated:YES completion:nil];
                    
                } else
                {
                    [self reportError:NSLocalizedString(@"Can Not Camera", nil)];
                }
                break;
            }
            case 1:
            {
                //从照片库选取
                _camera = [[UIImagePickerController alloc] init];
                _camera.delegate = self;
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
                {
                    _toDetail = YES;
                    _camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    _camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    _camera.allowsEditing = YES;
                    [self presentViewController:_camera animated:YES completion:nil];
                    
                }
                else
                {
                    [self reportError:NSLocalizedString(@"Can Not Camera", nil)];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - FSQQConnectActivityDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin:(FSQQConnectActivity*)view
{
    if (_qqConnect.tencentOAuth.accessToken
        && 0 != [_qqConnect.tencentOAuth.accessToken length])
    {
        [_qqConnect.tencentOAuth getUserInfo];
    }
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(FSQQConnectActivity*)view response:(APIResponse*) response
{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
        FSUserLoginRequest *request = [[FSUserLoginRequest alloc] init];
        request.nickie = [response.jsonResponse objectForKey:@"nickname"];
        request.accessToken = _qqConnect.tencentOAuth.accessToken;
        request.thirdPartySourceType = @3;
        request.thirdPartyUid = _qqConnect.tencentOAuth.openId;
        request.thumnail = [response.jsonResponse objectForKey:@"figureurl_qq_2"];
        ((DataSourceProviderRequestBlock)[_dataSourceProvider objectForKey:LOGIN_FROM_3RDPARTY_ACTION])(request);
    }
}

-(void) resetScrollViewSize
{
    return;
    
    [UIView animateWithDuration:2.3 animations:nil completion:^(BOOL finished) {
        CGRect _rect = _likeContainer.frame;
        _rect.size.height = _likeView.contentSize.height;
        _likeContainer.frame = _rect;
        int height = _likeContainer.frame.origin.y + _likeView.contentSize.height;
        _likeView.frame = _likeContainer.bounds;
        _tbScroll.contentSize = CGSizeMake(320, MAX(height, _tbScroll.frame.size.height));
        NSLog(@"_likeView frame:%@", NSStringFromCGRect(_likeView.frame));
        NSLog(@"_tbScroll frame:%@", NSStringFromCGRect(_tbScroll.frame));
        NSLog(@"_likeView contentSize:%@", NSStringFromCGSize(_likeView.contentSize));
        NSLog(@"_tbScroll contentSize:%@", NSStringFromCGSize(_tbScroll.contentSize));
        [_likeView reloadData];
    }];
}

#pragma mark - PSUICollectionView Datasource

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _likePros?_likePros.count:0;
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row * [self numberOfSectionsInCollectionView:cv]+indexPath.section;
    int totalCount = _likePros.count;
    if (index>=totalCount)
        return nil;
    PSUICollectionViewCell *cell = nil;
    id item = [_likePros objectAtIndex:index];
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"FSFavorProCell" forIndexPath:indexPath];
    [[(FSFavorProCell *)cell deleteButton] addTarget:self action:@selector(didRemoveClick:) forControlEvents:UIControlEventTouchUpInside];
    ((FSFavorProCell *)cell).data = item;
    if (_segHeader.selectedIndex == 0) {
        if ([item isKindOfClass:[FSFavor class]]) {
            FSFavor *_fav = (FSFavor*)item;
            if (_fav.hasPromotion && _fav.sourceType == FSSourceProduct) {
                [(FSFavorProCell *)cell showProIcon];
            }
            else {
                [(FSFavorProCell *)cell hidenProIcon];
            }
        }
    }
    else if(_segHeader.selectedIndex == 1){
        if ([item isKindOfClass:[FSItemBase class]]) {
            FSItemBase *_fav = (FSItemBase*)item;
            if (_fav.hasPromotion && _fav.sourceType == FSSourceProduct) {
                [(FSFavorProCell *)cell showProIcon];
            }
            else {
                [(FSFavorProCell *)cell hidenProIcon];
            }
        }
    }
//    cell.layer.borderWidth = 0.5;
//    cell.layer.borderColor = [UIColor colorWithRed:151 green:151 blue:151].CGColor;
//    if (_likeView.dragging == NO && _likeView.decelerating == NO)
    {
        int width = ITEM_CELL_WIDTH;
        int height = cell.frame.size.height;
        [(id<ImageContainerDownloadDelegate>)cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
    }
    
    return cell;
}

#pragma mark - PSUICollectionViewDelegate
- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isDeletionModeActive)
    {
        [self endDeletionMode:nil];
        return;
    }
    FSProDetailViewController *detailView = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
    int index = indexPath.row* [self numberOfSectionsInCollectionView:collectionView] + indexPath.section;
    detailView.navContext = [_likePros copy];
    detailView.indexInContext = index;
    detailView.sourceFrom = 2;
    detailView.sourceType = [[[_likePros objectAtIndex:detailView.indexInContext] valueForKey:@"sourceType"] intValue];
    detailView.dataProviderInContext = self;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailView];
    _toDetail = YES;
    [self presentViewController:navControl animated:true completion:nil];
    
    //统计
    if (detailView.sourceType == FSSourceProduct) {
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic setValue:@"Me的主页" forKey:@"来源页面"];
        [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
    }
    else if(detailView.sourceType == FSSourcePromotion) {
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic setValue:@"Me的主页" forKey:@"来源页面"];
        [[FSAnalysis instance] logEvent:CHECK_PROLIST_DETAIL withParameters:_dic];
    }
    
    [[FSAnalysis instance] autoTrackPages:navControl];
}

-(void)collectionView:(PSUICollectionView *)collectionView didEndDisplayingCell:(PSUICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSFavorProCell *hideCell = (FSFavorProCell *)cell;
    [hideCell willRemoveFromView];
}

-(void)didRemoveClick:(UIButton *)sender
{
    MyActionSheet *sheet = [[MyActionSheet alloc] initWithTitle:NSLocalizedString(@"Delete prompt",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:NSLocalizedString(@"Delete",nil) otherButtonTitles:nil, nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    sheet.tag = Actionsheet_Delete_Tag;
    sheet.object = sender;
    [sheet showInView:sender];
}

- (void)loadImagesForOnscreenRows
{
    if ([_likePros count] > 0)
    {
        NSArray *visiblePaths = [_likeView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            id<ImageContainerDownloadDelegate> cell = (id<ImageContainerDownloadDelegate>)[_likeView cellForItemAtIndexPath:indexPath];
            int width = ITEM_CELL_WIDTH;
            int height = [(PSUICollectionViewCell *)cell frame].size.height - 40;
            [cell imageContainerStartDownload:cell withObject:indexPath andCropSize:CGSizeMake(width, height) ];
            
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
    if (!_noMoreFavor &&
        !_isInLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 150 > scrollView.contentSize.height
        && scrollView.contentSize.height>scrollView.frame.size.height
        &&scrollView.contentOffset.y>0)
    {
        _isInLoading = YES;
        [self loadMore];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - gesture-recognition action methods


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    CGPoint touchPoint = [touch locationInView:_likeView];
    NSIndexPath *indexPath = [_likeView indexPathForItemAtPoint:touchPoint];
    if (indexPath && ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class] ]))
    {
        return NO;
    }
     
    return YES;
}


- (void)activateDeletionMode:(UILongPressGestureRecognizer *)gr
{
//    if (_segHeader.selectedIndex == 0) {
//        return;
//    }
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [_likeView indexPathForItemAtPoint:[gr locationInView:_likeView]];
        if (indexPath)
        {
            isDeletionModeActive = YES;
            if ([NSLayoutConstraint class]) //use this trick to check ios6+
            {
                //[_likeView reloadData];
                SpringboardLayout *layout = (SpringboardLayout *)_likeView.collectionViewLayout;
                [layout invalidateLayout];
            } else
            {
                [_likeView reloadData];
            }
        }
    }
}

- (void)endDeletionMode:(UITapGestureRecognizer *)gr
{
    if (isDeletionModeActive)
    {
        NSIndexPath *indexPath = [_likeView indexPathForItemAtPoint:[gr locationInView:_likeView]];
        if (!indexPath)
        {
            isDeletionModeActive = NO;
            if ([NSLayoutConstraint class]) //use this trick to check ios6+
            {
                
                SpringboardLayout *layout = (SpringboardLayout *)_likeView.collectionViewLayout;
                [layout invalidateLayout];
            } else
            {
                [_likeView reloadData];
            }
        }
    }
    
}

#pragma mark - spring board layout delegate

- (BOOL) isDeletionModeActiveForCollectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout
{
    return isDeletionModeActive;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(SpringboardLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [_likePros objectAtIndex:indexPath.row];
    FSResource * resource = [data resources]&&[data resources].count>0?[[data resources] objectAtIndex:0]:nil;
    float totalHeight = 40.0f;
    if (resource &&
        resource.width>0 &&
        resource.height>0)
    {
        int cellWidth = ITEM_CELL_WIDTH;
        float imgHeight = (cellWidth * resource.height)/(resource.width);
        totalHeight = imgHeight;
    }
    else {
        totalHeight = CollectionView_Default_Height;
    }
    return totalHeight;
}


#pragma FSProDetailItemSourceProvider
-(void)proDetailViewDataFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index completeCallback:(UICallBackWith1Param)block errorCallback:(dispatch_block_t)errorBlock
{
    FSCommonProRequest *drequest = [[FSCommonProRequest alloc] init];
    drequest.uToken = [FSModelManager sharedModelManager].loginToken;
    drequest.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
    drequest.lantit = [NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    Class respClass;
    if (_userProfile.userLevelId == FSDARENUser) {
        FSItemBase *itemCurrent = [view.navContext objectAtIndex:index];
        if (itemCurrent.sourceType == FSSourceProduct)
        {
            drequest.pType = FSSourceProduct;
            drequest.routeResourcePath = [NSString stringWithFormat:@"/product/%@",[NSNumber numberWithInt:itemCurrent.sourceId]];
            respClass = [FSProdItemEntity class];
        }
        else
        {
            drequest.pType = FSSourcePromotion;
            drequest.routeResourcePath = [NSString stringWithFormat:@"/promotion/%@",[NSNumber numberWithInt:itemCurrent.sourceId]];
            respClass = [FSProItemEntity class];
        }
    }
    else{
        FSFavor * favorCurrent = [view.navContext objectAtIndex:index];
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
    FSFavor * favorCurrent = [view.navContext objectAtIndex:index];
    return favorCurrent.sourceType;
}
-(BOOL)proDetailViewShouldPostNotification:(FSProDetailViewController *)view
{
    return YES;
}

#pragma mark - FSThumbView Delegate

-(void)didTapThumView:(id)sender
{
    _takePhotoSource = 1;
    UIActionSheet *suggestSheet = [[UIActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从图片库中选择",nil];
    suggestSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    suggestSheet.tag = Actionsheet_Takephoto_Tag;
    [suggestSheet showInView:_btnSuggest];
}

#pragma mark - QQ weibo delegate

-(void) onQQLoginSuccess
{
    [self beginLoading:self.view];
    [_qq getUserInfoWithFormat:@"json" parReserved:nil delegate:self onSuccess:@selector(onQQUserInfoGet:) onFailure:@selector(onQQUserInfoFail:)];
    
}

-(void) onQQLoginFail:(NSError *)error
{
    if (error)
        [self reportError:NSLocalizedString(@"login failed", nil)];
}


- (void)onQQUserInfoGet:(id)result{
    [self endLoading:self.view];
    NSDictionary *homeDic = (NSDictionary *)result;
    FSUserLoginRequest *request = [[FSUserLoginRequest alloc] init];
    request.accessToken = _qq.accessToken;
    request.thirdPartySourceType = @2;
    request.thirdPartyUid = [homeDic valueForKeyPath:@"data.openid"];
    request.nickie = [homeDic valueForKeyPath:@"data.nick"];
    request.thumnail = [homeDic valueForKey:@"data.head"];
    ((DataSourceProviderRequestBlock)[_dataSourceProvider objectForKey:LOGIN_FROM_3RDPARTY_ACTION])(request);
}

- (void)onQQUserInfoFail:(NSError *)error{
    [self endLoading:self.view];
   [self reportError:error.description];
}



#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    _weibo = sinaweibo;
    [[FSModelManager sharedModelManager] storeWeiboAuth:sinaweibo];
    
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

- (void)removeAuthData
{
    [[FSModelManager sharedModelManager] removeWeiboAuthCache];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        _userProfile = nil;
    }
    [self reportError:NSLocalizedString(@"login failed", nil)];
    [self removeAuthData];
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        
        //step2: create account in app by weibo user profile
        NSMutableDictionary * weiboUserProfile = [result mutableCopy];
        //step3: use the account info from new created account
        
        FSUserLoginRequest *request = [[FSUserLoginRequest alloc] init];
        request.nickie = [weiboUserProfile objectForKey:@"screen_name"];
        request.accessToken = _weibo.accessToken;
        request.thirdPartySourceType = @1;
        request.thirdPartyUid = _weibo.userID;
        request.thumnail = [weiboUserProfile objectForKey:@"profile_image_url"];
        ((DataSourceProviderRequestBlock)[_dataSourceProvider objectForKey:LOGIN_FROM_3RDPARTY_ACTION])(request);
    }
}

#pragma mark - FSSettingViewCompleteDelegate

-(void)settingView:(FSMoreViewController *)view didLogOut:(BOOL)flag
{
    if (flag)
    {
        [self removeAuthData];
        [self ensureDataContext];
        [self displayUserLogin];
    }
}

#pragma mark -
#pragma mark AKSegmentedControlDelegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl == _segHeader){
        [self loadILike];
        
        //统计
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:(segmentedControl.selectedIndex == 0?@"我喜欢":@"我分享") forKey:@"分类名称"];
        [_dic setValue:@"Me的主页" forKey:@"页面来源"];
        [[FSAnalysis instance] logEvent:USER_ME_PRODUCT_TAB withParameters:_dic];
    }
}

@end
