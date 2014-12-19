//
//  FSExchangeRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-7.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSExchangeRequest.h"

@implementation FSExchangeRequest
@synthesize routeResourcePath=_routeResourcePath;

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    _routeResourcePath = aRouteResourcePath;
    if ([aRouteResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_LIST] ||
        [aRouteResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_DETAIL]) {
        [self setBaseURL:2];
    }
}

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    if ([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_LIST]) {
        [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
        [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_DETAIL])
    {
        [map mapKeyPath:@"id" toAttribute:@"request.id"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_AMOUNT])
    {
        [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
        [map mapKeyPath:@"storepromotionid" toAttribute:@"request.storePromotionId"];
        [map mapKeyPath:@"points" toAttribute:@"request.points"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_EXCHANGE])
    {
        [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
        [map mapKeyPath:@"storepromotionid" toAttribute:@"request.storePromotionId"];
        [map mapKeyPath:@"points" toAttribute:@"request.points"];
        [map mapKeyPath:@"identityno" toAttribute:@"request.identityNo"];
        [map mapKeyPath:@"storeid" toAttribute:@"request.storeID"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_COUPON_LIST])
    {
        [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
        [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
        [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
        [map mapKeyPath:@"type" toAttribute:@"request.type"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_COUPON_DETAIL])
    {
        [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
        [map mapKeyPath:@"storecouponid" toAttribute:@"request.storeCouponId"];
    }
    else if([_routeResourcePath isEqualToString:RK_REQUEST_STOREPROMOTION_CANCEL])
    {
        [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
        [map mapKeyPath:@"storecouponid" toAttribute:@"request.storeCouponId"];
    }
}

@end
