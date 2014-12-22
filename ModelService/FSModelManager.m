//
//  FSModelManager.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelManager.h"
//#import "RestKit.h"
#import "FSConfigListRequest.h"
#import "FSLocalPersist.h"
#import "SDImageCache.h"
#import "FSLocationManager.h"
#import "FSCoreStore.h"
#import "FSCoreBrand.h"
#import "FSGroupBrand.h"
#import "FSCommonRequest.h"
#import "FSCommon.h"
#import "FSMeViewController.h"

@interface FSModelManager()
{
    BOOL _isConfigLoaded;
    NSOperationQueue *_asyncQueue;
    SinaWeibo *_weibo;

}

@end
static FSModelManager *_modelManager;

@implementation FSModelManager

- (void) initModelManager{
    //[RKManagedObjectStore deleteStoreInApplicationDataDirectoryWithFilename:@"FSShop.sqlite"];
    RKURL *baseURL = [RKURL URLWithBaseURLString:REST_API_URL];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    //objectManager.client.baseURL = baseURL;
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ssZ" inTimeZone:nil];
    
    RKManagedObjectStore *objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"FSShop.sqlite"];
    objectManager.objectStore = objectStore;
   
#ifdef ENVIRONMENT_DEV
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif
}

-(id) init
{
    self = [super init];
    if (self)
    {
        _asyncQueue = [[NSOperationQueue alloc] init];
        [_asyncQueue setMaxConcurrentOperationCount:2];
        [self initModelManager];
    }
    return self;
}


+(RKObjectManager *)sharedManager{
    return  [RKObjectManager sharedManager];
    
}

+(FSModelManager *)sharedModelManager
{
    if (!_modelManager)
    {
        _modelManager = [[FSModelManager alloc] init];
        [_modelManager initConfig];
      
    }
    return _modelManager;
}


-(BOOL) isConfigLoaded
{
    return _isConfigLoaded;
}

