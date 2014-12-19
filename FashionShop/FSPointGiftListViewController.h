//
//  FSPointGiftListViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKSegmentedControl.h"
#import "FSRefreshableViewController.h"
#import "FSUser.h"

@interface FSPointGiftListViewController : FSRefreshableViewController<AKSegmentedControlDelegate>

@property (strong, nonatomic) IBOutlet UITableView *contentView;
@property (strong, nonatomic) IBOutlet AKSegmentedControl *segFilters;
@property (strong,nonatomic) FSUser *currentUser;

@end
