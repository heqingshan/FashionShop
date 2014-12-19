//
//  FSAppDelegate.m
//  FashionShop
//
//  Created by gong yi on 11/2/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//
//#define ENVIRONMENT_DEVELOPMENT 1
#import "FSAppDelegate.h"
#import "FSModelManager.h"
#import "FSLocationManager.h"
#import "WXApi.h"
#import "FSWeixinActivity.h"
#import "FSUser.h"
#import "FSDeviceRegisterRequest.h"
#import "FSAnalysis.h"
#import "SplashViewController.h"
#import "FSStoreMapViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "FSAudioHelper.h"
#import "FSMyCommentController.h"
#import "FSProDetailViewController.h"
#import "NSString+SBJSON.h"
#import "FSContentViewController.h"
#import "FSMeViewController.h"
#import "FSMyPickerView.h"

#import "PKRevealController.h"
#import "LeftDemoViewController.h"
#import "NSString+Extention.h"
#import "FSPLetterViewController.h"
#import "FSMessageViewController.h"

//UMTrack
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//支付宝
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import "DataSigner.h"
#import "AlixPayOrder.h"
#import "FSPartnerConfig.h"
#import "AlixLibService.h"

#import "FSCoreMyLetter.h"

@interface FSAppDelegate(){
    NSString *localToken;
    NSDictionary   *pushInfoDic;   //保存推送过来的消息对象
}

@end

void uncaughtExceptionHandler(NSException *exception)
{
    [[FSAnalysis instance] logError:exception fromWhere:@"unhandle"];
}

@implementation FSAppDelegate
@synthesize allBrands,allStores,allTags,allAddress;

@synthesize modelManager,locationManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //SETUP RKModel Manager
    modelManager = [FSModelManager sharedModelManager];

    //setup LOCATION MANAGER
    locationManager = [FSLocationManager sharedLocationManager];
    //SETUP REMOTE NOTIFICATION
    [self registerPushNotification];
    
    //setup exception handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#if 1//defined ENVIRONMENT_STORE
    //setup analysis
    [self setupAnalys];
#endif
    
    //添加UmengTrack
    [self initUMTrack];
    
    FSAudioHelper *help = [[FSAudioHelper alloc] init];
    [help initSession];
    
    [self setGlobalLayout];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //加载启动图
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _startController = [[FSStartViewController alloc] init];
    _startController.view.alpha = 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        _startController.view.alpha = 1.0f;
        [self.window addSubview:_startController.view];
        [self.window makeKeyAndVisible];
    } completion:^(BOOL finished) {}];
    _launch = launchOptions;
    //三秒钟后关闭
    [self performSelector:@selector(loadMainView) withObject:nil afterDelay:3];

    return YES;
}

-(void)loadMainView {
    [UIView animateWithDuration:0.3 animations:^{
        _startController.view.alpha = 0.8f;
    } completion:^(BOOL finished) {
        //删除_startController
        [_startController.view removeFromSuperview];
        
        //先判断是否是第一次使用(V2.5.1版本去除引导图)
        NSString *content = @"hasLaunched";//[self readFromFile:@"hasLaunched"];
        if (!content || ![content isEqualToString:@"hasLaunched"]) {
            SplashViewController *SVCtrl = [[SplashViewController alloc] init];
            SVCtrl.view.alpha = 1.0f;
            self.window.backgroundColor = [UIColor whiteColor];
            self.window.rootViewController =  SVCtrl;
            [self.window makeKeyAndVisible];
        } else {
            [self entryMain];
        }
    }];
}

