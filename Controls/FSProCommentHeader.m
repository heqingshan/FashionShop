//
//  FSProCommentHeader.m
//  FashionShop
//
//  Created by gong yi on 12/24/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProCommentHeader.h"
#import "FSConfiguration.h"

@implementation FSProCommentHeader
@synthesize count = _count;

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

-(void) setCount:(int)count
{
    _count = count;
    _lblTitle.text = NSLocalizedString(@"Comments", nil);
    _lblTitle.font = ME_FONT(14);
    _lblTitle.textColor = [UIColor colorWithHexString:@"6f5e6c"];
    _lblCount.text = [NSString stringWithFormat:NSLocalizedString(@"%dcomments", nil),count];
    _lblCount.font = ME_FONT(12);
    _lblCount.textColor = [UIColor colorWithHexString:@"6f5e6c"];
}

@end
