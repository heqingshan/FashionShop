//
//  FSAddressDetailViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPlaceHoldTextView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface FSAddressDetailViewController : FSBaseViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate> {
    FSAddressDetailState pageState;
}

@property (nonatomic) int addressID;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *contentView;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *telephone;
@property (strong, nonatomic) IBOutlet UITextField *address;
@property (strong, nonatomic) IBOutlet FSPlaceHoldTextView *addressDetail;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic) FSAddressDetailState pageState;

- (IBAction)selectAddress:(id)sender;
- (IBAction)deleteAddress:(id)sender;

@end
