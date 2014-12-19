//
//  FSPagedModel.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSPagedModel.h"

@implementation FSPagedModel
@synthesize currentPageIndex,pageSize,totalCount,totalPageCount,isPaged;
@synthesize items;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"pageindex",@"currentPageIndex",@"pagesize",@"pageSize",@"totalcount",@"totalCount",@"totalpaged",@"totalPageCount",@"ispaged",@"isPaged",nil];
   
    NSString *relationKeyPath = [self pagedKeyPath];
    RKObjectMapping *promRelationMap = [[self pagedModel] getRelationDataMap];
    [relationMap mapKeyPath:relationKeyPath toRelationship:@"items" withMapping:promRelationMap];
    
    return relationMap;
}



@end
