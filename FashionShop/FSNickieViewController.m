//
//  FSNickieViewController.m
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSNickieViewController.h"
#import "FSUserProfileRequest.h"
#import "NSString+Extention.h"

@interface FSNickieViewController ()
{
    UITextField *_activityField;
    UITextField *_phoneField;
    UITextField *_nickField;
    UITextField *_signField;
    UIButton *_btnSex;
    
    UIView *pickerView;
    UIPickerView *_picker;
    
    BOOL pickerIsShow;  //当前picker是否显示
    int tableYOffset;
    
    NSMutableDictionary *_genders;
}

-(void)initPickerView;

@end

@implementation FSNickieViewController
@synthesize currentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
        [_activityField resignFirstResponder];
        
        NSArray *_array = [_genders allKeysForObject:_btnSex.titleLabel.text];
        if (_array.count > 0) {
            int selectedRow = [_array[0] intValue];
            [_picker selectRow:selectedRow inComponent:0 animated:NO];
        }
        
        tableYOffset = self.tbAction.contentOffset.y;
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = pickerView.frame;
            rect.origin.y -= pickerView.frame.size.height;
            pickerView.frame = rect;
        } completion:nil];
        [_picker reloadAllComponents];
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
    int selectedRow = [_picker selectedRowInComponent:0];
    [_btnSex setTitle:[_genders valueForKey:[NSString stringWithFormat:@"%d", selectedRow]] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"USER_SETTING_EDITNGINFO", nil);
    
    [self bindControl];
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    
    _genders = [NSMutableDictionary dictionary];
    [_genders setValue:NSLocalizedString(@"SexUnknow", nil) forKey:@"0"];
    [_genders setValue:NSLocalizedString(@"Male", nil) forKey:@"1"];
    [_genders setValue:NSLocalizedString(@"Female", nil) forKey:@"2"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidenPickerView:YES];
}

