//
//  SinaWeiboAuthorizeViewController.h
//  FashionShop
//
//  Created by gong yi on 11/29/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeiboAuthorizeView.h"


@protocol SinaWeiboAuthorizeView2Delegate;

@interface SinaWeiboAuthorizeViewController : UIViewController<UIWebViewDelegate, UIAlertViewDelegate>{
    
    UIWebView                                   *webView;
    UIActivityIndicatorView                     *indicatorView;
    
    NSString *appRedirectURI;
    NSDictionary *authParams;

}

@property (nonatomic) id<SinaWeiboAuthorizeView2Delegate>  delegate;

- (id)initWithAuthParams:(NSDictionary *)params
                delegate:(id<SinaWeiboAuthorizeView2Delegate>)delegate;
@end


@protocol SinaWeiboAuthorizeView2Delegate <NSObject>

- (void)authorizeView2:(SinaWeiboAuthorizeViewController *)authView
didRecieveAuthorizationCode:(NSString *)code;
- (void)authorizeView2:(SinaWeiboAuthorizeViewController *)authView
 didFailWithErrorInfo:(NSDictionary *)errorInfo;
- (void)authorizeViewDidCancel2:(SinaWeiboAuthorizeViewController *)authView;

@end