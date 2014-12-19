//
//  FSMyLetter.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSMyLetter.h"

@implementation FSMyLetter
@synthesize touser,fromuser,isauto,id,isvoice,msg,createdate;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"isauto" toAttribute:@"isauto"];
    [relationMapping mapKeyPath:@"isvoice" toAttribute:@"isvoice"];
    [relationMapping mapKeyPath:@"msg" toAttribute:@"msg"];
    [relationMapping mapKeyPath:@"createdate" toAttribute:@"createdate"];
    
    RKObjectMapping *map = [FSUser getRelationDataMap];
    [relationMapping mapKeyPath:@"touser" toRelationship:@"touser" withMapping:map];
    [relationMapping mapKeyPath:@"fromuser" toRelationship:@"fromuser" withMapping:map];
    
    return relationMapping;
}

@end
