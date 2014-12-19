//
//  FSPagedMyComment.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedMyComment.h"
#import "FSComment.h"

@implementation FSPagedMyComment

+(NSString*)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSComment class];
}

@end
