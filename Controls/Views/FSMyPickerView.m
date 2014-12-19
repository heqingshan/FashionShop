//
//  FSMyPickerView.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSMyPickerView.h"

#define MP_SCREEN_HIGH [[UIScreen mainScreen] bounds].size.height
#define MP_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

static FSMyPickerView *myPickerViewInstance;

@implementation FSMyPickerView

- (id)initWithFrame:(CGRect)frame
{
    return [super initWithFrame:frame];
}

-(id)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, MP_SCREEN_HIGH, MP_SCREEN_WIDTH, 262);
        [self initPickerView];
    }
    return self;
}

+(FSMyPickerView*)sharedInstance
{
    if (!myPickerViewInstance) {
        myPickerViewInstance = [[FSMyPickerView alloc] init];
    }
    return myPickerViewInstance;
}

-(void)initPickerView
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MP_SCREEN_WIDTH, 46)];
    imgView.image = [UIImage imageNamed:@"picker_head_bg.png"];
    imgView.backgroundColor = [UIColor grayColor];
    [self addSubview:imgView];
    
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(8, 8, 50, 30);
    [cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"btn_short_left.png"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelPickerView:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:cancelButton];
    
    UIButton * okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setFrame:CGRectMake(MP_SCREEN_WIDTH - 58, 8, 50, 30)];
    [okButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [okButton setBackgroundImage:[UIImage imageNamed:@"btn_short_right.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okPickerView:) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:okButton];
    
    _picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 46, MP_SCREEN_WIDTH, 216)];
    _picker.delegate = self;
    _picker.dataSource = self;
    _picker.showsSelectionIndicator = YES;
    _picker.backgroundColor = PickerView_Background_Color;
    _picker.alpha = PickerView_Alpha;
    [self addSubview:_picker];
    
    [theApp.window insertSubview:self atIndex:1000];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

-(void)showPickerView:(void (^)(void))action
{
    if (self.frame.origin.y <= MP_SCREEN_HIGH && !_pickerIsShow)
    {
        [theApp hiddenPickerView];
        _pickerIsShow = YES;
        
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = self.frame;
            rect.origin.y -= self.frame.size.height;
            self.frame = rect;
        } completion:nil];
        if (action) {
            action();
        }
        
        [_picker reloadAllComponents];
    }
}

-(void)hidenPickerView:(BOOL)animated action:(void (^)(void))Aaction
{
    if (self.frame.origin.y <= MP_SCREEN_HIGH - self.frame.size.height && _pickerIsShow)
    {
        if (animated) {
            _pickerIsShow = NO;
            [UIView animateWithDuration:0.3f animations:^{
                CGRect rect = self.frame;
                rect.origin.y += self.frame.size.height;
                self.frame = rect;
            } completion:nil];
        }
        else {
            _pickerIsShow = NO;
            CGRect rect = self.frame;
            rect.origin.y += self.frame.size.height;
            self.frame = rect;
        }
        if (Aaction) {
            Aaction();
        }
    }
}

-(void)cancelPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES action:nil];
    if ([_delegate respondsToSelector:@selector(didClickCancelButton:)]) {
        [_delegate didClickCancelButton:self];
    }
}

-(void)okPickerView:(UIButton*)sender
{
    [self hidenPickerView:YES action:nil];
    if ([_delegate respondsToSelector:@selector(didClickOkButton:)]) {
        [_delegate didClickOkButton:self];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_datasource respondsToSelector:@selector(numberOfComponentsInMyPickerView:)]) {
        return [_datasource numberOfComponentsInMyPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_datasource respondsToSelector:@selector(myPickerView:numberOfRowsInComponent:)]) {
        return [_datasource myPickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	if ([_delegate respondsToSelector:@selector(myPickerView:titleForRow:forComponent:)]) {
        return [_delegate myPickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if ([_delegate respondsToSelector:@selector(myPickerView:didSelectRow:inComponent:)]) {
        [_delegate myPickerView:self didSelectRow:row inComponent:component];
    }
}

@end
