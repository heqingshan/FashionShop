//
//  FSPagedExchangeList.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-8.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedExchangeList.h"
#import "FSExchange.h"

@implementation FSPagedExchangeList

+(NSString*)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSExchange class];
}

@end
