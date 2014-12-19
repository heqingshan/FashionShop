//
//  FSProItems.m
//  FashionShop
//
//  Created by gong yi on 11/22/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProItems.h"
#import "FSProItemEntity.h"

@implementation FSProItems

@synthesize currentPageIndex,pageSize,totalCount,totalPageCount;
@synthesize items;


+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"pageindex",@"currentPageIndex",@"pagesize",@"pageSize",@"totalcount",@"totalCount",@"totalpaged",@"totalPageCount",nil];
    
    
    NSString *relationKeyPath = @"promotions";
    RKObjectMapping *promRelationMap = [FSProItemEntity getRelationDataMap];
    [relationMap mapKeyPath:relationKeyPath toRelationship:@"items" withMapping:promRelationMap];
    
    return relationMap;

}
@end
