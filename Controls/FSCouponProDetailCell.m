//
//  FSCouponProDetailCell.m
//  FashionShop
//
//  Created by gong yi on 12/31/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCouponProDetailCell.h"
#import "UITableViewCell+BG.h"

@implementation FSCouponProDetailCell

-(void) setData:(FSCoupon *)data
{
    _data = data;
    int yCap = 8;
    _cellHeight = yCap;
    
    //标题
    _lblTitle.text = _data.productname;
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    _lblTitle.minimumFontSize = 12;
    _lblTitle.textColor = [UIColor colorWithHexString:@"#181818"];
    
    //有效期
    NSString *dateString =@"";
    if ([_data isUsed])
    {
        dateString = NSLocalizedString(@"coupon used", nil);
    } else if([_data isExpired])
    {
        dateString = NSLocalizedString(@"coupon expired", nil);
    } else
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy年MM月dd日"];
        dateString = [NSString stringWithFormat:NSLocalizedString(@"coupon will expired:%@", nil),[df stringFromDate:_data.endDate]];
    }
    _lblDuration.text = dateString;
    _lblDuration.font =ME_FONT(13);
    _lblDuration.textColor = [UIColor colorWithHexString:@"#666666"];
    [_lblDuration sizeToFit];
    
    //实体店名称
    _lblStore.text = [NSString stringWithFormat:NSLocalizedString(@"User_Coupon_store%a", nil),_data.promotion.store.name];
    _lblStore.font = ME_FONT(13);
    _lblStore.textColor = [UIColor colorWithHexString:@"#666666"];
    [_lblStore sizeToFit];
    
    //优惠码
    _lblCode.text = _data.code;
    _lblCode.font = BFONT(16);
    if (_data.status == 1) {
        _lblCode.textColor = [UIColor colorWithHexString:@"#007f06"];
    }
    else if(_data.status == 2) {
        _lblCode.textColor = [UIColor colorWithHexString:@"#bbbbbb"];
    }
    else{
        _lblCode.textColor = [UIColor colorWithHexString:@"#e5004f"];
    }
}


@end
