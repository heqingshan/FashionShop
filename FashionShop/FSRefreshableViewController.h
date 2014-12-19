//
//  FSRefreshableViewController.h
//  FashionShop
//
//  Created by gong yi on 12/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface FSRefreshableViewController : FSBaseViewController<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

-(void) prepareRefreshLayout:(UIScrollView *)container withRefreshAction:(UICallBackWith1Param)action ;
-(void) beginLoadMoreLayout:(UIScrollView *)container;
-(void) endLoadMore:(UIScrollView *)container;
-(void) startRefresh:(id)view withCallback:(dispatch_block_t)callback;
-(void) beginLoadData:(UIScrollView *)container;
-(void) endLoadData:(UIScrollView *)container;

@property(nonatomic) BOOL isInRefresh;
@property(nonatomic) BOOL inLoading;
@property(nonatomic) BOOL showNoText;
@end
