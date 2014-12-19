//
//  FSAddress.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAddress.h"

@implementation FSAddress
@synthesize id,shippingperson,shippingaddress,shippingphone,shippingzipcode,shippingprovince,shippingprovinceid,shippingcity,shippingcityid,shippingdistrict,shippingdistrictid,userid,displayaddress;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"shippingperson" toAttribute:@"shippingperson"];
    [relationMapping mapKeyPath:@"shippingaddress" toAttribute:@"shippingaddress"];
    [relationMapping mapKeyPath:@"shippingphone" toAttribute:@"shippingphone"];
    [relationMapping mapKeyPath:@"shippingzipcode" toAttribute:@"shippingzipcode"];
    [relationMapping mapKeyPath:@"shippingprovince" toAttribute:@"shippingprovince"];
    [relationMapping mapKeyPath:@"shippingprovinceid" toAttribute:@"shippingprovinceid"];
    [relationMapping mapKeyPath:@"shippingcity" toAttribute:@"shippingcity"];
    [relationMapping mapKeyPath:@"shippingcityid" toAttribute:@"shippingcityid"];
    [relationMapping mapKeyPath:@"shippingdistrict" toAttribute:@"shippingdistrict"];
    [relationMapping mapKeyPath:@"shippingdistrictid" toAttribute:@"shippingdistrictid"];
    [relationMapping mapKeyPath:@"userid" toAttribute:@"userid"];
    [relationMapping mapKeyPath:@"displayaddress" toAttribute:@"displayaddress"];
    
    return relationMapping;
}

@end

@implementation FSAddressDB
@synthesize zipCode,items;
@synthesize province,provinceID,city,cityID,district,districtID;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"zipcode" toAttribute:@"zipCode"];
    [relationMapping mapKeyPath:@"provincename" toAttribute:@"province"];
    [relationMapping mapKeyPath:@"provinceid" toAttribute:@"provinceID"];
    [relationMapping mapKeyPath:@"cityname" toAttribute:@"city"];
    [relationMapping mapKeyPath:@"cityid" toAttribute:@"cityID"];
    [relationMapping mapKeyPath:@"districtname" toAttribute:@"district"];
    [relationMapping mapKeyPath:@"districtid" toAttribute:@"districtID"];
    
    static int index = 0;
    
    if (++index <= 2) {
        [relationMapping mapKeyPath:@"items" toRelationship:@"items" withMapping:relationMapping];
    }
    else{
        index = 0;
    }
    
    return relationMapping;
}

@end