-(void)entryMain
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *root = [storyBoard instantiateInitialViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = root;
    [[FSAnalysis instance] autoTrackPages:root];
    [self.window makeKeyAndVisible];
    
    //添加背景色
    NSArray *array = [root.view subviews];
    UITabBar *_tabbar = [array objectAtIndex:1];
    UIImageView *_vImage = [[UIImageView alloc] init];
    _vImage.image = [UIImage imageNamed:@"Toolbar_bg.png"];
    _vImage.frame = CGRectMake(0, 0, 320, TAB_HIGH);
    [_tabbar insertSubview:_vImage atIndex:1];
    for (int i = 0; i < _tabbar.items.count; i++) {
        UITabBarItem *item = _tabbar.items[i];
//        if (IOS7) {
//            UIImage *img = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d.png", i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            UIImage *img_sel = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d_sel.png", i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            item = [item initWithTitle:[[NSArray arrayWithObjects:@"促销",@"专题",@"东东",@"我", nil] objectAtIndex:i] image:img selectedImage:img_sel];
//        }
//        else
        {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d.png", i + 1]];
            UIImage *img_sel = [UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d_sel.png", i + 1]];
            [item setFinishedSelectedImage:img_sel withFinishedUnselectedImage:img];
        }
        
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        [item setImageInsets:UIEdgeInsetsMake(4, 0, -4, 0)];
    }
    
    //地下的这点代码应该是判断如果是完全推出状态下，push进来做的操作，如果是完全退出状态下的话，这样会在home里面进行插入操作。
    NSDictionary *userInfo = [_launch objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (userInfo) {
        pushInfoDic = userInfo;
        [self pushTo];
    }
    
    //set User id
    FSUser *user = [FSUser localProfile];
    if (user && user.uid) {
        [[FSAnalysis instance] setUserID:[NSString stringWithFormat:@"%@", user.uid]];
    }
}

+(FSAppDelegate *)app{
    return (FSAppDelegate *)[UIApplication sharedApplication];
}

-(void) setGlobalLayout
{
    UINavigationBar *nav = [UINavigationBar appearance];
    [nav setBackgroundImage: [UIImage imageNamed: @"top_title_bg"] forBarMetrics: UIBarMetricsDefault];
    [nav setTitleTextAttributes:@{UITextAttributeFont:[UIFont boldSystemFontOfSize:18],UITextAttributeTextColor:APP_NAV_TITLE_COLOR}];
    [nav setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    nav.tintColor = [UIColor blackColor];
    nav.backgroundColor = [UIColor blackColor];
}

-(void) setupAnalys
{
    [[FSAnalysis instance] start];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSString *schema = url.scheme ;
    if ([schema hasPrefix:WEIXIN_API_APP_KEY])
    {
        return  [[FSWeixinActivity sharedInstance] handleOpenUrl:url];
    }
    else if ([schema hasSuffix:QQ_CONNECT_APP_ID]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([schema hasPrefix:AlipayProductCode]) {
        [self parse:url application:application];
    }
    return YES; 
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *schema = url.scheme ;
    if ([schema hasPrefix:WEIXIN_API_APP_KEY])
    {
        return  [[FSWeixinActivity sharedInstance] handleOpenUrl:url];
    }
    else if ([schema hasSuffix:QQ_CONNECT_APP_ID]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    else if ([schema hasPrefix:AlipayProductCode]) {
        [self parse:url application:application];
    }
    return YES;
}

#pragma mark - Push Notification

- (void)registerPushNotification
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"My token error: %@", [error description]);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString * token = [deviceToken description];
	if (token.length > 0 )
	{
		token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
		token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
		token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
	}
	if (token.length == 64)
	{
        localToken = token;
        if (locationManager.locationAwared)
        {
            [self registerDevicePushNotification];
            
            [[FSAnalysis instance] setLocation:locationManager.innerLocation.location];
        }
        else
        {
            [locationManager addObserver:self forKeyPath:@"locationAwared" options:NSKeyValueObservingOptionNew context:nil];
        }
	}
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"locationAwared"])
    {
        [self registerDevicePushNotification];
        [locationManager removeObserver:self forKeyPath:@"locationAwared"];
        
        [[FSAnalysis instance] setLocation:locationManager.innerLocation.location];
    }
}

- (void)registerDevicePushNotification
{    
#if defined ENVIRONMENT_DEVELOPMENT
    return;
#endif
    if (!localToken || [localToken isEqualToString:@""]) {
        localToken = [FSUser localDeviceToken];
        if (!localToken || [localToken isEqualToString:@""])
            return;
    }
    NSString *uId = [NSString stringWithFormat:@"%@", [FSModelManager sharedModelManager].localLoginUid];
    if (!uId || [uId isEqualToString:@""]) {
        return;
    }
    [modelManager enqueueBackgroundBlock:^(void){
        FSDeviceRegisterRequest *request = [[FSDeviceRegisterRequest alloc] init];
        request.longit =[[NSNumber alloc] initWithDouble:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit = [[NSNumber alloc] initWithDouble:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        request.deviceToken = localToken;
        request.userToken = [FSModelManager sharedModelManager].loginToken;
        request.userId = uId;
        request.deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [request send:[FSModelBase class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (resp.isSuccess)
            {
                [FSUser saveDeviceToken:localToken];
            }
        }]; 
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    pushInfoDic = userInfo;
    //根据不同的key值跳转到不同的界面
    NSString * from = (NSString*)[pushInfoDic objectForKey:@"from"];
    NSDictionary *dic = [from JSONValue];
    int type = [[dic objectForKey:@"targettype"] intValue];
    if([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [self pushTo];
    }
    id value = [dic objectForKey:@"targetvalue"];
    if (type == 3) {
        [self addNewCommentID:value];
    }
    else if (type == 4) {
        [self addNewPLetterID:value];
    }
}

-(void)addNewCommentID:(NSString *)commentID
{
    NSMutableArray *_array = nil;
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue"];
    if (temp && [temp isKindOfClass:[NSMutableArray class]]) {
        _array = [NSMutableArray arrayWithArray:temp];
    }
    else{
        _array = [[NSMutableArray alloc] initWithCapacity:1];
    }
    BOOL flag = NO;
    for (NSString *item in _array) {
        if ([item intValue] == [commentID intValue]) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        [_array addObject:commentID];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"targetvalue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification" object:nil];
}

-(void)addNewPLetterID:(NSString *)pletterID
{
    NSMutableArray *_array = nil;
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue_pletter"];
    if (temp && [temp isKindOfClass:[NSMutableArray class]]) {
        _array = [NSMutableArray arrayWithArray:temp];
    }
    else{
        _array = [[NSMutableArray alloc] initWithCapacity:1];
    }
    BOOL flag = NO;
    for (NSString *item in _array) {
        if ([item intValue] == [pletterID intValue]) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        [_array addObject:pletterID];
    }
    [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"targetvalue_pletter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification_pletter" object:nil];
    }
}

-(void)removeCommentID:(NSString *)commentID
{
    [self removeCommentIDs:[NSArray arrayWithObject:commentID]];
}

-(void)removePLetterID:(NSString *)pletterID
{
    [self removePLetterIDs:[NSArray arrayWithObject:pletterID]];
}

-(void)removeCommentIDs:(NSArray *)ids
{
    if (!ids || ids.count <= 0) {
        return;
    }
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue"];
    NSMutableArray *_array = [NSMutableArray arrayWithArray:temp];
    if (!_array || _array.count <= 0) {
        return;
    }
    NSMutableArray *toDelArray = [NSMutableArray array];
    for (NSString *toDel in ids) {
        NSString *delString = nil;
        for (NSString *item in _array) {
            if ([item intValue] == [toDel intValue]) {
                delString = item;
                break;
            }
        }
        if (delString) {
            [toDelArray addObject:delString];
        }
    }
    if (toDelArray.count > 0) {
        [_array removeObjectsInArray:toDelArray];
        [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"targetvalue"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification" object:nil];
    }
}

-(void)removePLetterIDs:(NSArray *)ids
{
    if (!ids || ids.count <= 0) {
        return;
    }
    id temp = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue_pletter"];
    NSMutableArray *_array = [NSMutableArray arrayWithArray:temp];
    if (!_array || _array.count <= 0) {
        return;
    }
    NSMutableArray *toDelArray = [NSMutableArray array];
    for (NSString *toDel in ids) {
        NSString *delString = nil;
        for (NSString *item in _array) {
            if ([item intValue] == [toDel intValue]) {
                delString = item;
                break;
            }
        }
        if (delString) {
            [toDelArray addObject:delString];
        }
    }
    if (toDelArray.count > 0) {
        [_array removeObjectsInArray:toDelArray];
        [[NSUserDefaults standardUserDefaults] setObject:_array forKey:@"targetvalue_pletter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification_pletter" object:nil];
    }
}

-(int)newCommentCount
{
    NSMutableArray *_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue"];
    if (_array && _array.count > 0) {
        return _array.count;
    }
    return 0;
}

-(int)newCommentCount_pletter
{
    NSMutableArray *_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue_pletter"];
    if (_array && _array.count > 0) {
        return _array.count;
    }
    return 0;
}

-(void)hiddenPickerView
{
    for (UIView *item in self.window.subviews) {
        if ([item isKindOfClass:[FSMyPickerView class]]) {
            FSMyPickerView *_item = (FSMyPickerView*)item;
            [_item hidenPickerView:YES action:nil];
        }
    }
}

-(void)cleanAllPickerView
{
    for (UIView *item in self.window.subviews) {
        if ([item isKindOfClass:[FSMyPickerView class]]) {
            [(FSMyPickerView*)item removeFromSuperview];
        }
    }
}

-(NSString*)messageForKey:(NSString *)key
{
    if (!_messageItems || _messageItems.count <= 0) {
        return nil;
    }
    for (FSEnMessageItem *item in _messageItems) {
        if ([item.key isEqualToString:key]) {
            return item.message;
        }
    }
    return nil;
}

-(void)receivePushNotice:(NSNotification*)notification
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *root = [storyBoard instantiateInitialViewController];
    UINavigationController *con = root.viewControllers[3];
    if ([notification.object boolValue]) {
        con.tabBarItem.badgeValue = @"new";
    }
    else{
        con.tabBarItem.badgeValue = nil;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application NS_AVAILABLE_IOS(4_0)
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application NS_AVAILABLE_IOS(4_0)
{
}

-(void)pushTo
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UITabBarController *root = [storyBoard instantiateInitialViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = root;
    [self.window makeKeyAndVisible];
    
    UINavigationController *con = root.viewControllers[3];
    [[NSNotificationCenter defaultCenter] addObserver:con.topViewController selector:@selector(receivePushNotification:) name:@"ReceivePushNotification" object:nil];
    
    //添加背景色
    NSArray *array = [root.view subviews];
    UITabBar *_tabbar = [array objectAtIndex:1];
    UIImageView *_vImage = [[UIImageView alloc] init];
    _vImage.image = [UIImage imageNamed:@"Toolbar_bg.png"];
    _vImage.frame = CGRectMake(0, 0, 320, TAB_HIGH);
    [_tabbar insertSubview:_vImage atIndex:1];
    for (int i = 0; i < _tabbar.items.count; i++) {
        UITabBarItem *item = _tabbar.items[i];
//        if (IOS7) {
//            UIImage *img = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d.png", i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            UIImage *img_sel = [[UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d_sel.png", i + 1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            item = [item initWithTitle:[[NSArray arrayWithObjects:@"促销",@"专题",@"东东",@"我", nil] objectAtIndex:i] image:img selectedImage:img_sel];
//        }
//        else
        {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d.png", i + 1]];
            UIImage *img_sel = [UIImage imageNamed:[NSString stringWithFormat:@"tab_bar_%d_sel.png", i + 1]];
            [item setFinishedSelectedImage:img_sel withFinishedUnselectedImage:img];
        }
        
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        [item setImageInsets:UIEdgeInsetsMake(4, 0, -4, 0)];
    }
    
    /*
     "from"key对应的value为json字符串
     {“targettype”,"targetvalue"}
     targettype:
     0-首页
     1-商品详情
     2-促销详情
     3-我的评论
     4-私信
     5-URL
     
     返回形式：
     返回形式：
     {
     aps =     {
        alert = "\U65b0\U8bc4\U8bba...";
        badge = 1;
        sound = "sound.caf";
     };
     from = "{\"targettype\":3,\"targetvalue\":\"\"}";
     }
     */
    //根据不同的key值跳转到不同的界面
    NSString * from = (NSString*)[pushInfoDic objectForKey:@"from"];
    NSDictionary *dic = [from JSONValue];
    int type = [[dic objectForKey:@"targettype"] intValue];
    NSString *value = [dic objectForKey:@"targetvalue"];
    switch (type) {
        case 0://首页
        {
            root.selectedIndex = 0;
        }
            break;
        case 1://商品详情
        {
            root.selectedIndex = 1;
            UINavigationController *nav = (UINavigationController*)root.selectedViewController;
            FSProDetailViewController *detailView = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
            FSProItemEntity *item = [[FSProItemEntity alloc] init];
            item.id = [value intValue];
            detailView.navContext = [[NSMutableArray alloc] initWithObjects:item, nil];
            detailView.sourceType = FSSourceProduct;
            detailView.indexInContext = 0;
            detailView.dataProviderInContext = self;
            UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailView];
            [nav presentViewController:navControl animated:true completion:nil];
            
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
            [_dic setValue:@"push推送" forKey:@"来源页面"];
            [_dic setValue:[NSString stringWithFormat:@"%d", [value intValue]] forKey:@"商品ID"];
            [_dic setValue:nil forKey:@"商品名称"];
            [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
        }
            break;
        case 2://促销详情
        {
            root.selectedIndex = 1;
            UINavigationController *nav = (UINavigationController*)root.selectedViewController;
            FSProDetailViewController *detailView = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
            FSProdItemEntity *item = [[FSProdItemEntity alloc] init];
            item.id = [value intValue];
            detailView.navContext = [[NSMutableArray alloc] initWithObjects:item, nil];
            detailView.sourceType = FSSourcePromotion;
            detailView.indexInContext = 0;
            detailView.dataProviderInContext = self;
            UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailView];
            [nav presentViewController:navControl animated:true completion:nil];
            
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
            [_dic setValue:@"push推送" forKey:@"来源页面"];
            [_dic setValue:[NSString stringWithFormat:@"%d", [value intValue]] forKey:@"活动ID"];
            [_dic setValue:nil forKey:@"活动名称"];
            [[FSAnalysis instance] logEvent:CHECK_COUPON_DETAIL withParameters:_dic];
        }
            break;
        case 3://我的评论
        {
            //导航到我的评论页
            root.selectedIndex = 3;
            UINavigationController *nav = (UINavigationController*)root.selectedViewController;
            [FSModelManager localLogin:nav withBlock:^{
                FSMyCommentController *controller = [[FSMyCommentController alloc] initWithNibName:@"FSMyCommentController" bundle:nil];
                controller.originalIndex = 1;
                [nav pushViewController:controller animated:true];
                
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [_dic setValue:@"push推送" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:CHECK_COMMENT_PAGE withParameters:_dic];
            }];
        }
            break;
        case 4://私信
        {
            //导航到我的私信页
            root.selectedIndex = 3;
            UINavigationController *nav = (UINavigationController*)root.selectedViewController;
            [FSModelManager localLogin:nav withBlock:^{
                FSMyCommentController *controller = [[FSMyCommentController alloc] initWithNibName:@"FSMyCommentController" bundle:nil];
                [nav pushViewController:controller animated:NO];
                
                FSMessageViewController *viewController = [[FSMessageViewController alloc] init];
                FSUser *user = [[FSUser alloc] init];
                user.nickie = @"私信";
                user.uid = [NSNumber numberWithInt:[value intValue]];
                viewController.touchUser = user;
                viewController.lastConversationId = 0;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                [controller presentViewController:nav animated:YES completion:nil];
                
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
                [_dic setValue:@"push推送" forKey:@"来源页面"];
                [_dic setValue:viewController.touchUser.nickie forKey:@"私信对象名称"];
                [_dic setValue:viewController.touchUser.uid forKey:@"私信对象ID"];
                [[FSAnalysis instance] logEvent:CHECK_MESSAGE_PAGE withParameters:_dic];
            }];
        }
            break;
        case 5://URL
        {
            root.selectedIndex = 1;
            UINavigationController *nav = (UINavigationController*)root.selectedViewController;
            FSContentViewController *controller = [[FSContentViewController alloc] init];
            controller.fileName = value;
            controller.title = [[pushInfoDic objectForKey:@"aps"] objectForKey:@"alert"];
            [nav pushViewController:controller animated:YES];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [_dic setValue:@"指定网址" forKey:@"类型"];
            [_dic setValue:@"push推送" forKey:@"标题"];
            [[FSAnalysis instance] logEvent:CHECK_TOPIC_DETAIL withParameters:_dic];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Write And Read File

-(BOOL)writeFile:(NSString*)aString fileName:(NSString*)aFileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName=[path stringByAppendingPathComponent:aFileName];
    return [aString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

-(NSString*)readFromFile:(NSString *)aFileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName=[path stringByAppendingPathComponent:aFileName];
    return [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - Audio Method

-(void)initAudioRecoder
{
    [self initAudioProperty];
    _audioRecoder = [[CL_AudioRecorder alloc] initWithFinishRecordingBlock:^(CL_AudioRecorder *recorder, BOOL success) {
    } encodeErrorRecordingBlock:^(CL_AudioRecorder *recorder, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    } receivedRecordingBlock:^(CL_AudioRecorder *recorder, float peakPower, float averagePower, float currentTime) {
    }];
}

-(void)initAudioProperty
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || UIUserInterfaceIdiomPad)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        if ([audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
        {
            if ([audioSession setActive:YES error:&error])
            {
            }
            else
            {
                NSLog(@"Failed to set audio session category: %@", error);
            }
        }
        else
        {
            NSLog(@"Failed to set audio session category: %@", error);
        }
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride),&audioRouteOverride);
    }
}

#pragma mark - UMTrack

-(void)initUMTrack
{
    NSString * appKey = @"ebfc9b31ddfaf25bc3d526cefd48758f";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@", appKey,deviceName,mac];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
}

- (NSString * )macString{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return macString;
}

#pragma mark - FSProDetailItemSourceProvider

-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return view.sourceType;
}

-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return TRUE;
}

#pragma mark - AliPay

- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
        NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		result = [[AlixPayResult alloc] initWithString:query];
	}
    
	if (result)
    {
		[self dealAlipayResult:result];
    }
}

//====================================================
// 函数名称: btnForCallClick
// 函数功能: 支付宝付款
// 返 回 值: void
// 形式参数: void
//====================================================
-(void)toAlipayWithOrder:(NSString*)ordernumber name:(NSString*)productName desc:(NSString*)productDesc amount:(float)amount {
	//将商品信息赋予AlixPayOrder的成员变量
	AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = PartnerID;
	order.seller = SellerID;
	order.tradeNO = ordernumber;  //订单ID（由商家自行制定）
	order.productName = productName;         //@"买的一大堆商品";        //商品标题
	order.productDescription =  productDesc; //@"好东西呀,便宜！杠杠的";   //商品描述
	order.amount = [NSString stringWithFormat:@"%.2f", amount];    //商品价格
	order.notifyURL = AlipayNotifyURL;
	
	//应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于安全支付成功后重新唤起商户应用
	NSString *appScheme = AlipayProductCode;
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
	NSString *signedString = [signer signString:orderSpec];
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
	}
    
    //支付宝支付请求暂时只支持非模拟器，如果使用模拟器调试，请屏蔽该内容。
    [AlixLibService payOrder:orderString AndScheme:appScheme seletor:@selector(paymentResult:) target:self];
}

-(void)paymentResult:(NSString *)resultd
{
    //结果处理
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {
		[self dealAlipayResult:result];
    }
}

-(void)dealAlipayResult:(AlixPayResult*)result
{
    if (result.statusCode == 9000)
    {
        /*
         *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
         */
        
        //交易成功
        NSString* key = AlipayPubKey;
        id<DataVerifier> verifier;
        verifier = CreateRSADataVerifier(key);
        
        if ([verifier verifyString:result.resultString withSign:result.signString])
        {
            //验证签名成功，交易结果无篡改
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"付款成功!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"支付宝签名错误"
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView show];
        }
    }
    else
    {
        //交易失败
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:result.statusMessage
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0)
{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
}

@end
