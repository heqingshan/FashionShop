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

@interface FSOrderRMACommitViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *contentView;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *telephone;
@property (strong, nonatomic) IBOutlet UITextField *shipvia;
@property (strong, nonatomic) IBOutlet UITextField *shipviano;

@property (nonatomic,strong) id delegate;
@property (strong, nonatomic) FSOrderRMAItem *rmaData;
@property (nonatomic,strong) FSOrderRMAItem *orderRMAItem;

- (IBAction)requestRMA:(id)sender;

@end
