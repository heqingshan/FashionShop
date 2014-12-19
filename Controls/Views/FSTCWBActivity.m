//
//  FSTCWBActivity.m
//  FashionShop
//
//  Created by gong yi on 11/29/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSTCWBActivity.h"
#import "TCWBEngine.h"
#import "FSShareView.h"

@implementation FSTCWBActivity
{
    TCWBEngine *_qq;
}



@synthesize title,img;

- (NSString *)activityType {
    return @"UIActivityFSPostToTCWB";
}

- (NSString *)activityTitle {
    return SHARE_TC_TITLE;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:SHARE_TC_ICON];
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
    
    // post image status
    if (_qq==nil)
    {
        _qq = [[TCWBEngine alloc] initWithAppKey:QQ_WEIBO_APP_KEY andSecret:QQ_WEIBO_APP_SECRET_KEY andRedirectUrl:QQ_WEIBO_APP_REDIRECT_URI];

    }
    return [_qq logInWithDelegateReturnView:self onSuccess:@selector(onQQLoginSuccess) onFailure:@selector(onQQLoginFail:)];
    
}

-(void) performActivity
{
        
    
}
#pragma QQ delegate

-(void) onQQLoginSuccess
{
    if (img)
    {
        NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
        [_qq postPictureTweetWithFormat:@"json" content:title clientIP:_qq.ip_iphone pic:imgData compatibleFlag:@"0" longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(onQQPostSuccess:) onFailure:@selector(onQQPostFail:)];
    }
    else
    {
        [_qq postTextTweetWithFormat:@"json" content:title clientIP:_qq.ip_iphone longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(onQQPostSuccess:) onFailure:@selector(onQQPostFail:)];
    }
}

-(void) onQQLoginFail:(NSError *)error
{
    [self activityDidFinish:false];
}

-(void) onQQPostSuccess:(id)result
{
    [self activityDidFinish:true];
}

-(void) onQQPostFail:(NSError *)error
{
    [self activityDidFinish:false];
}
@end
