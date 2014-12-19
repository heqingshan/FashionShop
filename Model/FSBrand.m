//
//  FSBrand.m
//  FashionShop
//
//  Created by gong yi on 12/5/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSBrand.h"
#import "FSCoreBrand.h"

@implementation FSBrand

@synthesize  id;
@synthesize name;
@synthesize descrip;
@synthesize homeSite;
@synthesize logo;


+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class] ];
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [relationMapping mapKeyPath:@"description" toAttribute:@"descrip"];
    [relationMapping mapKeyPath:@"website" toAttribute:@"homeSite"];
    [relationMapping mapKeyPath:@"log" toAttribute:@"logo"];
    
    return relationMapping;
}

+(NSArray *) allBrandsLocal
{
    return [FSCoreBrand findAllSortedBy:@"name" ascending:true];
}
@end
