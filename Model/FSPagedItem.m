//
//  FSPagedItem.m
//  FashionShop
//
//  Created by gong yi on 1/9/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSPagedItem.h"
#import "FSItemBase.h"

@implementation FSPagedItem

+(NSString *)pagedKeyPath
{
    return @"items";
}

+(Class)pagedModel
{
    return [FSItemBase class];
}
@end
