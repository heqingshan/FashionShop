//
//  FSProNearDetailCell.m
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProNearDetailCell.h"

@implementation FSProNearDetailCell

-(void)setTitle:(NSString *)_title subTitle:(NSString *)_subTitle dateString:(NSString*)_dateString
{
    _cellHeight = 80;
    [_lblTitle setText:_title];
    [_lblSubTitle setText:_subTitle];
    [_lblTitle setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
    [_lblSubTitle setTextColor:[UIColor colorWithHexString:@"#dddddd"]];
    
    //[_timeView setTextAlignment:RTTextAlignmentCenter];
    [_timeView setText:_dateString];
//    CGRect _rect = _timeView.frame;
//    _rect.origin.y = (_cellHeight - _timeView.optimumSize.height)/2;
//    _rect.size.height = _timeView.optimumSize.height;
//    _timeView.frame = _rect;
    
    CGRect _rect = _line.frame;
    _rect.origin.y = 12;
    _rect.size.height = _cellHeight - 24;
    _line.frame = _rect;
    
    _rect = _line2.frame;
    _rect.origin.y = _cellHeight - 1;
    _line2.frame = _rect;
    [self bringSubviewToFront:_line2];
}

@end

@implementation FSProDateDetailCell

-(void)setTitle:(NSString *)_title desc:(NSString *)_desc address:(NSString*)aAddress dateString:(NSString*)_dateString
{
    _cellHeight = 80;
    
    [_titleView setText:_title];
    [_descView setText:_desc];
    [_address setText:aAddress];
    
    [_descView setTextColor:[UIColor colorWithHexString:@"#dddddd"]];
    [_titleView setTextColor:[UIColor colorWithHexString:@"#ffffff"]];
    [_address setTextColor:[UIColor colorWithHexString:@"#dddddd"]];
    
    //[_timeView setTextAlignment:RTTextAlignmentCenter];
    [_timeView setText:_dateString];
//    CGRect _rect = _timeView.frame;
//    _rect.origin.y = (_cellHeight - _timeView.optimumSize.height)/2;
//    _rect.size.height = _timeView.optimumSize.height;
//    _timeView.frame = _rect;
    
    CGRect _rect = _line.frame;
    _rect.origin.y = 12;
    _rect.size.height = _cellHeight - 24;
    _line.frame = _rect;
    
    _rect = _line2.frame;
    _rect.origin.y = _cellHeight - 1;
    _line2.frame = _rect;
    [self bringSubviewToFront:_line2];
}

@end
