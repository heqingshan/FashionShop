//
//  FSPagedOrder.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedOrder.h"
#import "FSOrder.h"

@implementation FSPagedOrder

+(NSString *)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSOrderInfo class];
}

@end
