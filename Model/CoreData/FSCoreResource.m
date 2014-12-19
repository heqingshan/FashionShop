//
//  FSCoreResource.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreResource.h"

@implementation FSCoreResource
@synthesize domain;
@synthesize relativePath;
@synthesize height;
@synthesize width;
@synthesize type;
@synthesize order;

+(RKObjectMapping *)getRelationDataMap:(Class)type withParentMap:(RKObjectMapping *)parentMap
{
    RKManagedObjectStore *objectStore = [FSModelManager sharedManager].objectStore;
    RKManagedObjectMapping *relationMap = [RKManagedObjectMapping mappingForClass:[self class] inManagedObjectStore:objectStore];
    [relationMap mapKeyPathsToAttributes:@"domain",@"domain",@"name",@"relativePath",@"height",@"height",@"width",@"width",@"order",@"order",@"type",@"type",nil];
    return relationMap;
}

@end
