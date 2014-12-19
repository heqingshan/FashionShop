//
//  FSPointDetailCell.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPointDetailCell.h"
#import "UITableViewCell+BG.h"

@implementation FSPointDetailCell

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
        [self setBackgroundViewUniveral];
    }
    return self;
}

-(void)setData:(FSPoint *)data
{
    if (_data==data) {
        return;
    }
    _data = data;
    _lblReason.text = _data.title;
    _lblReason.font = ME_FONT(14);
    _lblReason.textColor = [UIColor colorWithHexString:@"#666666"];
    CGSize newSize = [_lblReason.text sizeWithFont:ME_FONT(14) constrainedToSize:CGSizeMake(200, 100) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect origFrame = _lblReason.frame;
    origFrame.size.width = newSize.width;
    origFrame.size.height = MAX(newSize.height, 45);
    _lblReason.frame = origFrame;
    _lblReason.numberOfLines = 0;
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy.MM.dd"];
    _lblInDate.text = [NSString stringWithFormat:@"%@",[formater stringFromDate:_data.inDate]];
    _lblInDate.font = ME_FONT(12);
    _lblInDate.textColor = [UIColor colorWithHexString:@"#666666"];
    _lblInDate.textAlignment = NSTextAlignmentRight;
    
    _line1.frame = CGRectMake(0, self.frame.size.height - 2, APP_WIDTH, 2);
}

@end
