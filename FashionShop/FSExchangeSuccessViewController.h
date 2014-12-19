//
//  FSExchangeSuccessViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSExchange.h"

@interface FSExchangeSuccessViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic, strong) FSExchangeSuccess *data;

@end
