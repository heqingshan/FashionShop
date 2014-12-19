//
//  FSExchange.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-8.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSExchange.h"
#import "FSCommon.h"

@implementation FSExchange
@synthesize id,name,desc,createdDate;
@synthesize activeStartDate,activeEndDate;
@synthesize couponStartDate,couponEndDate;
@synthesize notice,minPoints,usageNotice,inScopeNotice;
@synthesize unitPerPoints,amount,rule,exchangeRuleMessage;

@synthesize rules,inscopenotices;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPath:@"id" toAttribute:@"id"];
    [relationMap mapKeyPath:@"name" toAttribute:@"name"];
    [relationMap mapKeyPath:@"des" toAttribute:@"desc"];
    [relationMap mapKeyPath:@"createddate" toAttribute:@"createdDate"];
    [relationMap mapKeyPath:@"activestartdate" toAttribute:@"activeStartDate"];
    [relationMap mapKeyPath:@"activeenddate" toAttribute:@"activeEndDate"];
    [relationMap mapKeyPath:@"couponstartdate" toAttribute:@"couponStartDate"];
    [relationMap mapKeyPath:@"couponenddate" toAttribute:@"couponEndDate"];
    [relationMap mapKeyPath:@"notice" toAttribute:@"notice"];
    [relationMap mapKeyPath:@"minpoints" toAttribute:@"minPoints"];
    [relationMap mapKeyPath:@"usagenotice" toAttribute:@"usageNotice"];
    [relationMap mapKeyPath:@"inscopenotice" toAttribute:@"inScopeNotice"];
    [relationMap mapKeyPath:@"exchangerulemessage" toAttribute:@"exchangeRuleMessage"];
    [relationMap mapKeyPath:@"rule" toAttribute:@"rule"];
    [relationMap mapKeyPath:@"unitperpoints" toAttribute:@"unitPerPoints"];
    [relationMap mapKeyPath:@"amount" toAttribute:@"amount"];
    
    RKObjectMapping *resourceRelationMap = [FSCommon getRelationDataMap];
    [relationMap mapKeyPath:@"inscopenotice" toRelationship:@"inscopenotices" withMapping:resourceRelationMap];
    [relationMap mapKeyPath:@"rule" toRelationship:@"rules" withMapping:resourceRelationMap];
    
    return relationMap;
}

@end

@implementation FSExchangeSuccess

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPath:@"points" toAttribute:@"points"];
    [relationMap mapKeyPath:@"amount" toAttribute:@"amount"];
    [relationMap mapKeyPath:@"id" toAttribute:@"storeProId"];
    [relationMap mapKeyPath:@"code" toAttribute:@"giftCode"];
    [relationMap mapKeyPath:@"exclude" toAttribute:@"exclude"];
    [relationMap mapKeyPath:@"storename" toAttribute:@"storeName"];
    [relationMap mapKeyPath:@"validenddate" toAttribute:@"validEndDate"];
    [relationMap mapKeyPath:@"validstartdate" toAttribute:@"validStartDate"];
    [relationMap mapKeyPath:@"createddate" toAttribute:@"createDate"];
    
    return relationMap;
}

@end

@implementation FSPromotionItem

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPath:@"activeenddate" toAttribute:@"activeStartDate"];
    [relationMap mapKeyPath:@"activestartdate" toAttribute:@"activeEndDate"];
    [relationMap mapKeyPath:@"description" toAttribute:@"description"];
    [relationMap mapKeyPath:@"name" toAttribute:@"name"];
    [relationMap mapKeyPath:@"notice" toAttribute:@"notice"];
    [relationMap mapKeyPath:@"usagenotice" toAttribute:@"usageNotice"];
    
    RKObjectMapping *resourceRelationMap = [FSCommon getRelationDataMap];
    [relationMap mapKeyPath:@"inscopenotice" toRelationship:@"inscopenotices" withMapping:resourceRelationMap];
    
    return relationMap;
}

@end

@implementation FSGiftListItem

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPath:@"id" toAttribute:@"id"];
    [relationMap mapKeyPath:@"code" toAttribute:@"giftCode"];
    [relationMap mapKeyPath:@"createddate" toAttribute:@"createDate"];
    [relationMap mapKeyPath:@"exclude" toAttribute:@"exclude"];
    [relationMap mapKeyPath:@"points" toAttribute:@"points"];
    [relationMap mapKeyPath:@"amount" toAttribute:@"amount"];
    [relationMap mapKeyPath:@"status" toAttribute:@"status"];
    [relationMap mapKeyPath:@"storename" toAttribute:@"storeName"];
    [relationMap mapKeyPath:@"validenddate" toAttribute:@"validEndDate"];
    [relationMap mapKeyPath:@"validstartdate" toAttribute:@"validStartDate"];
    
    RKObjectMapping *resourceRelationMap = [FSPromotionItem getRelationDataMap];
    [relationMap mapKeyPath:@"promotion" toRelationship:@"promotion" withMapping:resourceRelationMap];
    
    return relationMap;
}

@end