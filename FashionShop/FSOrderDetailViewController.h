//
//  FSOrderDetailViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProDetailViewController.h"

@protocol FSOrderRMARequestViewControllerDelegate;
@protocol FSOrderRMACommitViewControllerDelegate;

@interface FSOrderDetailViewController : FSBaseViewController<FSProDetailItemSourceProvider>

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic,strong) NSString *orderno;

@end
