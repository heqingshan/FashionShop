//
//  FSOrderRMARequestViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderRMARequestViewController.h"
#import "FSPurchaseRequest.h"
#import "NSString+Extention.h"
#import "FSOrderRMASuccessViewController.h"
#import "JSONKit.h"
#import "FSCommonRequest.h"
#import "FSCommon.h"

@interface FSOrderRMARequestViewController ()
{
    id activityField;
    UIColor *fieldTextColor;
    UIColor *redColor;
    NSArray *reasons; //退货理由
    FSMyPickerView *reasonPickerView;
    int selectedIndex;
}

@end

@implementation FSOrderRMARequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"申请在线退货";
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _reason.layer.borderWidth = 2;
    _reason.layer.cornerRadius = 10;
    _reason.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _reason.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _reason.layer.shadowOffset = CGSizeMake(3, 3);
    _reason.placeholder = @"请输入您申请退货的具体原因";
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
    
    redColor = [UIColor redColor];
    fieldTextColor = _rmaCount.textColor;
    
    [self requestReasons];
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setRmaCount:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

-(void)requestReasons
{
    if (reasons) {
        return;
    }
    FSCommonRequest *request = [[FSCommonRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_SUPPORT_RMAREASONS;
    request.rootKeyPath = @"data.items";
    [self beginLoading:self.view];
    [request send:[FSEnRMAReasonItem class] withRequest:request completeCallBack:^(FSEntityBase *req) {
        if (req.isSuccess) {
            reasons = req.responseData;
            if (reasons.count > 0) {
                selectedIndex = 0;
            }
        }
        else{
            reasons = nil;
        }
        [self endLoading:self.view];
    }];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)check
{
    BOOL flag = YES;
    {
        //判断是否合理
        //银行名称
        if (_rmaCount.text.length <= 0) {
            _rmaCount.text = @"请输入退货件数";
            _rmaCount.textColor = redColor;
            
            flag = NO;
        }
        else {
            if ([_rmaCount.textColor isEqual:redColor]) {
                flag = NO;
            }
        }
    }
    return flag;
}

- (IBAction)requestRMA:(id)sender {
    if ([self check]) {
        //退货预览
        NSMutableString *msg = [NSMutableString stringWithString:@""];
        FSEnRMAReasonItem *item = reasons[selectedIndex];
        [msg appendFormat:@"退货原因 : %@-%@\n",item.reason, _reason.text];
        [msg appendFormat:@"退货件数 : %@件\n", _rmaCount.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        
        //左对齐
        for(UIView *subview in alert.subviews)
        {
            if([[subview class] isSubclassOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel*)subview;
                if([label.text isEqualToString:msg])
                    label.textAlignment = UITextAlignmentLeft;
            }
        }
        [alert show];
    }
}

- (IBAction)selectReason:(id)sender {
    //退货原因
    if (!reasonPickerView) {
        reasonPickerView = [[FSMyPickerView alloc] init];
        reasonPickerView.delegate = self;
        reasonPickerView.datasource = self;
    }
    //初始化选中项
    if (reasons.count > 0) {
        [reasonPickerView.picker selectRow:selectedIndex inComponent:0 animated:NO];
    }
    [reasonPickerView showPickerView:^{
        [activityField resignFirstResponder];
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0 && [textField.textColor isEqual:redColor]) {
        textField.text = @"";
        textField.textColor = fieldTextColor;
    }
    activityField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length > 0 && [textView.textColor isEqual:redColor]) {
        textView.text = @"";
        textView.textColor = fieldTextColor;
    }
    activityField = textView;
    [reasonPickerView hidenPickerView:YES action:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_ORDER_RMA;
        request.reason = _reason.text;
        FSEnRMAReasonItem *item = reasons[selectedIndex];
        request.rmareason = item.key;
        if (_orderinfo.products.count > 0) {
            FSOrderProduct *item = _orderinfo.products[0];
            item.quantity = [_rmaCount.text intValue];
            {
                NSMutableArray *array = [NSMutableArray array];
                for (int i = 0; i < _orderinfo.products.count; i++) {
                    FSOrderProduct *item = _orderinfo.products[i];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:item.productid forKey:@"productid"];
                    [dic setValue:item.productdesc forKey:@"desc"];
                    [dic setValue:[NSString stringWithFormat:@"%d", item.quantity] forKey:@"quantity"];
                    NSMutableDictionary *_dic = [NSMutableDictionary dictionary];
                    [_dic setValue:item.colorvalue forKey:@"colorvaluename"];
                    [_dic setValue:item.colorvalueid forKey:@"colorvalueid"];
                    [_dic setValue:item.sizevalue forKey:@"sizevaluename"];
                    [_dic setValue:item.sizevalueid forKey:@"sizevalueid"];
                    [dic setValue:_dic forKey:@"properties"];
                    [array addObject:dic];
                }
                NSString *products = [array JSONString];
                request.products = products;
            }
            
        }
        request.orderno = _orderinfo.orderno;
        request.uToken = [[FSModelManager sharedModelManager] loginToken];
        [self beginLoading:self.view];
        [activityField resignFirstResponder];
        [request send:[FSOrderRMAItem class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
            [self endLoading:self.view];
            if (respData.isSuccess)
            {
                FSOrderRMAItem *rmaData = respData.responseData;
                FSOrderRMASuccessViewController *controller = [[FSOrderRMASuccessViewController alloc] initWithNibName:@"FSOrderRMASuccessViewController" bundle:nil];
                controller.data = rmaData;
                controller.title = @"申请退货成功";
                [self.navigationController pushViewController:controller animated:YES];
                if (_delegate && [_delegate respondsToSelector:@selector(refreshViewController:needRefresh:)]) {
                    [_delegate refreshViewController:self needRefresh:YES];
                }
            }
            else
            {
                [self reportError:respData.errorDescrip];
            }
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:7];
            [_dic setValue:[NSString stringWithFormat:@"%@", _orderinfo.orderno] forKey:@"订单号"];
            [_dic setValue:(respData.isSuccess?@"申请退货成功":@"申请退货失败") forKey:@"申请退货状态"];
            [_dic setValue:_reason.text forKey:@"退货原因"];
            [_dic setValue:_rmaCount.text forKey:@"退货件数"];
            [[FSAnalysis instance] logEvent:ORDER_RMA withParameters:_dic];
        }];
    }
}

#pragma mark - FSMyPickerViewDatasource

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView
{
    if (pickerView == reasonPickerView) {
        return 1;
    }
    return 0;
}

- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == reasonPickerView) {
        return reasons.count;
    }
    return 0;
}

#pragma mark - FSMyPickerViewDelegate

- (void)didClickOkButton:(FSMyPickerView *)aMyPickerView
{
    if (aMyPickerView == reasonPickerView) {
        int index = [aMyPickerView.picker selectedRowInComponent:0];
        if (index < reasons.count) {
            selectedIndex = index;
            FSEnRMAReasonItem *item = reasons[index];
            _reasonCode.text = item.reason;
        }
    }
}

- (NSString *)myPickerView:(FSMyPickerView *)aMyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    FSEnRMAReasonItem *item = reasons[row];
    return item.reason;
}

@end
