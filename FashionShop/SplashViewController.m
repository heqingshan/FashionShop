//
//  SplashViewController.m
//  WeiKaBao
//
//  Created by Dongyi on 12-9-19.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#define PAGES 4

#import "SplashViewController.h"
#import "FSAppDelegate.h"

@implementation SplashViewController
@synthesize isFromSettingPage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initScrollView];
	[self initPageControl];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1.0f;
    }];
}


- (void)initScrollView
{
    int sHeight = [UIApplication sharedApplication].statusBarHidden?0:20;
	//m_pagesView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, APP_HIGH + (IOS7?sHeight:0))];
    m_pagesView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, APP_HIGH)];
    m_pagesView.scrollEnabled = YES;
    m_pagesView.backgroundColor = [UIColor blackColor];
	m_pagesView.contentSize = CGSizeMake(320.0 * PAGES, APP_HIGH);
	m_pagesView.pagingEnabled = YES;
	m_pagesView.delegate = self;
	m_pagesView.autoresizesSubviews = YES;
    m_pagesView.bounces = YES;
    m_pagesView.showsHorizontalScrollIndicator = NO;
    m_pagesView.showsVerticalScrollIndicator = NO;
	
	for (int i = 1; i <= PAGES; i++) {
		NSString *filename = nil;
        if ([UIDevice isRunningOniPhone5]) {
            filename = [NSString stringWithFormat:@"Splash%d_5.jpg",i];
        }
        else{
            filename = [NSString stringWithFormat:@"Splash%d.jpg",i];
        }
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:filename]];
        //iv.frame = CGRectMake((i-1) * SCREEN_WIDTH, IOS7?sHeight:0, SCREEN_WIDTH, APP_HIGH);
        iv.frame = CGRectMake((i-1) * SCREEN_WIDTH, 0, SCREEN_WIDTH, APP_HIGH);
		[m_pagesView addSubview:iv];
	}
	[self.view addSubview:m_pagesView];
	[m_pagesView setNeedsDisplay];
}


- (void)initPageControl
{
    int yOffset = 425;
    if ([UIDevice isRunningOniPhone5]) {
        yOffset += IPHONE5_AddHEIGHT/2;
    }
	m_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(135.0, yOffset, 50.0, 20.0)];
	m_pageControl.numberOfPages = PAGES;
	m_pageControl.currentPage = 0;
	[m_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:m_pageControl];
}


- (void)initButton
{
	if (! m_entryButton) {
		m_entryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        m_entryButton.backgroundColor = [UIColor clearColor];
        
        int width = 75;
        m_entryButton.frame = CGRectMake(SCREEN_WIDTH*(PAGES-1)+(SCREEN_WIDTH-width), SCREEN_HIGH-width, width, width);
		[m_entryButton addTarget:self action:@selector(entry) forControlEvents:UIControlEventTouchUpInside];
		[m_pagesView addSubview:m_entryButton];
	}
}


#pragma mark UIScrollView delegate

- (void)pageTurn:(UIPageControl *)aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	m_pagesView.contentOffset = CGPointMake(320.0f * whichPage, 0.0f);
	[UIView commitAnimations];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	m_pageControl.currentPage = offset.x / 320.0f;
	if (m_pageControl.currentPage >=PAGES-1 ) {
		[self initButton];
	}

	NSLog(@"cuurent page :%d", m_pageControl.currentPage);
    
    if (aScrollView.contentSize.width - aScrollView.contentOffset.x < SCREEN_WIDTH - 40) {//滚动到了最末端
        [self entry];//须要放在主线程中执行。否则会在ios5系列系统中出错。
        /*
        if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"5"]) {
            [self entry];//必须要放在主线程中执行。否则会在ios5系列系统中出错。
        }
        else {
            [[theApp modelManager] enqueueBackgroundBlock:^{
                [self entry];
            }];
        }
         */
    }
}

- (void)entry
{
    if (isFromSettingPage) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [theApp entryMain];
        //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunched"];
        [theApp writeFile:@"hasLaunched" fileName:@"hasLaunched"];
        [self.view removeFromSuperview];
    }
}


@end

