//
//  FSOrderListViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKSegmentedControl.h"
#import "FSUser.h"
#import "FSRefreshableViewController.h"

@interface FSOrderListViewController : FSRefreshableViewController<AKSegmentedControlDelegate>

@property (strong, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) IBOutlet AKSegmentedControl *segFilters;

@end
