//
//  FSProdDetailCell.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProdDetailCell.h"
#import "FSResource.h"

#define Icon_Size 15

@implementation FSProdDetailCell

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
    _imgPic = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_imgPic];
    _imgPic.clipsToBounds = YES;
    
    _btnPrice = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 24)];
    //[_btnPrice setImage:[UIImage imageNamed:@"cancel2_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnPrice];
    
    _btnPro = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Icon_Size, Icon_Size)];
    [_btnPro setImage:[UIImage imageNamed:@"promotion_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnPro];
    
    _btnProBag = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Icon_Size, Icon_Size)];
    [_btnProBag setImage:[UIImage imageNamed:@"icon_bag.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnProBag];
}

-(void)prepareForReuse
{
    _imgPic.image = nil;
}

-(void)setData:(FSProdItemEntity *)data
{
    _data = data;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imgPic.frame = self.bounds;
    
    if (_data.price &&
        [_data.price intValue]>0)
    {
        _btnPrice.alpha =0.6;
        _btnPrice.backgroundColor = [UIColor darkGrayColor];
        [_btnPrice setTitle:[NSString stringWithFormat:@"¥%.2f",[_data.price floatValue]] forState:UIControlStateNormal];
        [_btnPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btnPrice.titleLabel.font = [UIFont systemFontOfSize:9];
        CGSize newsize = [_btnPrice sizeThatFits:_btnPrice.frame.size];
        _btnPrice.frame = CGRectMake(self.frame.size.width-newsize.width, self.frame.size.height-newsize.height - 5, newsize.width, newsize.height);
    }
    else
    {
        _btnPrice.alpha = 0;
    }
}

-(void) showProIcon
{
    _btnPro.hidden = NO;
    _btnPro.frame = CGRectMake(3, 3, Icon_Size, Icon_Size);
}

-(void) hidenProIcon
{
    _btnPro.hidden = YES;
}

-(void) showProBag
{
    _btnProBag.hidden = NO;
    _btnProBag.frame = CGRectMake(!_data.promotionFlag?3:(Icon_Size + 6), 3, Icon_Size, Icon_Size);
}

-(void) hidenProBag
{
    _btnProBag.hidden = YES;
}

- (void)imageContainerStartDownload:(id)container withObject:(id)indexPath andCropSize:(CGSize)crop
{
    if (!_imgPic.image)
    {
        if (_data.resource && _data.resource.count>0)
        {
            NSURL *url = [(FSResource *)_data.resource[0] absoluteUrl];
            if (url)
            {
                [_imgPic setImageUrl:url resizeWidth:CGSizeMake(crop.width*RetinaFactor, crop.height*RetinaFactor) placeholderImage:[UIImage imageNamed:@"default_icon120.png"]];
            }
        }
        
    }
}


-(void)willRemoveFromView
{
    _imgPic.image = nil;
}
@end
