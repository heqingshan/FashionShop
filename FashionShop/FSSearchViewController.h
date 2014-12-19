//
//  FSSearchViewController.h
//  FashionShop
//
//  Created by gong yi on 1/6/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSBrand.h"
#import "SpringboardLayout.h"
#import "FSProDetailViewController.h"
#import "FSRefreshableViewController.h"

@interface FSSearchViewController : FSRefreshableViewController<PSUICollectionViewDataSource,PSUICollectionViewDelegateFlowLayout,SpringboardLayoutDelegate,FSProDetailItemSourceProvider>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) int searchTag;

@end
