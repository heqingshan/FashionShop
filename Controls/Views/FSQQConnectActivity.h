//
//  FSQQConnectActivity.h
//  FashionShop
//
//  Created by HeQingshan on 13-3-3.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "FSShareView.h"

@class FSQQConnectActivity;

@protocol FSQQConnectActivityDelegate <NSObject>

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin:(FSQQConnectActivity*)view;


/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(FSQQConnectActivity*)view state:(BOOL)cancelled;

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork:(FSQQConnectActivity*)view;


/**
 * 退出登录的回调
 */
- (void)tencentDidLogout:(FSQQConnectActivity*)view;

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(FSQQConnectActivity*)view response:(APIResponse*) response;

@end

@interface FSQQConnectActivity : FSUIActivity<TencentSessionDelegate>

@property (nonatomic,assign) id<FSQQConnectActivityDelegate> qqDelegate;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) NSString *imgURL;

+(FSQQConnectActivity *)sharedInstance;
-(void)initTencentOAuth;
-(void)authorize;

@end
