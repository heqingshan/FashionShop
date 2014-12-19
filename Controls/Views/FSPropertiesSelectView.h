//
//  FSPropertiesSelectView.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPurchase.h"
#import "FSMyPickerView.h"

@protocol FSPropertiesSelectViewDelegate;

@interface FSPropertiesSelectView : UIView<FSMyPickerViewDatasource,FSMyPickerViewDelegate>

@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,strong) NSArray *showData; //存放的是FSKeyValueItem对象
@property (nonatomic, strong) FSPurchaseForUpload *uploadData;
@property (nonatomic) int selectedKey;//选中的Key值
@property (nonatomic) int selectedIndex;
@property (nonatomic) id<FSPropertiesSelectViewDelegate> delegate;

@end

@protocol FSPropertiesSelectViewDelegate <NSObject>

-(void)didClickOkButton:(FSPropertiesSelectView*)controller;

@end
