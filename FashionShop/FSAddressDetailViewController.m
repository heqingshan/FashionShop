//
//  FSAddressDetailViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAddressDetailViewController.h"
#import "FSAddressRequest.h"
#import "FSUser.h"
#import "FSAddress.h"
#import "NSString+Extention.h"

@interface FSAddressDetailViewController ()
{
    BOOL _inLoading;
    
    UIView *pickerView;
    UIPickerView *_picker;
    BOOL pickerIsShow;  //当前picker是否显示
    int tableYOffset;
    
    int firstRow;
    int secondRow;
    int thirdRow;
    
    id activityField;
    UIColor *fieldTextColor;
    UIColor *redColor;
}

@end

@implementation FSAddressDetailViewController
@synthesize pageState = pageState;

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
    self.title = @"修改地址";
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _addressDetail.layer.borderWidth = 2;
    _addressDetail.layer.cornerRadius = 10;
    _addressDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _addressDetail.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _addressDetail.layer.shadowOffset = CGSizeMake(3, 3);
    _addressDetail.placeholder = NSLocalizedString(@"Address Detail Place Holder", nil);
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    self.view.backgroundColor = APP_TABLE_BG_COLOR;
    redColor = [UIColor redColor];
    
    fieldTextColor = _name.textColor;
    
    //如果是展示，则请求地址详情
    if (pageState == FSAddressDetailStateShow) {
        FSAddressRequest *request = [[FSAddressRequest alloc] init];
        FSUser *currentUser = [FSUser localProfile];
        request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
        request.id = _addressID;
        request.routeResourcePath = REQUEST_ADDRESS_DETAIL;
        _inLoading = YES;
        [request send:[FSAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            if (resp.isSuccess)
            {
                FSAddress *address = (FSAddress*)resp.responseData;
                //填充数据
                _name.text = address.shippingperson;
                _telephone.text = address.shippingphone;
                _address.text = [NSString stringWithFormat:@"%@%@%@", address.shippingprovince,address.shippingcity,address.shippingdistrict];
                _addressDetail.text = address.shippingaddress;
                _zipCode.text = address.shippingzipcode;
                
                [self initPickerRows:address];
            }
            else
            {
                [self reportError:resp.errorDescrip];
                //2秒钟后返回上一级页面
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:2.0];
            }
        }];
    }
    [self changePageState:pageState];
    if (!theApp.allAddress) {
        [self requestAddressDatabase];
    }
    else{
        [self initPickerView];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenPickerView:YES];
}

