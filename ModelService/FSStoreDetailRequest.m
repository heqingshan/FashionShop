//
//  FSStoreDetailRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-21.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSStoreDetailRequest.h"

@implementation FSStoreDetailRequest
@synthesize routeResourcePath=_routeResourcePath;

-(NSString*)routeResourcePath
{
    return REQUEST_STORE_DETAIL;
}

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    _routeResourcePath = aRouteResourcePath;
    if ([_routeResourcePath isEqualToString:REQUEST_STORE_DETAIL]) {
        [self setBaseURL:2];
    }
}

-(void)setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];
    [map mapKeyPath:@"id" toAttribute:@"request.storeid"];
}

@end
