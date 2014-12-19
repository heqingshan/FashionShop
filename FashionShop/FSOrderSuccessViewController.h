//
//  FSOrderSuccessViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSOrder.h"
#import "FSPurchase.h"

@interface FSOrderSuccessViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic,strong) FSOrderInfo *data;
@property (nonatomic,strong) FSPurchaseSPaymentItem *payWay;

@end
