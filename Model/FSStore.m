//
//  FSStore.m
//  FashionShop
//
//  Created by gong yi on 12/5/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSStore.h"

@implementation FSStore
@synthesize   id;
@synthesize name;
@synthesize descrip;
@synthesize phone;
@synthesize address;
@synthesize longit;
@synthesize lantit;
@synthesize distance;
@synthesize resource;

+(RKObjectMapping *) getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPathsToAttributes:@"id",@"id",@"name",@"name",@"location",@"address",@"tel",@"phone",@"lng",@"longit",@"lat",@"lantit",@"distance",@"distance",@"description",@"descrip",nil];
    RKObjectMapping *resourceRelationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"resources" toRelationship:@"logoBg" withMapping:resourceRelationMap];
    return relationMapping;
}

-(NSURL*)storeLogoBg
{
    if (!_logoBg)
        return nil;
    return [_logoBg absoluteUr:320 height:200];
}

@end
