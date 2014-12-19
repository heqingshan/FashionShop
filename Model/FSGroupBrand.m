//
//  FSGroupBrand.m
//  FashionShop
//
//  Created by HeQingshan on 13-2-8.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSGroupBrand.h"
#import "FSBrand.h"

@implementation FSGroupBrand
@synthesize groupName;
@synthesize groupList;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class] ];
    [relationMapping mapKeyPath:@"groupname" toAttribute:@"groupName"];
    RKObjectMapping *resourceRelationMap = [FSBrand getRelationDataMap];
    [relationMapping mapKeyPath:@"groupval" toRelationship:@"groupList" withMapping:resourceRelationMap];
    
    return relationMapping;
}

@end

@implementation FSGroupBrandList
@synthesize brandList;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class] ];
    RKObjectMapping *resourceRelationMap = [FSGroupBrand getRelationDataMap];
    [relationMapping mapKeyPath:@"values" toRelationship:@"brandList" withMapping:resourceRelationMap];
    
    return relationMapping;
}

+(NSArray *) allBrandsLocal
{
    return theApp.allBrands;
}

@end