-(BOOL) isLogined
{
    NSString *loginToken = [FSUser localLoginToken];

    if (loginToken!=nil && loginToken.length>0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(void)enqueueBackgroundOperation:(NSOperation *)operation{
    [_asyncQueue addOperation:operation];
}

-(void)enqueueBackgroundBlock:(dispatch_block_t)block{
    [_asyncQueue addOperationWithBlock:block];
}

-(NSString *) loginToken
{
    return [FSUser localLoginToken];
}

-(NSNumber *) localLoginUid
{
    return [FSUser localLoginUid];
}

-(void) forceReloadTags
{
    [self enqueueBackgroundBlock:^{
        FSConfigListRequest *request = [[FSConfigListRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_CONFIG_TAG_ALL;
        [request send:[FSTag class] withRequest:request completeCallBack:^(FSEntityBase *req) {
            if (req.isSuccess) {
                NSMutableArray *array = [NSMutableArray array];
                int len = [req.responseData count];
                for (int i = len-1; i >= 0; i--) {
                    [array addObject:[req.responseData objectAtIndex:i]];
                }
                theApp.allTags = array;
                NSLog(@"tag/all load success!");
            }
            else{
                theApp.allTags = nil;
                NSLog(@"tag/all load failed!");
            }
        }];
    }];

}

/*
-(void) forceReloadBrands
{
    [self enqueueBackgroundBlock:^{
        
        FSConfigListRequest *request = [[FSConfigListRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_CONFIG_BRAND_ALL;
        [request send:[FSBrand class] withRequest:request completeCallBack:^(FSEntityBase *req) {
            if (req.isSuccess) {
                theApp.allBrands = req.responseData;
                NSLog(@"brand/all load success!");
            }
            else{
                theApp.allBrands = nil;
                NSLog(@"brand/all load failed!");
            }
        }];
    }];
}
 */

-(void) forceReloadAllBrands
{
    [self enqueueBackgroundBlock:^{
        FSConfigListRequest *request = [[FSConfigListRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_CONFIG_GROUP_BRAND_ALL;
        [request send:[FSGroupBrand class] withRequest:request completeCallBack:^(FSEntityBase *req) {
            if (req.isSuccess) {
                theApp.allBrands = req.responseData;
                NSLog(@"groupbrand/all load success");
            }
            else{
                theApp.allBrands = nil;
                NSLog(@"groupbrand/all load failed");
            }
        }];
    }];
}

-(void) forceReloadStores
{
    [self enqueueBackgroundBlock:^() {
        FSConfigListRequest *request = [[FSConfigListRequest alloc] init];
        request.longit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.longitude];
        request.lantit =[NSNumber numberWithFloat:[FSLocationManager sharedLocationManager].currentCoord.latitude];
        request.routeResourcePath = RK_REQUEST_CONFIG_STORE_ALL;
        [request send:[FSStore class] withRequest:request completeCallBack:^(FSEntityBase *req) {
            if (req.isSuccess) {
                theApp.allStores = req.responseData;
                NSLog(@"store/all load success!");
            }
            else{
                theApp.allStores = nil;
                NSLog(@"store/all load failed!");
            }
        }];
    }];
}

-(void) forceREloadEnviromentMessage
{
    [self enqueueBackgroundBlock:^{
        FSCommonRequest *request = [[FSCommonRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_ENVIROMENT_MESSAGE;
        request.rootKeyPath = @"data.items";
        [request send:[FSEnMessageItem class] withRequest:request completeCallBack:^(FSEntityBase *req) {
            if (req.isSuccess) {
                theApp.messageItems = req.responseData;
                NSLog(@"messages/all load success!");
            }
            else{
                theApp.messageItems = nil;
                NSLog(@"message/all load failed!");
            }
        }];
    }];
}

-(void) initConfig
{
//    if (IOS7) {
//        [self forceReloadTags];
//        //[self forceReloadAllBrands];
//        [self forceReloadStores];
//        [self forceREloadEnviromentMessage];
//        return;
//    }
    //延迟加载
    [self performSelector:@selector(forceReloadTags) withObject:nil afterDelay:1];
    //[self performSelector:@selector(forceReloadAllBrands) withObject:nil afterDelay:3];
    [self performSelector:@selector(forceReloadStores) withObject:nil afterDelay:5];
    [self performSelector:@selector(forceREloadEnviromentMessage) withObject:nil afterDelay:6];
}

-(SinaWeibo *)instantiateWeiboClient:(id<SinaWeiboDelegate>)delegate
{
    if (!_weibo)
    {
       _weibo = [[SinaWeibo alloc] initWithAppKey:SINA_WEIBO_APP_KEY appSecret:SINA_WEIBO_APP_SECRET_KEY appRedirectURI:SINA_WEIBO_APP_REDIRECT_URI andDelegate:delegate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            _weibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            _weibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            _weibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
    }
    _weibo.delegate = delegate;
    return _weibo;
}

-(void)storeWeiboAuth:(SinaWeibo *)weibo
{
    
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              weibo.accessToken, @"AccessTokenKey",
                              weibo.expirationDate, @"ExpirationDateKey",
                              weibo.userID, @"UserIDKey",
                              weibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)removeWeiboAuthCache
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    if (_weibo)
        [_weibo removeAuthData];

}

-(void)clearCache
{
    [self enqueueBackgroundBlock:^() {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDisk];
        [self clearAudioFile];
    }];
}

-(void)clearAudioFile
{
    NSArray *extensions = [NSArray arrayWithObjects:@"mp3",@"m4a",@"aac", nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:kRecorderDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        if ([extensions containsObject:[filename pathExtension]]) {
            [fileManager removeItemAtPath:[kRecorderDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

#pragma BAIDU MAP DELEGATE
- (void)onGetNetworkState:(int)iError
{
}

- (void)onGetPermissionState:(int)iError
{
}

+(void)localLogin:(UIViewController *)con withBlock:(void (^)(void))block
{
    bool isLogined = [[FSModelManager sharedModelManager] isLogined];
    if (!isLogined)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
        FSMeViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"userProfile"];
        __block FSMeViewController *blockMeController = loginController;
        loginController.completeCallBack=^(BOOL isSuccess){
            [blockMeController dismissViewControllerAnimated:true completion:^{
                if (!isSuccess)
                {
                    [con reportError:NSLocalizedString(@"COMM_OPERATE_FAILED", nil)];
                }
                else
                {
                    block();
                }
            }];
        };
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [con presentViewController:navController animated:YES completion:nil];
        [[FSAnalysis instance] autoTrackPages:navController];
    }
    else
    {
        block();
    }
}


@end