-(void)requestAddressDatabase
{
    //同步请求地址数据库列表
    FSAddressRequest *request = [[FSAddressRequest alloc] init];
    FSUser *currentUser = [FSUser localProfile];
    request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
    request.routeResourcePath = REQUEST_ADDRESS_SUPORT_LIST;
    request.rootKeyPath = @"data.items";
    [self beginLoading:self.view];
    _inLoading = YES;
    [request send:[FSAddressDB class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:self.view];
        _inLoading = NO;
        if (resp.isSuccess)
        {
            //填充数据
            theApp.allAddress = resp.responseData;
            [self initPickerView];
        }
        else
        {
            [self reportError:resp.errorDescrip];
            //2秒钟后返回上一级页面
            [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:2.0];
        }
    }];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showRightButton:(NSString*)title
{
    UIImage *btnNormal = [[UIImage imageNamed:@"btn_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setTitle:title forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    sheepButton.titleLabel.font = ME_FONT(13);
    sheepButton.showsTouchWhenHighlighted = YES;
    [sheepButton setBackgroundImage:btnNormal forState:UIControlStateNormal];
    [sheepButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)clickRightButton:(UIButton*)sender
{
    if (_inLoading) {
        return;
    }
    if (pageState == FSAddressDetailStateShow) {
        [self changePageState:FSAddressDetailStateEdit];
    }
    else if (pageState == FSAddressDetailStateEdit) {
        //保存修改内容
        [self edit];
    }
    else if (pageState == FSAddressDetailStateNew) {
        //保存新建地址
        [self save];
    }
}

-(void)save
{
    NSString *error = nil;
    if ([self check:&error]) {
        FSAddressRequest *request = [self createRequest:REQUEST_ADDRESS_CREATE];
        [self beginLoading:self.view];
        _inLoading = YES;
        [self hiddenControl];
        [request send:[FSAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:self.view];
            _inLoading = NO;
            if (resp.isSuccess)
            {
                [self reportError:resp.message];
                //2秒钟后返回上一级页面
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
    else{
        [self reportError:error];
    }
    [activityField resignFirstResponder];
}

-(void)edit
{
    NSString *error = nil;
    if ([self check:&error]) {
        FSAddressRequest *request = [self createRequest:REQUEST_ADDRESS_EDIT];
        [self beginLoading:self.view];
        _inLoading = YES;
        [self hiddenControl];
        [request send:[FSAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:self.view];
            _inLoading = NO;
            if (resp.isSuccess)
            {
                [self changePageState:FSAddressDetailStateShow];
                [self reportError:resp.message];
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0f];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
    else{
        [self reportError:error];
    }
    [activityField resignFirstResponder];
}

-(void)hiddenControl
{
    [activityField resignFirstResponder];
    [self hidenPickerView:YES];
}

-(FSAddressRequest*)createRequest:(NSString *)routePath
{
    FSAddressDB *addr = nil;
    FSAddressDB *addr2 = nil;
    FSAddressDB *addr3 = [addr2.items objectAtIndex:thirdRow];
    if (theApp.allAddress.count > firstRow) {
        addr = (FSAddressDB*)theApp.allAddress[firstRow];
        if (addr.items.count > secondRow) {
            addr2 = addr.items[secondRow];
            if (addr2.items.count > thirdRow) {
                addr3 = [addr2.items objectAtIndex:thirdRow];
            }
        }
    }
    
    FSAddressRequest *request = [[FSAddressRequest alloc] init];
    FSUser *currentUser = [FSUser localProfile];
    request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
    request.routeResourcePath = routePath;
    request.shippingcontactperson = _name.text;
    request.shippingaddress = _addressDetail.text;
    request.shippingcontactphone = _telephone.text;
    request.shippingprovince = addr.province;
    request.shippingprovinceid = addr.provinceID;
    request.shippingcity = addr2.city;
    request.shippingcityid = addr2.cityID;
    request.shippingdistrict = addr3.district;
    request.shippingdistrictid = addr3.districtID;
    request.shippingzipcde = _zipCode.text;//addr3.zipCode;
    request.id = _addressID;
    
    return request;
}

-(BOOL)check:(NSString **)error
{
    BOOL flag = YES;
    {
        //判断是否合理
        //收货人
        if (_name.text.length <= 0) {
//            _name.text = _name.placeholder;
//            _name.textColor = redColor;
            if ([NSString isNilOrEmpty:*error]) {
                *error = _name.placeholder;
            }
            
            flag = NO;
        }
        else {
            if ([_name.textColor isEqual:redColor]) {
                flag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _name.text;
                }
            }
        }
        
        //手机号码
        if (_telephone.text.length <= 0) {
//            _telephone.text = _telephone.placeholder;
//            _telephone.textColor = redColor;
            if ([NSString isNilOrEmpty:*error]) {
                *error = _telephone.placeholder;
            }
            flag = NO;
        }
        else {
            BOOL tempFlag = YES;
            if ([_telephone.textColor isEqual:redColor]) {
                flag = NO;
                tempFlag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _telephone.text;
                }
            }
            if (tempFlag && ![NSString isMobileNum:_telephone.text]) {
//                _telephone.text = @"请输入正确的联系方式";
//                _telephone.textColor = redColor;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = @"请输入正确的联系方式";
                }
                
                flag = NO;
            }
        }
        
        if (_telephone.text.length > 0) {
            BOOL tempFlag = YES;
            if ([_telephone.textColor isEqual:redColor]) {
                flag = NO;
                tempFlag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _telephone.text;
                }
            }
            if (tempFlag && ![NSString isPhoneNum:_telephone.text]) {
//                _telephone.text = @"请输入正确的联系方式";
//                _telephone.textColor = redColor;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = @"请输入正确的联系方式";
                }
                
                flag = NO;
            }
        }
        
        //收获地区
        if (_address.text.length <= 0) {
//            _address.text = _address.placeholder;
//            _address.textColor = redColor;
            flag = NO;
            if ([NSString isNilOrEmpty:*error]) {
                *error = _address.placeholder;
            }
        }
        else {
            if ([_address.textColor isEqual:redColor]) {
                flag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _address.text;
                }
            }
        }
        
        //收获地址
        if (_addressDetail.text.length <= 0) {
//            _addressDetail.text = _addressDetail.placeholder;
//            _addressDetail.textColor = redColor;
            if ([NSString isNilOrEmpty:*error]) {
                *error = _addressDetail.placeholder;
            }
            flag = NO;
        }
        else {
            if ([_addressDetail.textColor isEqual:redColor]) {
                flag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _addressDetail.text;
                }
            }
        }
        //邮编
        if (_zipCode.text.length <= 0) {
//            _zipCode.text = _zipCode.placeholder;
//            _zipCode.textColor = redColor;
            if ([NSString isNilOrEmpty:*error]) {
                *error = _zipCode.placeholder;
            }
            
            flag = NO;
        }
        else {
            if ([_zipCode.textColor isEqual:redColor]) {
                flag = NO;
                if ([NSString isNilOrEmpty:*error]) {
                    *error = _zipCode.text;
                }
            }
        }
    }
    return flag;
}

-(void)changePageState:(FSAddressDetailState)state
{
    pageState = state;
    switch (pageState) {
        case FSAddressDetailStateShow:
        {
            [self setControlEnable:NO];
            _deleteBtn.hidden = NO;
            [self showRightButton:@"修改"];
        }
            break;
        case FSAddressDetailStateEdit:
        {
            [self setControlEnable:YES];
            _deleteBtn.hidden = YES;
            [self showRightButton:@"保存"];
            [_name becomeFirstResponder];
        }
            break;
        case FSAddressDetailStateNew:
        {
            [self setControlEnable:YES];
            _deleteBtn.hidden = YES;
            [self showRightButton:@"保存"];
        }
            break;
        default:
            break;
    }
}

-(void)setControlEnable:(BOOL)flag
{
    _name.enabled = flag;
    _telephone.enabled = flag;
    _address.enabled = NO;
    _addressDetail.editable = flag;
    _zipCode.enabled = flag;
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setTelephone:nil];
    [self setAddress:nil];
    [self setAddressDetail:nil];
    [self setZipCode:nil];
    [self setContentView:nil];
    [self setDeleteBtn:nil];
    [super viewDidUnload];
}

