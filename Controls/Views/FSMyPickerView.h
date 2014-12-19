//
//  FSMyPickerView.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSMyPickerView;

@protocol FSMyPickerViewDelegate <NSObject>

@optional

- (void)didClickOkButton:(FSMyPickerView *)myPickerView;
- (void)didClickCancelButton:(FSMyPickerView *)myPickerView;
- (NSString *)myPickerView:(FSMyPickerView *)myPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)myPickerView:(FSMyPickerView *)myPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@protocol FSMyPickerViewDatasource <NSObject>
@required

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView;
- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end

@interface FSMyPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic) id<FSMyPickerViewDelegate> delegate;
@property (nonatomic) id<FSMyPickerViewDatasource> datasource;

@property (nonatomic) BOOL pickerIsShow;  //当前picker是否显示
@property (nonatomic,strong) UIPickerView *picker;

-(void)showPickerView:(void (^)(void))action;
-(void)hidenPickerView:(BOOL)animated action:(void (^)(void))Aaction;

+(FSMyPickerView*)sharedInstance;

@end
