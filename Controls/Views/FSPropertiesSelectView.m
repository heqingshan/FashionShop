//
//  FSPropertiesSelectView.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPropertiesSelectView.h"

@interface FSPropertiesSelectView()
{
    FSMyPickerView *myPickerView;
    UIButton *slectedButton;
    UILabel *titleLb;
}

@end

@implementation FSPropertiesSelectView
@synthesize showData,uploadData,title,selectedKey,delegate,selectedIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        for (id item in self.subviews) {
            [item removeFromSuperview];
        }
    }
    return self;
}

//首先设置title
-(void)setTitle:(NSString *)aTitle
{
    if (!aTitle) {
        return;
    }
    title = aTitle;
    
    //add title
    UIFont *font = [UIFont systemFontOfSize:14];
    NSString *_title = [NSString stringWithFormat:@"%@ : ", title];
    int _titleW = [_title sizeWithFont:font].width;
    if (_titleW > 225) {
        _titleW = 225;
    }
    titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _titleW, 30)];
    titleLb.text = _title;
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = font;
    titleLb.textColor = [UIColor colorWithHexString:@"181818"];
    [self addSubview:titleLb];
}

//再设置data
-(void)setShowData:(NSArray *)aData
{
    if (!aData) {
        return;
    }
    showData = aData;
    
    //add button
    if (!slectedButton) {
        slectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [slectedButton setBackgroundImage:[UIImage imageNamed:@"btn_property_normal.png"] forState:UIControlStateNormal];
    }
    slectedButton.frame = CGRectMake(titleLb.frame.size.width, 0, 72, 30);
    UIEdgeInsets edge = slectedButton.contentEdgeInsets;
    edge.right = 25;
    slectedButton.contentEdgeInsets = edge;
    UIFont *font = [UIFont systemFontOfSize:12];
    [slectedButton.titleLabel setFont:font];
    slectedButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    slectedButton.titleLabel.minimumFontSize = 10;
    [slectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:slectedButton];
    if (!myPickerView) {
        myPickerView = [[FSMyPickerView alloc] init];
        myPickerView.delegate = self;
        myPickerView.datasource = self;
    }
    NSString *__title = nil;
    int index = [self getSelectIndex:&__title];
    selectedIndex = index;
    slectedButton.enabled = YES;
    if (index == -1) {
        //__title = @"请选择";
    }
    else if(index == -2) {
        slectedButton.enabled = NO;
    }
    else{
        [myPickerView.picker selectRow:index inComponent:0 animated:NO];
    }
    [slectedButton setTitle:__title forState:UIControlStateNormal];
    [slectedButton addTarget:self action:@selector(clickSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = CGRectMake(0, 0, titleLb.frame.size.width + slectedButton.frame.size.width, 30);
}

-(int)getSelectIndex:(NSString**)aTitle
{
    if (showData.count <= 0) {
        *aTitle = @"已售罄";
        return -2;
    }
    for (int i = 0; i < showData.count; i++) {
        FSKeyValueItem *item = showData[i];
        if (item.key == selectedKey) {
            *aTitle = item.value;
            return i;
        }
    }
    *aTitle = @"请选择";
    return -1;
}

-(void)clickSelectButton:(UIButton*)sender
{
    if (myPickerView.pickerIsShow) {
        [myPickerView hidenPickerView:YES action:nil];
    }
    else{
        NSString *aTitle = nil;
        int index = [self getSelectIndex:&aTitle];
        selectedIndex = index;
        if (index == -1) {
            index = 0;
        }
        [myPickerView.picker selectRow:index inComponent:0 animated:NO];
        [myPickerView showPickerView:nil];
        [theApp.window bringSubviewToFront:myPickerView];
    }
}

#pragma mark - FSMyPickerViewDatasource

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView
{
    return 1;
}

- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return showData.count;
}

#pragma mark - FSMyPickerViewDelegate

- (void)didClickOkButton:(FSMyPickerView *)aMyPickerView
{
    if (selectedIndex < 0 && showData.count > 0) {
        selectedIndex = 0;
    }
    FSKeyValueItem *item = showData[selectedIndex];
    [slectedButton setTitle:item.value forState:UIControlStateNormal];
    [slectedButton sizeToFit];
    if (delegate && [delegate respondsToSelector:@selector(didClickOkButton:)]) {
        [delegate didClickOkButton:self];
    }
}

- (void)didClickCancelButton:(FSMyPickerView *)aMyPickerView
{
    //do nothing
}

- (NSString *)myPickerView:(FSMyPickerView *)aMyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    FSKeyValueItem *item = showData[row];
    return item.value;
}

- (void)myPickerView:(FSMyPickerView *)aMyPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    FSKeyValueItem *item = showData[row];
    selectedIndex = row;
    selectedKey = item.key;
}

@end
