//
//  FSConfigListRequest.m
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSConfigListRequest.h"

@implementation FSConfigListRequest

@synthesize longit;
@synthesize lantit;
@synthesize routeResourcePath;

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    routeResourcePath = aRouteResourcePath;
    if ([routeResourcePath isEqualToString:RK_REQUEST_CONFIG_GROUP_BRAND_ALL] ||
        [routeResourcePath isEqualToString:RK_REQUEST_CONFIG_BRAND_ALL] ||
        [routeResourcePath isEqualToString:RK_REQUEST_CONFIG_STORE_ALL] ||
        [routeResourcePath isEqualToString:RK_REQUEST_CONFIG_TAG_ALL]) {
        [self setBaseURL:2];
    }
}

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];
}
@end
