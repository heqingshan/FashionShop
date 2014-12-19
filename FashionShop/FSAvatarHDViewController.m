//
//  FSAvatarHDViewController.m
//  ImageCrip
//
//  Created by HeQingshan on 13-4-26.
//  Copyright (c) 2013年 HeQingshan. All rights reserved.
//

#import "FSAvatarHDViewController.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface FSAvatarHDViewController (){
    UIView *_viewBg;
    BOOL isShowHDImg;
    UITapGestureRecognizer *_recognizer;
    ImageDownloader *imageLoader;
}

@end

@implementation FSAvatarHDViewController
@synthesize avatarImgV = _avatarImgV;
@synthesize avatarImg = _avatarImg;
@synthesize beginRect;
@synthesize delegate;

-(id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        isShowHDImg = NO;
        self.view.backgroundColor = [UIColor clearColor];
        
        _viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGH)];
        [self.view addSubview:_viewBg];
        [self.view sendSubviewToBack:_viewBg];
        _viewBg.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _avatarImgV = [[UIImageView alloc]init];
    [self.view addSubview:_avatarImgV];
    [_avatarImgV.layer setMasksToBounds:YES];
    _avatarImgV.layer.cornerRadius = 10;
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enterAnimation];
}

#pragma mark -
#pragma mark set
- (void)setAvatarImg:(UIImage *)img{
    _avatarImg = img;
    [_avatarImgV setImage:self.avatarImg];
}

- (void)setBeginRect:(CGRect)rect{
    beginRect = rect;
    _avatarImgV.frame = self.beginRect;
}

- (void)enterAnimation{
   [UIView animateWithDuration:0.3 animations:^{
         _avatarImgV.frame = CGRectMake(0, (SCREEN_HIGH - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH);
     }completion:^(BOOL finished){
         if (finished) {
             //添加手势
             if (!_recognizer) {
                _recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromDownToUp)];
            }
            [_recognizer setNumberOfTapsRequired:1];
            [_recognizer setNumberOfTouchesRequired:1];
            [self.view addGestureRecognizer:_recognizer];
        }
    }];
}

- (void)exitAnimation {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(hiddenHDUserImg:)]) {
        [self.delegate hiddenHDUserImg:self];
    }
}

- (void)handleSwipeFromDownToUp{
    //移除手势
    for (UITapGestureRecognizer* recognizer in self.view.gestureRecognizers) {
         if (recognizer==_recognizer) {
            [self.view removeGestureRecognizer:recognizer];
         }
     }
    [self exitAnimation];
}

-(void)setImageURL:(NSURL *)imageURL
{
    imageLoader = [[ImageDownloader alloc] init];
    imageLoader.delegate = self;
    [imageLoader startDownload:imageURL.absoluteString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImageDownloaderDelegate

- (void)imageDidFishLoad:(NSData *)dataImage
{
    UIImage *image = [UIImage imageWithData:dataImage];
    if (image) {
        _avatarImgV.image = image;
    }
}

@end
