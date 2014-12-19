//
//  FSPagedAddress.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedAddress.h"
#import "FSAddress.h"

@implementation FSPagedAddress

+(NSString *)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSAddress class];
}

@end
