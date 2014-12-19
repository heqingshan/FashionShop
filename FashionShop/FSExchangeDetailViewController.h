//
//  FSExchangeDetailViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface FSExchangeDetailViewController : FSBaseViewController<RTLabelDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic) int requestID;

@end
