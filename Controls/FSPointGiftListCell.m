//
//  FSPointGiftListCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPointGiftListCell.h"
#import "FSCommon.h"

@implementation FSPointGiftListCell

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

-(void)setData:(id)data
{
    _data = data;
    _titleView.text = _data.promotion.name;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy年MM月dd日"];
    _valideTime.text = [NSString stringWithFormat:@"有效期: %@止", [df stringFromDate:_data.validEndDate]];
    _amountView.text = [NSString stringWithFormat:@"%.2f元", _data.amount];
    _giftNumber.text = _data.giftCode;
    if (_data.status == 1) {
        _giftNumber.textColor = [UIColor colorWithHexString:@"#007f06"];
    }
    else if(_data.status == 2) {
        _giftNumber.textColor = [UIColor colorWithHexString:@"#bbbbbb"];
    }
    else{
        _giftNumber.textColor = [UIColor colorWithHexString:@"#e5004f"];
    }
}

@end

@implementation FSPointGiftInfoCell

-(void)setData:(id)data
{
    _data = data;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy年MM月dd日 HH:mm:ss"];
    
    NSLog(@"%@", _data.createDate);
    _createTime.text = [df stringFromDate:_data.createDate];
    [df setDateFormat:@"yy年MM月dd日"];
    _validate.text = [NSString stringWithFormat:@"%@止", [df stringFromDate:_data.validEndDate]];
//    if (_data.promotion.inscopenotices.count > 0) {
//        FSCommon *item = _data.promotion.inscopenotices[0];
//        _useStore.text = item.storename;
//    }
    _useStore.text = _data.storeName;
    _pointCount.text = [NSString stringWithFormat:@"%d", _data.points];
    _cashCount.text = [NSString stringWithFormat:@"%.2f元", _data.amount];
    _giftCode.text = _data.giftCode;
    _attention.numberOfLines = 0;
    _attention.text = [NSString stringWithFormat:@"特别提醒：%@", _data.promotion.usageNotice];
    int _h = [_data.promotion.usageNotice sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
    CGRect _rect = _attention.frame;
    _rect.size.height = _h;
    _attention.frame = _rect;
}

@end
