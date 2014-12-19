//
//  FSQQConnectActivity.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-3.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSQQConnectActivity.h"

static FSQQConnectActivity *singleon;

@interface FSQQConnectActivity() {
    NSMutableArray* _permissions;
}
@end


@implementation FSQQConnectActivity
@synthesize title,img,imgURL;

- (NSString *)activityType {
    return @"UIActivityFSPostToQQZone";
}

- (NSString *)activityTitle {
    return SHARE_QQ_TITLE;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:SHARE_QQ_ICON];
}


- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    title = [activityItems objectAtIndex:0];
    if (activityItems.count>1)
    {
        img = [activityItems objectAtIndex:1];
    }
    if (activityItems.count > 2) {
        imgURL = [activityItems objectAtIndex:2];
    }
}

- (UIViewController *)activityViewController
{
    return nil;
}

-(void) performActivity
{
    if (!_tencentOAuth.isSessionValid)
    {
        [self authorize];
    }
    else {
        TCAddShareDic *params = [TCAddShareDic dictionary];
        params.paramTitle = title;
        params.paramImages = imgURL;
        params.paramUrl = @"http://www.intime.com.cn";
        
        [_tencentOAuth addShareWithParams:params];
    }
}

+(FSQQConnectActivity *)sharedInstance
{
    if (singleon==nil)
    {
        singleon = [[FSQQConnectActivity alloc] init];
    }
    return singleon;
}

-(void)initTencentOAuth
{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_CONNECT_APP_ID
                                                andDelegate:self];
    }
    if (!_permissions) {
        _permissions = [NSMutableArray arrayWithObjects:
                        kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                        kOPEN_PERMISSION_GET_VIP_INFO,
                        kOPEN_PERMISSION_ADD_SHARE,
                        nil];
    }
}

-(void)authorize
{
    [self initTencentOAuth];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

#pragma mark - TencentSessionDelegate

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    if ([_qqDelegate respondsToSelector:@selector(tencentDidLogin:)]) {
        [_qqDelegate tencentDidLogin:self];
    }
    else {
        [self performActivity];
    }
}
/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if ([_qqDelegate respondsToSelector:@selector(tencentDidNotLogin:state:)]) {
        [_qqDelegate tencentDidNotLogin:self state:cancelled];
    }
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    if ([_qqDelegate respondsToSelector:@selector(tencentDidNotNetWork:)]) {
        [_qqDelegate tencentDidNotNetWork:self];
    }
}
/**
 * 退出登录的回调
 */
- (void)tencentDidLogout
{
    if ([_qqDelegate respondsToSelector:@selector(tencentDidLogout:)]) {
        [_qqDelegate tencentDidLogout:self];
    }
}
/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response
{
    if ([_qqDelegate respondsToSelector:@selector(getUserInfoResponse:response:)]) {
        [_qqDelegate getUserInfoResponse:self response:response];
    }
}

- (void)addShareResponse:(APIResponse*) response
{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"COMM_OPERATE_SUCCESS", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alert show];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"COMM_OPERATE_FAILED", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
		[alert show];
	}
}

@end
