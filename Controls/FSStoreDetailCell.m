//
//  FSStoreDetailCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSStoreDetailCell.h"

@implementation FSStoreDescCell

-(void)setDescData:(NSString *)descData
{
    _descData = descData;
    
    int height = [_descData sizeWithFont:ME_FONT(12) constrainedToSize:CGSizeMake(_description.frame.size.width, 10000) lineBreakMode:NSLineBreakByCharWrapping].height;
    _cellHeight_Expand = _description.frame.origin.y + height + 10;
    _cellHeight_Contract = _description.frame.origin.y;
    CGRect _rect = _description.frame;
    _rect.size.height = height;
    _description.frame = _rect;
    _description.text = descData;
    _description.font = ME_FONT(12);
    
    self.clipsToBounds = YES;
}

@end

@implementation FSStoreProHeadView

@end
