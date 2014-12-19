//
//  FSCardInfo.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCardInfo.h"

@implementation FSCardInfo
@synthesize cardNo,cardLevel;
@synthesize id;
@synthesize amount;
@synthesize type;
@synthesize lastDate;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPath:@"id" toAttribute:@"id"];
    [relationMap mapKeyPath:@"cardno" toAttribute:@"cardNo"];
    [relationMap mapKeyPath:@"amount" toAttribute:@"amount"];
    [relationMap mapKeyPath:@"lastdate" toAttribute:@"lastDate"];
    [relationMap mapKeyPath:@"lvl" toAttribute:@"cardLevel"];
    [relationMap mapKeyPath:@"type" toAttribute:@"type"];
    
    return relationMap;
}

@end
