//
//  FSPointViewController.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"
#import "FSRefreshableViewController.h"

@interface FSPointViewController : FSRefreshableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *contentView;

@property (strong,nonatomic) FSUser *currentUser;

@end
