//
//  FSPagedTopic.m
//  FashionShop
//
//  Created by HeQingshan on 13-1-31.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPagedTopic.h"

#import "FSTopic.h"

@implementation FSPagedTopic

+(NSString*)pagedKeyPath
{
    return @"specialtopics";
}

+(Class)pagedModel
{
    return [FSTopic class];
}

@end
