//
//  FSExchangeListCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSExchangeListCell.h"
#import "FSConfiguration+Fonts.h"

@interface FSExchangeListCell ()

@end

@implementation FSExchangeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
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
    
    [_titleView setText:_data.name];
    //search store name
    NSMutableString *stores = [NSMutableString string];
    for (int i = 0; i < _data.inscopenotices.count; i++) {
        FSCommon *item = _data.inscopenotices[i];
        if (i != _data.inscopenotices.count - 1) {
            [stores appendFormat:@"%@\n", item.storename];
        }
        else {
            [stores appendFormat:@"%@", item.storename];
        }
    }
    int height = [stores sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(201, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
    if (height < 24) {
        height = 24;
    }
    if (height > 30) {
        height = 40;
    }
    CGRect _rect = _desc.frame;
    _rect.size.height = height;
    _desc.frame = _rect;
    [_desc setText:stores];
    _desc.textColor = RGBCOLOR(102, 102, 102);
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy年MM月dd日"];
    NSString *str = [NSString stringWithFormat:@"%@~%@", [df stringFromDate:_data.activeStartDate], [df stringFromDate:_data.activeEndDate]];
    _activityTime.text = str;
    _activityTime.textColor = RGBCOLOR(228, 0, 127);
}

@end
