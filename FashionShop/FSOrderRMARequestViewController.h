//
//  FSOrderRMARequestViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPlaceHoldTextView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FSOrder.h"
#import "FSMyPickerView.h"

@interface FSOrderRMARequestViewController : FSBaseViewController<FSMyPickerViewDatasource,FSMyPickerViewDelegate>

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *contentView;
@property (strong, nonatomic) IBOutlet FSPlaceHoldTextView *reason;
@property (strong, nonatomic) IBOutlet UITextField *rmaCount;
@property (strong, nonatomic) IBOutlet UITextField *reasonCode;

@property (strong, nonatomic) FSOrderRMAItem *rmaData;
@property (nonatomic,strong) FSOrderInfo *orderinfo;

- (IBAction)requestRMA:(id)sender;
- (IBAction)selectReason:(id)sender;

@property (nonatomic,strong) id delegate;

@end

@interface NSObject(FSOrderRMARequestViewControllerDelegate)
-(void)refreshViewController:(UIViewController*)controller needRefresh:(BOOL)flag;
@end
