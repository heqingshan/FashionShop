//
//  FSAddressRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAddressRequest.h"

@implementation FSAddressRequest
@synthesize id,shippingcontactperson,shippingcontactphone;
@synthesize shippingaddress,shippingzipcde;
@synthesize shippingcity,shippingcityid,shippingprovince,shippingprovinceid,shippingdistrict,shippingdistrictid;
@synthesize userToken,pageSize,nextPage;
@synthesize routeResourcePath=_routeResourcePath;

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    _routeResourcePath = aRouteResourcePath;
}

-(void)setMappingRequestAttribute:(RKObjectMapping *)map
{
    if ([_routeResourcePath isEqualToString:REQUEST_ADDRESS_DETAIL] ||
        [_routeResourcePath isEqualToString:REQUEST_ADDRESS_DELETE]) {
        [map mapKeyPath:@"id" toAttribute:@"request.id"];
    }
    else if ([_routeResourcePath isEqualToString:REQUEST_ADDRESS_CREATE] ||
             [_routeResourcePath isEqualToString:REQUEST_ADDRESS_EDIT]) {
        [map mapKeyPath:@"id" toAttribute:@"request.id"];
        [map mapKeyPath:@"shippingcontactperson" toAttribute:@"request.shippingcontactperson"];
        [map mapKeyPath:@"shippingcontactphone" toAttribute:@"request.shippingcontactphone"];
        [map mapKeyPath:@"shippingaddress" toAttribute:@"request.shippingaddress"];
        [map mapKeyPath:@"shippingzipcode" toAttribute:@"request.shippingzipcde"];
        [map mapKeyPath:@"shippingcity" toAttribute:@"request.shippingcity"];
        [map mapKeyPath:@"shippingcityid" toAttribute:@"request.shippingcityid"];
        [map mapKeyPath:@"shippingprovince" toAttribute:@"request.shippingprovince"];
        [map mapKeyPath:@"shippingprovinceid" toAttribute:@"request.shippingprovinceid"];
        [map mapKeyPath:@"shippingdistrict" toAttribute:@"request.shippingdistrict"];
        [map mapKeyPath:@"shippingdistrictid" toAttribute:@"request.shippingdistrictid"];
    }
    else if([_routeResourcePath isEqualToString:REQUEST_ADDRESS_MY]) {
        [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
        [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    }
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
}

@end
