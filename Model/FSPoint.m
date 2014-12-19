//
//  FSPoint.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPoint.h"

@implementation FSPoint

@synthesize id;
@synthesize getReason;
@synthesize inDate;
@synthesize amount;
@synthesize title;


+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"id",@"id",@"description",@"getReason",@"name",@"title",@"amount",@"amount",@"createddate",@"inDate",nil];
    
      
    return relationMap;
    
}


@end
