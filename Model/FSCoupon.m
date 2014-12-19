//
//  FSCoupon.m
//  FashionShop
//
//  Created by gong yi on 12/5/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCoupon.h"

@implementation FSCoupon

@synthesize id;
@synthesize code;
@synthesize productid;
@synthesize producttype;
@synthesize productname;
@synthesize product;
@synthesize promotion;
@synthesize pass;
@synthesize beginDate;
@synthesize endDate;
@synthesize isUsed;
@synthesize status;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
   
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"code" toAttribute:@"code"];
    [relationMapping mapKeyPath:@"productid" toAttribute:@"productid"];
    [relationMapping mapKeyPath:@"productname" toAttribute:@"productname"];
    [relationMapping mapKeyPath:@"producttype" toAttribute:@"producttype"];
    [relationMapping mapKeyPath:@"pass" toAttribute:@"pass"];
    [relationMapping mapKeyPath:@"validstartdate" toAttribute:@"beginDate"];
    [relationMapping mapKeyPath:@"validenddate" toAttribute:@"endDate"];
    [relationMapping mapKeyPath:@"isused" toAttribute:@"isUsed"];
    [relationMapping mapKeyPath:@"status" toAttribute:@"status"];
    RKObjectMapping *prodRelationMap = [FSProdItemEntity getRelationDataMap];
    [relationMapping mapKeyPath:@"product" toRelationship:@"product" withMapping:prodRelationMap];
    RKObjectMapping *proRelationMap = [FSProItemEntity getRelationDataMap];
    [relationMapping mapKeyPath:@"promotion" toRelationship:@"promotion" withMapping:proRelationMap];
    
    
    return relationMapping;
}

-(BOOL)isExpired
{
    if (!endDate ||
        [endDate compare:[[NSDate alloc] init]]==NSOrderedAscending)
    {
        return YES;
    }
    return NO;
}
@end
