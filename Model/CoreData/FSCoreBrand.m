//
//  FSBrand.m
//  FashionShop
//
//  Created by gong yi on 12/1/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCoreBrand.h"
#import "FSModelManager.h"

@implementation FSCoreBrand
@dynamic descrip;
@dynamic homeSite;
@dynamic id;
@dynamic logo;
@dynamic name;


+(RKObjectMapping *)getRelationDataMap:(Class)type withParentMap:(RKObjectMapping *)parentMap
{
    RKManagedObjectStore *objectStore = [FSModelManager sharedManager].objectStore;
    RKManagedObjectMapping *relationMapping = [RKManagedObjectMapping mappingForClass:[self class] inManagedObjectStore:objectStore];
    relationMapping.primaryKeyAttribute = @"id";
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [relationMapping mapKeyPath:@"description" toAttribute:@"descrip"];
    [relationMapping mapKeyPath:@"website" toAttribute:@"homeSite"];
    [relationMapping mapKeyPath:@"log" toAttribute:@"log"];
   
    return relationMapping;
}
@end
