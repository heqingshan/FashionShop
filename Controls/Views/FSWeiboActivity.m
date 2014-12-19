//
//  FSWeiboActivity.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSWeiboActivity.h"
#import "SinaWeibo.h"
#import "FSModelManager.h"
#import "FSShareView.h"

@interface FSWeiboActivity()
{
    SinaWeibo *_weibo;
}


@end

@implementation FSWeiboActivity

@synthesize title,img;

- (NSString *)activityType {
    return @"UIActivityFSPostToWeibo";
}

- (NSString *)activityTitle {
    return SHARE_WB_TITLE;
}

- (UIImage *)activityImage {
    return [UIImage imageNamed:SHARE_WB_ICON];
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
    if (_weibo==nil)
    {
        _weibo = [[FSModelManager sharedModelManager] instantiateWeiboClient:self];
        
    }
    UIViewController *controller = [_weibo logInWithController];
    return controller;
  
}

-(void) performActivity
{
    
    
}


#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    if (img)
    {
        [_weibo requestWithURL:@"statuses/upload.json"
                           params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   title, @"status",
                                   img, @"pic", nil]
                       httpMethod:@"POST"
                         delegate:self];
    }
    else
    {
        [_weibo requestWithURL:@"statuses/update.json"
                    params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                            title, @"status",nil]
                httpMethod:@"POST"
                  delegate:self];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [[FSModelManager sharedModelManager] removeWeiboAuthCache];
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
   }

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    [[FSModelManager sharedModelManager] removeWeiboAuthCache];

}


#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [self activityDidFinish:FALSE];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
  if ([request.url hasSuffix:@"statuses/update.json"] ||
      [request.url hasSuffix:@"statuses/upload.json"])
  {
        [self activityDidFinish:YES];
  }
    
    
    
}

@end