- (IBAction)selectAddress:(id)sender {
    if (pageState != FSAddressDetailStateEdit && pageState != FSAddressDetailStateNew) {
        return;
    }
    [self showPickerView];
}

- (IBAction)deleteAddress:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确认要删除该地址吗？" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
    [alert show];
}

-(void)initPickerRows:(FSAddress*)address
{
    for (int i = 0; i < theApp.allAddress.count; i++) {
        FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[i];
        if (addr.provinceID != address.shippingprovinceid)
            continue;
        firstRow = i;
        for (int j = 0; j < addr.items.count; j++) {
            FSAddressDB *addr2 = addr.items[j];
            if (addr2.cityID != address.shippingcityid)
                continue;
            secondRow = j;
            for (int k = 0; k < addr2.items.count; k++) {
                FSAddressDB *addr3 = addr2.items[k];
                if (addr3.districtID != address.shippingdistrictid)
                    continue;
                thirdRow = k;
                break;
            }
            break;
        }
        break;
    }
    [_picker selectRow:firstRow inComponent:0 animated:NO];
    [_picker selectRow:secondRow inComponent:1 animated:NO];
    [_picker selectRow:thirdRow inComponent:2 animated:NO];
}

#pragma mark - UIPickerView

-(void)initPickerView
{
    if (pickerView) {
        [pickerView removeFromSuperview];
    }
    pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HIGH, APP_WIDTH, 262)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APP_WIDTH, 46)];
    imgView.image = [UIImage imageNamed:@"picker_head_bg.png"];
    imgView.backgroundColor = [UIColor grayColor];
    [pickerView addSubview:imgView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8, 8, 50, 30);
    [cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_short_left.png"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPickerView:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pickerView addSubview:cancelButton];
    
    UIButton * okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setFrame:CGRectMake(APP_WIDTH - 58, 8, 50, 30)];
    [okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [okButton setBackgroundImage:[UIImage imageNamed:@"btn_short_right.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okPickerView:) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [pickerView addSubview:okButton];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 46, APP_WIDTH, 216)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = PickerView_Background_Color;
    _picker.alpha = PickerView_Alpha;
    [pickerView addSubview:_picker];
    
    [theApp.window insertSubview:pickerView atIndex:1000];
}

-(void)showPickerView
{
    if (pickerView.frame.origin.y <= SCREEN_HIGH && !pickerIsShow)
    {
        pickerIsShow = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = pickerView.frame;
            rect.origin.y -= pickerView.frame.size.height;
            pickerView.frame = rect;
        } completion:nil];
         
        [_picker reloadAllComponents];        
        [activityField resignFirstResponder];
    }
}

