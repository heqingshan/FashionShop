//
//  FSCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSCycleScrollViewDelegate;
@protocol FSCycleScrollViewDatasource;

@interface FSCycleScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<FSCycleScrollViewDelegate> _delegate;
    id<FSCycleScrollViewDatasource> _datasource;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
    NSTimer*    pageTimer;    //切换焦点图的定时器
}

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<FSCycleScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<FSCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol FSCycleScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(FSCycleScrollView *)csView atIndex:(NSInteger)index;

@end

@protocol FSCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
