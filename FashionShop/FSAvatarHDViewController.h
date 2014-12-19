//
//  AvatarHDViewController.h
//  ImageCrip
//
//  Created by HeQingshan on 13-4-26.
//  Copyright (c) 2013年 HeQingshan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@class FSAvatarHDViewController;
@protocol FSAvatarHDViewDelegate <NSObject>

-(void)hiddenHDUserImg:(FSAvatarHDViewController*)controller;

@end

@interface FSAvatarHDViewController : FSBaseViewController<ImageDownloaderDelegate>

@property (nonatomic,strong) UIImageView *avatarImgV;
@property (nonatomic,strong) UIImage *avatarImg;
@property (nonatomic) CGRect beginRect;
@property (nonatomic) id<FSAvatarHDViewDelegate> delegate;

-(void)setImageURL:(NSURL *)imageURL;

@end
