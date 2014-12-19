//
//  UIBarButtonItem+Title.m
//  FashionShop
//
//  Created by gong yi on 11/23/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "UIBarButtonItem+Title.h"


@implementation UIBarButtonItem(Title)

- (id)initWithTitle:(NSString *)title width:(CGFloat)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 23)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.opaque = NO;
    label.textColor = [UIColor colorWithRed:0x71/255.0 green:0x78/255.0 blue:0x80/255.0 alpha:1.0];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor colorWithRed:0xe6/255.0 green:0xe7/255.0 blue:0xeb/255.0 alpha:1.0];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20.0];
    UIView *labelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 24)];
    [labelContainer addSubview:label];
    
    self = [self initWithCustomView:labelContainer];
    
    return self;
}

@end

