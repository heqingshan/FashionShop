//
//  FSPagedLike.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPagedLike.h"
#import "FSUser.h"

@implementation FSPagedLike

+(NSString *)pagedKeyPath
{
    return @"likes";
}

+(Class)pagedModel
{
    return [FSUser class];
}

@end
