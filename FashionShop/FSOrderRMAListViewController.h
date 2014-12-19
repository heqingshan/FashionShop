//
//  FSOrderRMAListViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSOrder.h"

@interface FSOrderRMAListViewController : FSBaseViewController
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic,strong) FSOrderInfo *data;

@end
