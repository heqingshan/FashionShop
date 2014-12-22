//
//  FSStoreDetailCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSStoreDetailCell.h"

@implementation FSStoreDescCell
@synthesize description;

-(void)setDescData:(NSString *)descData
{
    _descData = descData;
    
    int height = [_descData sizeWithFont:ME_FONT(12) constrainedToSize:CGSizeMake(description.frame.size.width, 10000) lineBreakMode:NSLineBreakByCharWrapping].height;
    _cellHeight_Expand = description.frame.origin.y + height + 10;
    _cellHeight_Contract = description.frame.origin.y;
    CGRect _rect = description.frame;
    _rect.size.height = height;
    description.frame = _rect;
    description.text = descData;
    description.font = ME_FONT(12);
    
    self.clipsToBounds = YES;
}

@end

@implementation FSStoreProHeadView

@end
