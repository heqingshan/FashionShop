//
//  FSCouponDetailCell.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCouponDetailCell.h"
#import "UIImageView+WebCache.h"
#import "UITableViewCell+BG.h"

@implementation FSCouponDetailCell
@synthesize data=_data;

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
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView *bg = [[UIView alloc] initWithFrame:self.frame];
        bg.backgroundColor =[UIColor grayColor];
        self.selectedBackgroundView =bg;
    }
    return self;
}


-(void) setData:(FSCoupon *)data
{
    _data = data;
    FSResource *defaultRes = [_data.product.resource lastObject];
    [_imgPro setImageWithURL:defaultRes.absoluteUrl120];
    _imgPro.contentMode = UIViewContentModeScaleAspectFit;
    _lblCode.text = _data.code;
    _lblCode.font = ME_FONT(16);
    [_lblCode sizeToFit];
    _lblCode.backgroundColor = [UIColor clearColor];
    if (_data.status == 1) {
        _lblCode.textColor = [UIColor colorWithHexString:@"#007f06"];
    }
    else if(_data.status == 2) {
        _lblCode.textColor = [UIColor colorWithHexString:@"#bbbbbb"];
    }
    else{
        _lblCode.textColor = [UIColor colorWithHexString:@"#e5004f"];
    }
    
    _lblTitle.text = _data.productname;
    _lblTitle.textColor = [UIColor colorWithHexString:@"#181818"];
    _lblTitle.font = [UIFont systemFontOfSize:15];
    _lblTitle.numberOfLines = 0;
    _lblTitle.lineBreakMode = NSLineBreakByCharWrapping;
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    _lblTitle.minimumFontSize = 12;
    
    _lblStore.text = [NSString stringWithFormat:NSLocalizedString(@"User_Coupon_store%a", nil),_data.product.store.name];
    _lblStore.font = ME_FONT(14);
    _lblStore.textColor = [UIColor colorWithHexString:@"#666666"];
    [_lblStore sizeToFit];
    NSString *dateString =@"";
    if ([_data isUsed])
    {
        dateString = NSLocalizedString(@"coupon used", nil);
    } else if ([_data isExpired])
    {
        dateString = NSLocalizedString(@"coupon expired", nil);
    } else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年MM月dd日"];
        dateString = [NSString stringWithFormat:NSLocalizedString(@"coupon will expired:%@", nil),[df stringFromDate:_data.endDate]];
    }
    _lblDuration.text = dateString;
    _lblDuration.font =ME_FONT(14);
    _lblDuration.textColor = [UIColor colorWithHexString:@"#666666"];
    [_lblDuration sizeToFit];

 
}


@end
