//
//  FSProdTagCell.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProdTagCell.h"

@implementation FSProdTagCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

-(void) switchBackground
{
    if (self.isSelected) {
        UIView* bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        bgview.opaque = YES;
        //bgview.backgroundColor = [UIColor colorWithRed:209 green:0 blue:79];
        bgview.backgroundColor = [UIColor clearColor];
        [self setBackgroundView:bgview];
    } else
        [self setBackgroundView:nil];
}

-(void)setData:(FSTag *)data
{
    if (![data isKindOfClass:[FSTag class]]) {
        return;
    }
    _data = data;
  
    if (!_lblTag)
    {
        _lblTag = [[FSVAlignLabel alloc] initWithFrame:self.bounds];
        _lblTag.contentMode = UIViewContentModeCenter;
    }

    [self.contentView addSubview:_lblTag];
    _lblTag.text = _data.name;
    _lblTag.font = ME_FONT(12);
    _lblTag.numberOfLines = 0;
    _lblTag.backgroundColor = [UIColor clearColor];
    _lblTag.textColor = RGBCOLOR(75, 73, 72);
    _lblTag.textAlignment = NSTextAlignmentCenter;
 

}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        _lblTag.textColor= RGBCOLOR(218, 33, 85);
        _lblTag.font = [UIFont systemFontOfSize:12];
       
    } else
    {
        _lblTag.font = ME_FONT(12);
        _lblTag.textColor = RGBCOLOR(75, 73, 72);
    }
    [self switchBackground];
    [self setNeedsDisplay];
}

@end
