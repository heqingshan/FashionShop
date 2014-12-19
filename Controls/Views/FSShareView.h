//
//  FSShareView.h
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


typedef void (^FSShareCompleteHandler) (NSString *activityType, BOOL completed) ;
@interface FSUIActivity_ : NSObject
@property(nonatomic,copy) FSShareCompleteHandler completeHandler;
- (void)prepareWithActivityItems:(NSArray *)activityItems ;
- (UIViewController *)activityViewController;
- (void)performActivity;
- (void)activityDidFinish:(BOOL)completed;
@end



#import <Foundation/Foundation.h>
#import "AWActionSheet.h"

#define SHARE_WX_ICON @"weixin_icon"
#define SHARE_WX_TITLE @"微信朋友圈"
#define SHARE_WX_FRIENDS_ICON @"weixin_friends_icon"
#define SHARE_WX_FRIENDS_TITLE @"微信好友"
#define SHARE_WB_ICON @"xinlang_weibo_icon"
#define SHARE_WB_TITLE @"新浪微博"
#define SHARE_TC_ICON @"tengxun_weibo_icon"
#define SHARE_TC_TITLE @"腾迅微博"
#define SHARE_QQ_ICON @"qq_friends_icon"
#define SHARE_QQ_TITLE @"QQ空间"


@interface FSShareView : NSObject<AWActionSheetDelegate>

+(UIActivityViewController *)shareViewController:(NSMutableArray *)shareItems;

+(FSShareView *)instance;

-(void)shareBegin:(UIViewController *)vc withShareItems:(NSMutableArray *)items completeHander:(FSShareCompleteHandler)action;
@end

#if (__IPHONE_OS_VERSION_MIN_REQUIRED < 60000)
#define FSUIActivity FSUIActivity_
#else
#define FSUIActivity UIActivity
#endif