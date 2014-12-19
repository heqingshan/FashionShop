//
//  FSImageBrowserView.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-20.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSImageBrowserView.h"
#import "FSResource.h"
#import "UIImageView+WebCache.h"

@implementation FSImageBrowserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

-(void)initControl
{
    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor blackColor];
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

-(void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    [_scrollView setContentSize:CGSizeMake(320 * _photos.count, self.frame.size.height)];
    
    for (int i = 0; i < _photos.count; i++) {
        FSResource *pic = _photos[i];
        MRZoomScrollView *_zoomScrollView = [[MRZoomScrollView alloc]init];
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        _zoomScrollView.frame = frame;
        CGSize cropSize = CGSizeMake(_zoomScrollView.imageView.frame.size.width, _zoomScrollView.imageView.frame.size.height );
        [_zoomScrollView.imageView setImageUrl:pic.absoluteUrl320 resizeWidth:cropSize placeholderImage:[UIImage imageNamed:@"default_icon320.png"]];
        [self.scrollView addSubview:_zoomScrollView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
