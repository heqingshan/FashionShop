//
//  FSImageCollectionCell.m
//  FashionShop
//
//  Created by gong yi on 1/2/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSImageCollectionCell.h"

@implementation FSImageCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareControl];
    }
    return self;
}

-(void)prepareControl
{
    _btnSizeSel = [[UIButton alloc] initWithFrame:CGRectMake(40, 119, 20, 20)];
    [_btnSizeSel setImage:[UIImage imageNamed:@"unselect_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnSizeSel];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 100, 116)];
    [self.contentView addSubview:_imageView];
    
    _btnRemove = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [_btnRemove setImage:[UIImage imageNamed:@"cancel2_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnRemove];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
