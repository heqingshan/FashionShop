//
//  FSCommonTextShowViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPurchase.h"

@interface FSCommonTextShowViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (strong, nonatomic) FSPurchase *purchase;
@property (strong, nonatomic) NSString *myTitle;

@end
