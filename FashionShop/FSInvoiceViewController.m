//
//  FSInvoiceViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSInvoiceViewController.h"
#import "NSString+Extention.h"
#import "FSPurchaseRequest.h"
#import "FSCommon.h"

@interface FSInvoiceViewController () {
    id activityField;
    FSMyPickerView *titlePickerView;
    FSMyPickerView *detailPickerView;
}

@end

@implementation FSInvoiceViewController

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
    self.title = @"填写发票信息";
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self addRightButton:@"保存"];
    
    _contentView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
    
    //请求发票明细数据
    if (![theApp allInvoiceDetails]) {
        [self requestInvoiceDetail];
    }
    else {
        [self initControl];
    }
}

-(void)initControl
{
    [self updateFrame:_uploadData.isCompany];
    [_invoiceTitle setText:(_uploadData.isCompany?@"公司":@"个人")];
    _companyName.text = _uploadData.invoicetitle;
    _invoiceDetail.text = _uploadData.invoicedetail;
}

- (void)requestInvoiceDetail
{
    FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_INVOICE_DETAIL;
    request.rootKeyPath = @"data.items";
    [self beginLoading:self.view];
    [request send:[FSCommonItem class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        [self endLoading:self.view];
        if (respData.isSuccess)
        {
            FSAppDelegate *del = theApp;
            del.allInvoiceDetails = respData.responseData;
            [self initControl];
        }
        else
        {
            [self reportError:respData.errorDescrip];
        }
    }];
}

-(void)addRightButton:(NSString*)title
{
    UIImage *btnNormal = [[UIImage imageNamed:@"btn_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setTitle:title forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(saveInvoice:) forControlEvents:UIControlEventTouchUpInside];
    sheepButton.titleLabel.font = ME_FONT(13);
    sheepButton.showsTouchWhenHighlighted = YES;
    [sheepButton setBackgroundImage:btnNormal forState:UIControlStateNormal];
    [sheepButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
    [self.navigationItem setRightBarButtonItem:item];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveInvoice:(UIButton*)sender
{
    if ([NSString isNilOrEmpty:_companyName.text] && _uploadData.isCompany) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入公司名称" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [_companyName becomeFirstResponder];
        return;
    }
    if ([NSString isNilOrEmpty:_invoiceDetail.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择发票备注" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [_invoiceDetail becomeFirstResponder];
        return;
    }
    [activityField resignFirstResponder];
    [self reportError:@"保存成功"];
    [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0f];
    if (_delegate && [_delegate respondsToSelector:@selector(completeInvoiceInput:)]) {
        [_delegate completeInvoiceInput:self];
    }
}

- (void)viewDidUnload {
    [self setInvoiceTitle:nil];
    [self setInvoiceDetail:nil];
    [self setContentView:nil];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activityField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _invoiceDetail) {
        [self saveInvoice:nil];
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)clickToSelectTitle:(id)sender {
    if (!titlePickerView) {
        titlePickerView = [[FSMyPickerView alloc] init];
        titlePickerView.delegate = self;
        titlePickerView.datasource = self;
    }
    //初始化选中项
    int index = _uploadData.isCompany?1:0;
    [titlePickerView.picker selectRow:index inComponent:0 animated:NO];
    [titlePickerView showPickerView:^{
        [activityField resignFirstResponder];
    }];
}

- (IBAction)clickToSelDetail:(id)sender {
    if (!detailPickerView) {
        detailPickerView = [[FSMyPickerView alloc] init];
        detailPickerView.delegate = self;
        detailPickerView.datasource = self;
    }
    //初始化选中项
    FSAppDelegate *del = theApp;
    int index = 0;
    for (int i = 0; i < del.allInvoiceDetails.count; i++) {
        FSCommonItem *item = del.allInvoiceDetails[i];
        if ([item.name isEqualToString:_uploadData.invoicedetail]) {
            index = i;
            break;
        }
    }
    [detailPickerView.picker selectRow:index inComponent:0 animated:NO];
    [detailPickerView showPickerView:^{
        [activityField resignFirstResponder];
    }];
}

-(void)updateFrame:(BOOL)isCompany
{
    _lbCompanyName.hidden = !isCompany;
    _companyName.hidden = !isCompany;
    int yOffset = 87;
    int yHeight = 8;
    CGRect _rect;
    
    if (isCompany) {
        _rect = _lbCompanyName.frame;
        _rect.origin.y = yOffset;
        _lbCompanyName.frame = _rect;
        yOffset += _lbCompanyName.frame.size.height + yHeight;
        
        _rect = _companyName.frame;
        _rect.origin.y = yOffset;
        _companyName.frame = _rect;
        yOffset += _companyName.frame.size.height + yHeight;
    }
    
    _rect = _lbDetail.frame;
    _rect.origin.y = yOffset;
    _lbDetail.frame = _rect;
    yOffset += _lbDetail.frame.size.height + yHeight;
    
    _rect = _invoiceDetail.frame;
    _rect.origin.y = yOffset;
    _invoiceDetail.frame = _rect;
    
    _rect = _detailBtn.frame;
    _rect.origin.y = yOffset;
    _detailBtn.frame = _rect;
    yOffset += _detailBtn.frame.size.height + yHeight;
}

#pragma mark - FSMyPickerViewDatasource

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView
{
    if (pickerView == titlePickerView) {
        return 1;
    }
    else if (pickerView == detailPickerView) {
        return 1;
    }
    return 0;
}

- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == titlePickerView) {
        return 2;
    }
    else if(pickerView == detailPickerView) {
        return [[theApp allInvoiceDetails] count];
    }
    return 0;
}

#pragma mark - FSMyPickerViewDelegate

- (void)didClickOkButton:(FSMyPickerView *)aMyPickerView
{
    if (aMyPickerView == titlePickerView) {
        int index = [aMyPickerView.picker selectedRowInComponent:0];
        _uploadData.isCompany = (index==0?NO:YES);
        [self updateFrame:_uploadData.isCompany];
        [_invoiceTitle setText:(_uploadData.isCompany?@"公司":@"个人")];
    }
    else if (aMyPickerView == detailPickerView) {
        int index = [aMyPickerView.picker selectedRowInComponent:0];
        FSAppDelegate *del = theApp;
        FSCommonItem *item = del.allInvoiceDetails[index];
        _uploadData.invoicedetail = item.name;
        [_invoiceDetail setText:item.name];
    }
}

- (NSString *)myPickerView:(FSMyPickerView *)aMyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (aMyPickerView == titlePickerView) {
        if (row == 0) {
            return @"个人";
        }
        else {
            return @"公司";
        }
    }
    else if(aMyPickerView == detailPickerView) {
        FSAppDelegate *del = theApp;
        FSCommonItem *item = del.allInvoiceDetails[row];
        return item.name;
    }
    return @"";
}

@end
