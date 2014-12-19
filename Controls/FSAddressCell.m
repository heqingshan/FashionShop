//
//  FSAddressCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAddressCell.h"

@implementation FSAddressListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setData:(FSAddress *)data
{
    _data = data;
    
    int xOffset = _name.frame.origin.x;
    _name.text = data.shippingperson;
    _name.adjustsFontSizeToFitWidth = YES;
    _name.minimumFontSize = 12;
    CGSize size = [_name.text sizeWithFont:[UIFont systemFontOfSize:16]];
    CGRect _rect = _name.frame;
    _rect.size.width = size.width;
    if (_rect.size.width > 135) {
        _rect.size.width = 135;
    }
    _name.frame = _rect;
    xOffset += _rect.size.width;
    
    _tel.text = data.shippingphone;
    _tel.adjustsFontSizeToFitWidth = YES;
    _tel.minimumFontSize = 12;
    _rect = _tel.frame;
    _rect.origin.x = xOffset + 10;
    if (_rect.size.width > 120) {
        _rect.size.width = 120;
    }
    _tel.frame = _rect;
    
    _addressDesc.text = data.displayaddress;
    _addressDesc.lineBreakMode = NSLineBreakByTruncatingTail;
    _addressDesc.numberOfLines = 0;
    _rect = _addressDesc.frame;
    _addressDesc.frame = _rect;
    
    UIFont *font = [UIFont systemFontOfSize:14];
    int height = [data.displayaddress sizeWithFont:font constrainedToSize:CGSizeMake(265, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
    if (height > 40) {
        _addressDesc.font = [UIFont systemFontOfSize:12];
    }
}

@end
