//
//  FSLoadMoreRefreshFooter.m
//  FashionShop
//
//  Created by gong yi on 12/6/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSLoadMoreRefreshFooter.h"


@implementation FSLoadMoreRefreshFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIActivityIndicatorView* refresh = [[UIActivityIndicatorView alloc] init];
        refresh.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        [refresh startAnimating];
        [self addSubview:refresh];
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

@end
