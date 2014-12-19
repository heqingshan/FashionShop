//
//  FSImageSlideViewController.m
//  FashionShop
//
//  Created by gong yi on 1/1/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSImageSlideViewController.h"
#import "UIImageView+WebCache.h"

@interface FSImageSlideViewController ()
{
    int curPage;
    CGFloat _pageGapWidth;
    NSMutableArray *_imageContains;
    NSMutableArray *_reusedImages;
    BOOL _showNavBar;
}
@end

@implementation FSImageSlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Picture Browse", nil);
    [self prepareLayout];
    [self presentData];
}
-(void) prepareLayout
{
    self.navigationItem.leftBarButtonItem = [self createPlainBarButtonItem:@"goback_icon" target:self action:@selector(close)];
    self.navigationItem.rightBarButtonItem = [self createPlainBarButtonItem:@"share_icon" target:self action:@selector(doShare)] ;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    _pageGapWidth = 0.0f;
    curPage = -1;
    _reusedImages = [@[] mutableCopy];
    _showNavBar = false;
    _imageContains = [@[] mutableCopy];
    _svContent.frame = self.view.frame;
    _svContent.backgroundColor = [UIColor blackColor];
    _svContent.showsHorizontalScrollIndicator = NO;
    _svContent.showsVerticalScrollIndicator = NO;
    [_svContent setScrollEnabled:TRUE];
    _svContent.directionalLockEnabled = YES;
    _svContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _svContent.delegate = self;

    NSArray *subViews = [_svContent subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i = 0; i < [_source numberOfImagesInSlides:self]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_svContent.frame];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
            action:@selector(handleTap:)];
        [imageView addGestureRecognizer:singleTap];
         //   imageView.frame = CGRectOffset(imageView.frame, _svContent.frame.size.width * i, 0);
        imageView.frame = CGRectOffset(imageView.frame, _svContent.frame.size.width * i, STATUSBAR_HIGH);
        [_imageContains addObject:imageView];
        [_svContent addSubview:imageView];
    }
    _svContent.contentSize =CGSizeMake(_svContent.frame.size.width*[_source numberOfImagesInSlides:self],_svContent.frame.size.height);

}
-(void)presentData
{
    [self setShowBar:TRUE];
    [self setCurrentPage:0];
}
-(void)close
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}
-(void)doShare
{
    [_source imageSlide:self didShareTap:TRUE];
}

-(void)loadImageForIndex:(int)index
{
    if ([_reusedImages containsObject:[NSNumber numberWithInt:index]])
        return;
    NSURL *imageUrl = [_source imageSlide:self imageNameForIndex:index];
    UIImageView *container = [_imageContains objectAtIndex:index ];
    [_reusedImages addObject:[NSNumber numberWithInt:index]];
    [container setImageWithURL:imageUrl];
}

- (CGFloat) offsetForPage:(NSInteger)page {
	CGFloat pageDelta = _svContent.bounds.size.width;
	return (page == 0) ? roundf(_pageGapWidth / 2.0f) : (pageDelta * page) + roundf(_pageGapWidth / 2.0f);
}

-(void)setCurrentPage:(int)pageIndex
{
   if (pageIndex==curPage)
       return;
    NSInteger numberOfPages = [_source numberOfImagesInSlides:self];
	if (pageIndex > numberOfPages-1) {
		pageIndex = numberOfPages-1;
	} else if (pageIndex < 0) {
		pageIndex = 0;
	}
    curPage = pageIndex;
    [self loadImageForIndex:curPage];
    CGFloat targetOffset = [self offsetForPage:curPage] - roundf(_pageGapWidth / 2.0f);
        if (_svContent.contentOffset.x != targetOffset) {
            [_svContent setContentOffset:CGPointMake(targetOffset, 0.0f) animated:TRUE];
        }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = _svContent.frame.size.width;
    int nextPage =floor((_svContent.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self setCurrentPage:nextPage];
    
}
-(void)setShowBar:(BOOL)show
{
    if (show)
    {
        
        [self.navigationController setNavigationBarHidden:TRUE animated:TRUE];
        _showNavBar = false;
    }
    else
    {
        [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
        _showNavBar = true;
    }
  
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    [self setShowBar:_showNavBar];
}
-(void)removeReusableImage
{
    for(int i=0;i<[_source numberOfImagesInSlides:self];i++)
    {
        if (i!=curPage)
        {
            UIImageView *imgview = [_imageContains objectAtIndex:i];
            imgview.image = nil;
            [_reusedImages removeObject:[NSNumber numberWithInt:i]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self removeReusableImage];
}

- (void)viewDidUnload {
    [self setSvContent:nil];
    [super viewDidUnload];
}
@end
