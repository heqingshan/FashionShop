//
//  FSWeixinActivity.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSWeixinActivity.h"
#import "FSShareView.h"
#import "WxpayResp.h"

static BOOL Is_Weixin_Registered = false;
static FSWeixinActivity *singleon;

@implementation FSWeixinActivity
@synthesize title,img,shareType;


+(FSWeixinActivity *)sharedInstance
{
    if (singleon==nil)
    {
        singleon = [[FSWeixinActivity alloc] init];
    }
    return singleon;
}

-(BOOL)handleOpenUrl:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (NSString *)activityType {
    return @"UIActivityFSPostToWeixin";
}

- (NSString *)activityTitle {
    if (shareType == WXShareTypeFriend) {
        return SHARE_WX_FRIENDS_TITLE;
    }
    else {
        return SHARE_WX_TITLE;
    }
}

- (UIImage *)activityImage {
    if (shareType == WXShareTypeFriend) {
        return [UIImage imageNamed:SHARE_WX_FRIENDS_ICON];
    }
    else {
        return [UIImage imageNamed:SHARE_WX_ICON];
    }
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

}

- (UIViewController *)activityViewController
{
    return nil;
}

-(void) performActivity
{
    // post image status
    if (!Is_Weixin_Registered)
    {
        [WXApi registerApp:WEIXIN_API_APP_KEY];
        Is_Weixin_Registered=true;
    }
    [self onRequestAppMessage];
}

-(UIImage *)cropImage:(UIImage *)image {
    CGSize newSize = CGSizeMake(100, 100*image.size.height/image.size.width);
   
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma weixin api

-(void) onRequestAppMessage
{
    if (img )
    {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
    
        [message setThumbImage:[self cropImage:img]];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImagePNGRepresentation(img);
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        if (shareType == WXShareTypeFriend) {
            req.scene = WXSceneSession;
        }
        else{
            req.scene = WXSceneTimeline;
        }
        
        [WXApi sendReq:req];
        
    } else
    {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = title;
        if (shareType == WXShareTypeFriend) {
            req.scene = WXSceneSession;
        }
        else{
            req.scene = WXSceneTimeline;
        }
        
        [WXApi sendReq:req];
    }
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        [self activityDidFinish:resp.errCode==0?TRUE:FALSE];
    }
    else if([resp isKindOfClass:[PayResp class]]) {
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//
//    }

}
@end
