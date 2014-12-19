//
//  FSKeyword.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSKeyword.h"
#import "FSBrand.h"
#import "FSStore.h"

@implementation FSKeyword

@synthesize brandWords,keyWords,stores;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    
    NSString *relationKeyPath = @"brandwords";
    RKObjectMapping *promRelationMap = [FSBrand getRelationDataMap];
    [relationMap mapKeyPath:relationKeyPath toRelationship:@"brandWords" withMapping:promRelationMap];
    
    relationKeyPath = @"words";
    [relationMap mapKeyPath:relationKeyPath toAttribute:@"keyWords"];
    
    relationKeyPath = @"stores";
    promRelationMap = [FSStore getRelationDataMap];
    [relationMap mapKeyPath:relationKeyPath toRelationship:@"stores" withMapping:promRelationMap];
    
    return relationMap;
}

@end
