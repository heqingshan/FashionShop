//
//  UIColor+RGB.h
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(RGB)

+(UIColor *) colorWithRed:(CGFloat)red green:(CGFloat)g blue:(CGFloat)b;
+(UIColor *) colorWithRGB:(NSUInteger)rgb;
+(UIColor *) colorWithHexString: (NSString *) stringToConvert;

@end
