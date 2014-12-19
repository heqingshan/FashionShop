//
//  FSProNewHeaderView.m
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProNewHeaderView.h"
#import "NSDate+Locale.h"
#import "FSConfiguration.h"


@implementation FSProNewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setData:(NSDate *)data
{
    _data = data;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    _lblStartDate.text = [format stringFromDate:_data];
    _lblStartDate.font = [UIFont systemFontOfSize:PRO_LIST_NEW_HEADER2_FONTSZ];
    bool isToday = [_data isSameDay:[[NSDate alloc] init]];
    BOOL isGoing = [_data compare:[[NSDate alloc] init]]==NSOrderedAscending;
    NSString *title = isToday?NSLocalizedString(@"Today's new activities", nil):
    isGoing?NSLocalizedString(@"ing activities", nil):NSLocalizedString(@"coming activities", nil);
    _lblTitle.text = title;
    _lblTitle.font = [UIFont systemFontOfSize:PRO_LIST_NEAR_HEADER_FONTSZ];
    NSString *imagename = isToday?@"today_new_head_icon.png":@"underway_head_icon.png";
    _imgWhen.image = [UIImage imageNamed:imagename];
}

@end


@implementation FSProNewHeaderView_1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSDate *)data
{
    _data = data;
    bool isToday = [_data isSameDay:[[NSDate alloc] init]];
    BOOL isGoing = [_data compare:[[NSDate alloc] init]]==NSOrderedAscending;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    NSString *title = isToday?NSLocalizedString(@"Today's new activities", nil):isGoing?[format stringFromDate:_data]:NSLocalizedString(@"coming activities", nil);
    _lblTitle.text = title;
    _lblTitle.adjustsFontSizeToFitWidth = YES;
    _lblTitle.minimumFontSize = 13;
}

@end