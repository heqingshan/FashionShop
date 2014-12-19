//
//  SplashViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-6.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

@interface SplashViewController : FSBaseViewController <UIScrollViewDelegate> {
	UIScrollView *m_pagesView;
	UIPageControl *m_pageControl;
    UIButton *m_entryButton;
}

@property (nonatomic,assign) BOOL isFromSettingPage;//是否来自设置页面

- (void)initScrollView;
- (void)initPageControl;
- (void)initButton;
- (void)entry;


@end
