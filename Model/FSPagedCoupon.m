//
//  FSPagedCoupon.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPagedCoupon.h"
#import "FSCoupon.h"

@implementation FSPagedCoupon

+(NSString *)pagedKeyPath
{
    return @"couponcodes";
}

+(Class)pagedModel
{
    return [FSCoupon class];
}
@end