-(void)hidenPickerView:(BOOL)animated
{
    if (pickerView.frame.origin.y <= SCREEN_HIGH-pickerView.frame.size.height && pickerIsShow)
    {
        if (animated) {
            pickerIsShow = NO;
            [UIView animateWithDuration:0.3f animations:^{
                CGRect rect = pickerView.frame;
                rect.origin.y += pickerView.frame.size.height;
                pickerView.frame = rect;
            } completion:nil];
        }
        else {
            pickerIsShow = NO;
            CGRect rect = pickerView.frame;
            rect.origin.y += pickerView.frame.size.height;
            pickerView.frame = rect;
        }
    }
}

-(void)cancelPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES];
}

-(void)okPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES];
    [self showSelect];
}

-(void)showSelect
{
    firstRow = [_picker selectedRowInComponent:0];
    if (firstRow < theApp.allAddress.count) {
        FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[firstRow];
        secondRow = [_picker selectedRowInComponent:1];
        if (secondRow < addr.items.count) {
            FSAddressDB *addr2 = addr.items[secondRow];
            thirdRow = [_picker selectedRowInComponent:2];
            if (thirdRow < addr2.items.count) {
                FSAddressDB *addr3 = [addr2.items objectAtIndex:thirdRow];
                
                _address.text = [NSString stringWithFormat:@"%@%@%@", addr.province, addr2.city, addr3.district];
                _zipCode.text = addr3.zipCode;
                
                _address.textColor = fieldTextColor;
                _zipCode.textColor = fieldTextColor;
            }
            
        }
        
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)_pickerView numberOfRowsInComponent:(NSInteger)component
{
    int row = 0;
	switch (component) {
		case 0:
			row = theApp.allAddress.count;
			break;
		case 1:
        {
            int first = [_pickerView selectedRowInComponent:0];
            if (theApp.allAddress.count > first) {
                FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[first];
                row = [addr.items count];
            }
        }
			break;
		case 2:
        {
            int first = [_pickerView selectedRowInComponent:0];
            if (theApp.allAddress.count > first) {
                FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[first];
                int second = [_pickerView selectedRowInComponent:1];
                if (second < addr.items.count) {
                    row = [[addr.items[second] items] count];
                }
            }
        }
			break;
		default:
			break;
	}
	return row;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)_pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSString* str = @"";
	switch (component) {
		case 0:
			str = [[theApp.allAddress objectAtIndex:row] province];
			break;
		case 1:
        {
            int first = [_pickerView selectedRowInComponent:0];
            if (theApp.allAddress.count > first) {
                FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[first];
                if (addr.items.count > row) {
                    str = [addr.items[row] city];
                }
            }
        }
			break;
		case 2:
        {
            int first = [_pickerView selectedRowInComponent:0];
            if (theApp.allAddress.count > first) {
                FSAddressDB *addr = (FSAddressDB*)theApp.allAddress[first];
                int second = [_pickerView selectedRowInComponent:1];
                if (addr.items.count > second) {
                    FSAddressDB *addr2 = addr.items[second];
                    if (addr2.items.count > row) {
                        addr = [addr2.items objectAtIndex:row];
                        str = addr.district;
                    }
                }
            }
        }
			break;
		default:
			break;
	}
	return str;
}

- (void)pickerView:(UIPickerView *)_pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	[_pickerView reloadAllComponents];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.text.length > 0 && [textField.textColor isEqual:redColor]) {
        textField.text = @"";
        textField.textColor = fieldTextColor;
    }
    activityField = textField;
    if (pickerIsShow) {
        [self hidenPickerView:YES];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.text.length > 0 && [textView.textColor isEqual:redColor]) {
        textView.text = @"";
        textView.textColor = fieldTextColor;
    }
    activityField = textView;
    if (pickerIsShow) {
        [self hidenPickerView:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        FSAddressRequest *request = [[FSAddressRequest alloc] init];
        FSUser *currentUser = [FSUser localProfile];
        request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
        request.id = _addressID;
        request.routeResourcePath = REQUEST_ADDRESS_DELETE;
        [self beginLoading:self.view];
        _inLoading = YES;
        [request send:[FSAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            [self endLoading:self.view];
            _inLoading = NO;
            if (resp.isSuccess)
            {
                [self reportError:resp.message];
                //1秒钟后返回上一级页面
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
}

@end
