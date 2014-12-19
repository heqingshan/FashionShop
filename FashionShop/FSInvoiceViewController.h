//
//  FSInvoiceViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "FSMyPickerView.h"
#import "FSPurchase.h"

@interface FSInvoiceViewController : FSBaseViewController<UITextFieldDelegate,FSMyPickerViewDatasource,FSMyPickerViewDelegate>

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *contentView;
@property (strong, nonatomic) IBOutlet UITextField *invoiceTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbCompanyName;
@property (strong, nonatomic) IBOutlet UITextField *companyName;
@property (strong, nonatomic) IBOutlet UITextField *invoiceDetail;
@property (strong, nonatomic) IBOutlet UILabel *lbDetail;
@property (strong, nonatomic) IBOutlet UIButton *detailBtn;

@property (nonatomic,strong) FSPurchase *data;
@property (nonatomic,strong) FSPurchaseForUpload *uploadData;
@property (nonatomic,strong) id delegate;

- (IBAction)clickToSelectTitle:(id)sender;
- (IBAction)clickToSelDetail:(id)sender;

@end

@interface NSObject(FSInvoiceViewControllerDelegate)
-(void)completeInvoiceInput:(FSInvoiceViewController*)viewController;
@end
