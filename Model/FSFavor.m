//
//  FSFavor.m
//  FashionShop
//
//  Created by gong yi on 12/3/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSFavor.h"
#import "FSResource.h"
#import "FSProItemEntity.h"

@implementation FSFavor

@synthesize id;
@synthesize sourceId;
@synthesize sourceType;
@synthesize indate;
@synthesize uId;
@synthesize sourceName;
@synthesize store;
@synthesize resources;
@synthesize hasPromotion;
@synthesize promotions;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"id",@"id",@"productid",@"sourceId",@"producttype",@"sourceType",@"productname",@"sourceName",@"uId",@"uId",nil];
    RKObjectMapping *resourceRelationMap = [FSResource getRelationDataMap];
    [relationMap mapKeyPath:@"resources" toRelationship:@"resources" withMapping:resourceRelationMap];
    RKObjectMapping *storeRelationMap = [FSStore getRelationDataMap];
    [relationMap mapKeyPath:@"store" toRelationship:@"store" withMapping:storeRelationMap];
    RKObjectMapping *promotionRelationMap = [FSProItemEntity getRelationDataMap];
    [relationMap mapKeyPath:@"promotions" toRelationship:@"promotions" withMapping:promotionRelationMap];
    return relationMap;
}

-(BOOL)hasPromotion
{
    if (sourceType == FSSourcePromotion) {
        return NO;
    }
    if (!promotions) {
        return NO;
    }
    if (promotions.count > 0) {
        for (FSProItemEntity *item in promotions) {
            return YES;
//            if (item.isPublication) {
//                return YES;
//            }
        }
        return NO;
    }
    return NO;
}

@end
