//
//  FSShareView.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSShareView.h"
#import "FSTCWBActivity.h"
#import "FSWeiboActivity.h"
#import "FSWeixinActivity.h"
#import "FSQQConnectActivity.h"

static FSShareView *_instance;

@interface FSShareView(){
    NSMutableArray *shareCells;
    NSMutableArray *shareItems;
    FSShareCompleteHandler shareCompleteaction;
    UIViewController *parentVC;
    FSUIActivity *activity ;
}
@end
@implementation FSShareView

+(FSShareView *)instance
{
    if (!_instance)
    {
        _instance = [FSShareView new];
    }
    return _instance;
}

-(void)shareBegin:(UIViewController *)vc withShareItems:(NSMutableArray *)items completeHander:(FSShareCompleteHandler)action
{
    /*
    if ([UIActivityViewController class])
    {
        UIActivityViewController *shareController =  [FSShareView shareViewController:items];
        shareController.completionHandler= action;
        [vc presentViewController:shareController animated:YES completion:nil];
        
    }
    else
    {
     */
    parentVC = vc;
    shareItems = items;
    shareCompleteaction = action;
    [self configActionsIcon];
    AWActionSheet *sheet = [[AWActionSheet alloc] initWithIconSheetDelegate:self ItemCount:shareCells.count];
    [sheet showInView:vc.view];
    //}
}

+(UIActivityViewController *)shareViewController:(NSMutableArray *)shareItems
{
    
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeMail,UIActivityTypeSaveToCameraRoll,UIActivityTypeAssignToContact];
    FSWeiboActivity *weibo = [[FSWeiboActivity alloc] init];

    FSWeixinActivity *weixin = [FSWeixinActivity sharedInstance];
    FSTCWBActivity *qqweibo = [[FSTCWBActivity alloc] init];
    NSArray *activities = @[weibo,weixin,qqweibo];
    
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:activities];

    shareController.excludedActivityTypes = excludeActivities;

    return shareController;
    
}

-(void) configActionsIcon
{
    if (!shareCells)
    {
        shareCells = [@[] mutableCopy];
        [self createActionCell:SHARE_WB_ICON withTitle:SHARE_WB_TITLE];
        [self createActionCell:SHARE_WX_FRIENDS_ICON    withTitle:SHARE_WX_FRIENDS_TITLE];
        [self createActionCell:SHARE_TC_ICON    withTitle:SHARE_TC_TITLE];
        [self createActionCell:SHARE_WX_ICON    withTitle:SHARE_WX_TITLE];
        [self createActionCell:SHARE_QQ_ICON    withTitle:SHARE_QQ_TITLE];
    }
}
-(void)createActionCell:(NSString *)icon withTitle:(NSString *)title
{
    AWActionSheetCell *wx = [[AWActionSheetCell alloc] init];
    wx.iconView.image = [UIImage imageNamed:icon];
    [[wx titleLabel] setText:title];
    wx.index = shareCells.count;
    [shareCells addObject:wx];
}

#pragma ActionSheet delegate

-(int)numberOfItemsInActionSheet
{
    return shareCells.count;
}
-(AWActionSheetCell *)cellForActionAtIndex:(NSInteger)index
{
    return [shareCells objectAtIndex:index];
}

-(void)DidTapOnItemAtIndex:(NSInteger)index
{
    NSString *value = nil;
    switch (index) {
        case 0:
        {
            activity = [[FSWeiboActivity alloc] init];
            value = @"新浪微博";
            break;
        }
        case 1://微信好友
        {
            activity = [FSWeixinActivity sharedInstance];
            ((FSWeixinActivity*)activity).shareType = WXShareTypeFriend;
            value = @"微信好友";
            break;
        }
        case 2:
        {
            activity = [[FSTCWBActivity alloc] init];
            value = @"腾讯微博";
            break;
        }
        case 3:
        {
            activity = [FSWeixinActivity sharedInstance];
            ((FSWeixinActivity*)activity).shareType = WXShareTypeFriendCircle;
            value = @"微信朋友圈";
            break;
        }
        case 4:
        {
            activity = [FSQQConnectActivity sharedInstance];
            value = @"QQ空间";
            break;
        }
        default:
            break;
    }
    if (!activity)
        return;
    activity.completeHandler = shareCompleteaction;
    [activity prepareWithActivityItems:shareItems];
    UIViewController *aVC = activity.activityViewController;
    if (!aVC)
    {
       [ activity performActivity];
    }
    else
    {
        [parentVC presentViewController:aVC animated:TRUE completion:nil];
    }
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:value forKey:@"分享渠道"];
    [[FSAnalysis instance] logEvent:COMMON_SHARE withParameters:_dic];
}


@end


@implementation FSUIActivity_

- (void)activityDidFinish:(BOOL)completed
{
    if (_completeHandler)
        _completeHandler(nil,completed);
    /*
        if (![UIActivityViewController class] &&
            _completeHandler)
            _completeHandler(nil,completed);
        else
        {
            if ([self isKindOfClass:[UIActivity class]])
            {
                Class uaclass = [UIActivity class];
                IMP impl = class_getMethodImplementation(uaclass,_cmd);
                impl(self, _cmd,completed);
            }
        }
    */
}
/*
__attribute__((constructor)) static void FSCreateUIActivityClasses(void) {
    @autoreleasepool {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

        if ([UIActivity class]) class_setSuperclass([FSUIActivity_ class], [UIActivity class]);
        else objc_registerClassPair(objc_allocateClassPair([FSUIActivity class], "UIActitity", 0));
        
	
      
    }
}
*/
@end




