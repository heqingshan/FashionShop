//
//  FSImageBrowserView.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-20.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"

@interface FSImageBrowserView : UIView<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableArray *photos;

@end
