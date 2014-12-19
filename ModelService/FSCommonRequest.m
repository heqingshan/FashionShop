//
//  FSCommonRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCommonRequest.h"

@implementation FSCommonRequest
@synthesize routeResourcePath;

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    routeResourcePath = aRouteResourcePath;
    if ([routeResourcePath isEqualToString:RK_REQUEST_KEYWORD_LIST] ||
        [routeResourcePath isEqualToString:RK_REQUEST_CHECK_VERSION]) {
        [self setBaseURL:2];
    }
}

@end