- (void)bindControl
{
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    UIBarButtonItem *baritemShare = [self createPlainBarButtonItem:@"ok_icon.png" target:self action:@selector(doSave:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self.navigationItem setRightBarButtonItem:baritemShare];
    
    _tbAction.backgroundView = [[UIView alloc]init];
    _tbAction.backgroundColor = APP_BACKGROUND_COLOR;
    [_tbAction reloadData];
    
    [self initPickerView];
}
- (BOOL)validateUser:(NSMutableString **)errorin
{
    if (!errorin)
        *errorin = [@"" mutableCopy];
    NSMutableString *error = *errorin;
    if (_nickField.text.length<=0)
    {
        [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_ZERO", nil)];
        return NO;
    } else if(_nickField.text.length>10)
    {
        [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_TOO_MANY", nil)];
        return NO;
    }
    else if (_phoneField.text.length>0)
    {
        if ([NSString isMobileNum:_phoneField.text]) {
            return YES;
        }
        else {
            [error appendString:NSLocalizedString(@"USER_NICKIE_VALIDATE_PHONE", nil)];;
//            [self reportError:NSLocalizedString(@"USER_NICKIE_VALIDATE_PHONE", nil)];
            return NO;
        }
    }
    return YES;
}

#pragma UITableViewController delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    int yHeight = 44;
    int xOffset = 10;
    int yOffset = 11.5;
    switch (indexPath.row) {
        case 0:
        {
            UILabel* _nickNameLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _nickNameLb.text = NSLocalizedString(@"User Nickie", nil);
            _nickNameLb.textColor = [UIColor lightGrayColor];
            _nickNameLb.textAlignment = UITextAlignmentRight;
            _nickNameLb.backgroundColor = [UIColor clearColor];
            [_nickNameLb sizeToFit];
            
            
            if (!_nickField) {
                _nickField = [[UITextField alloc] initWithFrame:CGRectMake(_nickNameLb.frame.origin.x + _nickNameLb.frame.size.width, 0, 300-_nickNameLb.frame.size.width - _nickNameLb.frame.origin.x, yHeight)];
                _nickField.placeholder = NSLocalizedString(@"Input Nickie Tip", nil);
                _nickField.delegate = self;
                _nickField.textColor = RGBCOLOR(38, 38, 38);
                _nickField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _nickField.text = currentUser.nickie;
                _nickField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _nickField.keyboardType = UIKeyboardTypeNamePhonePad;
                _nickField.returnKeyType = UIReturnKeyNext;
            }
            
            [cell.contentView addSubview:_nickNameLb];
            [cell.contentView addSubview:_nickField];
        }
            break;
        case 1:
        {
            UILabel* _sexLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _sexLb.text = NSLocalizedString(@"Gender Tip", nil);
            _sexLb.textColor = [UIColor lightGrayColor];
            _sexLb.textAlignment = UITextAlignmentRight;
            _sexLb.backgroundColor = [UIColor clearColor];
            [_sexLb sizeToFit];
            
            if (!_btnSex) {
                _btnSex = [UIButton buttonWithType:UIButtonTypeCustom];
                UIEdgeInsets _inset = _btnSex.contentEdgeInsets;
                _inset.right = 35;
                _btnSex.contentEdgeInsets = _inset;
                [_btnSex setTitle:[_genders valueForKey:[NSString stringWithFormat:@"%d", currentUser.gender]] forState:UIControlStateNormal];
                [_btnSex setBackgroundImage:[UIImage imageNamed:@"gendar_icon.png"] forState:UIControlStateNormal];
                [_btnSex setTitleColor:RGBCOLOR(38, 38, 38) forState:UIControlStateNormal];
                _btnSex.frame = CGRectMake(_sexLb.frame.origin.x + _sexLb.frame.size.width, 7, 90, 30);
                [_btnSex addTarget:self action:@selector(selectSex:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [cell.contentView addSubview:_sexLb];
            [cell.contentView addSubview:_btnSex];
        }
            break;
        case 2:
        {
            UILabel* _phoneLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, yHeight, 0)];
            _phoneLb.text = NSLocalizedString(@"Contact phone tip", nil);
            _phoneLb.textColor = [UIColor lightGrayColor];
            _phoneLb.textAlignment = UITextAlignmentRight;
            _phoneLb.backgroundColor = [UIColor clearColor];
            [_phoneLb sizeToFit];
            NSLog(@"%@", NSStringFromCGRect(_phoneLb.frame));
            
            if (!_phoneField) {
                _phoneField = [[UITextField alloc] initWithFrame:CGRectMake(_phoneLb.frame.origin.x + _phoneLb.frame.size.width, 0, 300-_phoneLb.frame.size.width - _phoneLb.frame.origin.x, yHeight)];
                _phoneField.delegate = self;
                _phoneField.textColor = RGBCOLOR(38, 38, 38);
                _phoneField.placeholder = NSLocalizedString(@"Input Phone Tip", nil);
                _phoneField.keyboardType = UIKeyboardTypeNumberPad;
                _phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _phoneField.text = currentUser.phone;
                _phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _phoneField.returnKeyType = UIReturnKeyNext;
            }
            
            [cell.contentView addSubview:_phoneLb];
            [cell.contentView addSubview:_phoneField];
        }
            break;
        case 3:
        {
            UILabel* _signLb = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, 44, 0)];
            _signLb.text = NSLocalizedString(@"Signature Tip", nil);
            _signLb.textColor = [UIColor lightGrayColor];
            _signLb.textAlignment = UITextAlignmentRight;
            _signLb.backgroundColor = [UIColor clearColor];
            [_signLb sizeToFit];
            
            if (!_signField) {
                _signField = [[UITextField alloc] initWithFrame:CGRectMake(_signLb.frame.origin.x + _signLb.frame.size.width, 0, 300-_signLb.frame.size.width - _signLb.frame.origin.x, yHeight)];
                _signField.placeholder = NSLocalizedString(@"Signature place holder", nil);
                _signField.delegate = self;
                _signField.textColor = RGBCOLOR(38, 38, 38);
                _signField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                _signField.text = currentUser.signature;
                _signField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _signField.keyboardType = UIKeyboardTypeNamePhonePad;
                _signField.returnKeyType = UIReturnKeyDone;
            }
            
            [cell.contentView addSubview:_signLb];
            [cell.contentView addSubview:_signField];
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectSex:(id)sender {
    if (pickerIsShow) {
        [self hidenPickerView:YES];
    }
    else {
        [self showPickerView];
    }
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doSave:(id)sender {
    NSMutableString *error = [@"" mutableCopy];
    if([self validateUser:&error])
    {
        FSUserProfileRequest *request = [[FSUserProfileRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_USER_PROFILE_UPDATE;
        request.userToken = currentUser.uToken;
        request.nickie = [_nickField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        request.phone = [_phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        request.signature = [_signField.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        NSArray *_array = [_genders allKeysForObject:_btnSex.titleLabel.text];
        if (_array.count > 0) {
            request.gender = [NSNumber numberWithInt:[_array[0] intValue]];
        }
        else{
            request.gender = [NSNumber numberWithInt:0];
        }
        [self beginLoading:self.view];
        [request send:[FSUser class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (!resp.isSuccess)
            {
                [self reportError:resp.description];
            }
            else
            {
                currentUser.nickie = request.nickie;
                currentUser.phone = request.phone;
                currentUser.signature = request.signature;
                currentUser.gender = [request.gender intValue];
                [self reportError:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
                [[NSNotificationCenter defaultCenter] postNotificationName:LN_USER_UPDATED object:currentUser];
                
                //让键盘或者PIckerview消失
                [_activityField resignFirstResponder];
                [self hidenPickerView:YES];
                
                //统计
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:6];
                [_dic setValue:request.nickie forKey:@"昵称"];
                [_dic setValue:request.phone forKey:@"联系方式"];
                [_dic setValue:request.signature forKey:@"签名"];
                [_dic setValue:request.gender.intValue==1?@"男":(request.gender.intValue==2?@"女":@"保密") forKey:@"Gender"];
                [_dic setValue:@"用户资料编辑页" forKey:@"来源页面"];
                FSUser *user = [FSUser localProfile];
                [_dic setValue:user.uid forKey:@"用户ID"];
                [[FSAnalysis instance] logEvent:USER_EDIT_INFO withParameters:_dic];
            }
            [self endLoading:self.view];
        }];
    }
    else
    {
        [self reportError:error];
    }
}
- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}
#pragma UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_genders valueForKey:[NSString stringWithFormat:@"%d", row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidenPickerView:YES];
    _activityField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _nickField) {
        if (textField.text.length >= 10 && ![string isEqualToString:@""]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    if (textField == _phoneField) {
        if (textField.text.length > 10 && ![string isEqualToString:@""]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nickField) {
        [_phoneField becomeFirstResponder];
    }
    else if(textField == _phoneField) {
        [_signField becomeFirstResponder];
    }
    else if(textField == _signField) {
        [self doSave:nil];
        [textField resignFirstResponder];
    }
    
    return YES;
}

@end
