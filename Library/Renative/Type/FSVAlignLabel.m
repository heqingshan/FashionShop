//
//  FSVAlignLabel.m
//  FashionShop
//
//  Created by gong yi on 12/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSVAlignLabel.h"
@interface FSVAlignLabel()
{
    VerticalAlignment verticalAlignment_; 
}
@end

@implementation FSVAlignLabel

@synthesize verticalAlignment = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGSize sizeThatFits = [self sizeThatFits:requestedRect.size];
    
    if (self.contentMode == UIViewContentModeCenter) {
        requestedRect.origin.y = MAX(0, (requestedRect.size.height - sizeThatFits.height)/2);
        requestedRect.size.height = MIN(requestedRect.size.height, sizeThatFits.height);
    }
    
    [super drawTextInRect:requestedRect];
}

@end