//
//  FSImageSlideViewController.h
//  FashionShop
//
//  Created by gong yi on 1/1/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@class FSImageSlideViewController;

@protocol FSImageSlideDataSource <NSObject>

-(int)numberOfImagesInSlides:(FSImageSlideViewController *)view;
-(NSURL *)imageSlide:(FSImageSlideViewController *)view imageNameForIndex:(int)index;

-(void)imageSlide:(FSImageSlideViewController *)view didShareTap:(BOOL)shared;

@end
@interface FSImageSlideViewController : FSBaseViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *svContent;
@property (nonatomic) id<FSImageSlideDataSource> source;

@end
