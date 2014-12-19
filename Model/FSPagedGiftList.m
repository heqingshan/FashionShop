//
//  FSPagedGiftList.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedGiftList.h"
#import "FSExchange.h"

@implementation FSPagedGiftList

+(NSString*)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSGiftListItem class];
}

@end
