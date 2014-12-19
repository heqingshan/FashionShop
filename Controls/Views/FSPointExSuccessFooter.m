//
//  FSPointView.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPointExSuccessFooter.h"

//礼券兑换成功或订单成功Cell之footer
@implementation FSCommonSuccessFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)initView:(NSString*)content
{
    int yCap = 12;
    int _cellHeight = _infomationDesc.frame.origin.y;
    NSString *str = [NSString stringWithFormat:@"温馨提示 : \n%@", content];
    [_infomationDesc setText:str];
    CGRect _rect = _infomationDesc.frame;
    _rect.origin.y = _cellHeight;
    _infomationDesc.frame = _rect;
    [_infomationDesc sizeToFit];
    _cellHeight += _infomationDesc.frame.size.height + yCap;
    
    _rect = self.frame;
    _rect.size.height = _cellHeight;
    self.frame = _rect;
}

@end
