//
//  FSPagedMyPLetter.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedMyPLetter.h"

@implementation FSPagedMyPLetter

+(NSString *)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSMyLetter class];
}

@end
