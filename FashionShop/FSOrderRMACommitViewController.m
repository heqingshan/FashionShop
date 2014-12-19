//
//  FSOrderRMARequestViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderRMACommitViewController.h"
#import "FSPurchaseRequest.h"
#import "NSString+Extention.h"
#import "FSOrderRMASuccessViewController.h"
#import "FSOrderRMARequestViewController.h"

@interface FSOrderRMACommitViewController ()
{
    id activityField;
    UIColor *fieldTextColor;
    UIColor *redColor;
}

@end

@implementation FSOrderRMACommitViewController

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
    self.title = @"在线退货";
    [self initControlData];
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];

    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
    
    redColor = [UIColor redColor];
    fieldTextColor = _userName.textColor;
}

- (void)initControlData
{
    if (!_rmaData) {
        return;
    }
}

- (void)viewDidUnload {
    [self setContentView:nil];
    [self setUserName:nil];
    [self setTelephone:nil];
    [self setShipvia:nil];
    [self setShipviano:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)check
{
    BOOL flag = YES;
    {
        //判断是否合理
        //联系人
        if (_userName.text.length <= 0) {
            _userName.text = _shipvia.placeholder;
            _userName.textColor = redColor;
            
            flag = NO;
        }
        else {
            if ([_userName.textColor isEqual:redColor]) {
                flag = NO;
            }
        }
        
        //手机号码
        if (_telephone.text.length <= 0) {
            _telephone.text = _telephone.placeholder;
            _telephone.textColor = redColor;
            flag = NO;
        }
        else {
            BOOL tempFlag = YES;
            if ([_telephone.textColor isEqual:redColor]) {
                flag = NO;
                tempFlag = NO;
            }
            if (tempFlag && ![NSString isMobileNum:_telephone.text]) {
                _telephone.text = @"请输入正确的联系方式";
                _telephone.textColor = redColor;
                
                flag = NO;
            }
        }
        if (_telephone.text.length > 0) {
            BOOL tempFlag = YES;
            if ([_telephone.textColor isEqual:redColor]) {
                flag = NO;
                tempFlag = NO;
            }
            if (tempFlag && ![NSString isPhoneNum:_telephone.text]) {
                _telephone.text = @"请输入正确的联系方式";
                _telephone.textColor = redColor;
                
                flag = NO;
            }
        }
        
        //物流名称
        if (_shipvia.text.length <= 0) {
            _shipvia.text = _shipvia.placeholder;
            _shipvia.textColor = redColor;
            flag = NO;
        }
        else {
            if ([_shipvia.textColor isEqual:redColor]) {
                flag = NO;
            }
        }
        
        //物流单号
        if (_shipviano.text.length <= 0) {
            _shipviano.text = _shipviano.placeholder;
            _shipviano.textColor = redColor;
        }
        else {
            if ([_shipviano.textColor isEqual:redColor]) {
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
        [msg appendFormat:@"联系人 : %@\n", _userName.text];
        [msg appendFormat:@"电话号码 : %@\n", _telephone.text];
        [msg appendFormat:@"退货物流名称 : %@\n", _shipvia.text];
        [msg appendFormat:@"退货物流单号 : %@\n", _shipviano.text];
        
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
    if (textField == _userName) {
        [_telephone becomeFirstResponder];
    }
    else if(textField == _telephone) {
        [_shipvia becomeFirstResponder];
    }
    else if(textField == _shipvia) {
        [_shipviano becomeFirstResponder];
    }
    else if(textField == _shipviano){
        [self requestRMA:nil];
    }
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
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_ORDER_RMA_UPDATE;
        request.username = _userName.text;
        request.contactphone = _telephone.text;
        request.shipvia = _shipvia.text;
        request.shipviano = _shipviano.text;
        request.contactphone = _telephone.text;
        request.rmano = _orderRMAItem.rmano;
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
                controller.title = @"在线申请退货成功";
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
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:6];
            [_dic setValue:[NSString stringWithFormat:@"%@", _orderRMAItem.rmano] forKey:@"退货单号"];
            [_dic setValue:(respData.isSuccess?@"退货成功":@"退货失败") forKey:@"退货状态"];
            [_dic setValue:_userName.text forKey:@"联系人"];
            [_dic setValue:_telephone.text forKey:@"联系电话"];
            [_dic setValue:_shipvia.text forKey:@"物流名称"];
            [_dic setValue:_shipviano.text forKey:@"物流单号"];
            [[FSAnalysis instance] logEvent:ORDER_RMA_CONFIRM withParameters:_dic];
        }];
    }
}

@end
