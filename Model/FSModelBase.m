//
//  FSModelBase.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@implementation FSModelBase


+ (NSString *) relationKeyPath
{
    return @"data";
}

+(RKObjectMapping *)getRelationDataMap
{
    return nil;
}

@end
