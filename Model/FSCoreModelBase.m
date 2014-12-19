//
//  FSCoreModelBase.m
//  FashionShop
//
//  Created by gong yi on 11/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCoreModelBase.h"

@implementation FSCoreModelBase
@synthesize isSuccess,errorDescrip;
@synthesize errorType;

+ (NSString *) relationKeyPath
{
    return @"data";
}
@end
