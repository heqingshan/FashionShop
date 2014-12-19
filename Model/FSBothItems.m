//
//  FSBothItems.m
//  FashionShop
//
//  Created by gong yi on 11/24/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSBothItems.h"
#import "FSProItemEntity.h"
#import "FSProdItemEntity.h"

@implementation FSBothItems
@synthesize currentPageIndex,pageSize,totalCount,totalPageCount;
@synthesize prodItems,proItems;


+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"pageindex",@"currentPageIndex",@"pagesize",@"pageSize",@"totalcount",@"totalCount",@"totalpaged",@"totalPageCount",nil];
    
    
    NSString *relationKeyPath = @"promotions";
    RKObjectMapping *promRelationMap = [FSProItemEntity getRelationDataMap];
    [relationMap mapKeyPath:relationKeyPath toRelationship:@"proItems" withMapping:promRelationMap];
    
    NSString *relationpKeyPath = @"products";
    RKObjectMapping *prodRelationMap = [FSProdItemEntity getRelationDataMap];
    [relationMap mapKeyPath:relationpKeyPath toRelationship:@"prodItems" withMapping:prodRelationMap];
    
    return relationMap;
    
}
@end
