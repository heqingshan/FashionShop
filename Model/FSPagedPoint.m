//
//  FSPagedPoint.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPagedPoint.h"
#import "FSPoint.h"

@implementation FSPagedPoint
+(NSString *)pagedKeyPath
{
    return @"points";
}

+(Class)pagedModel
{
    return [FSPoint class];
}
@end
