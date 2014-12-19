//
//  FSPointGiftDetailViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPointGiftDetailViewController : FSBaseViewController<UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic) int requestID;

@end
