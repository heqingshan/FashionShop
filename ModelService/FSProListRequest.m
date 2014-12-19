//
//  FSProListRequest.m
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProListRequest.h"
#import "RestKit.h"

@implementation FSProListRequest

@synthesize longit,lantit,nextPage,pageSize,filterType;
@synthesize previousLatestDate,previousMaxTransactionId,requestType=_requestType,requestTypeName;
@synthesize tagid;
@synthesize drUserId;
@synthesize brandId;
@synthesize topicId;
@synthesize promotionId;
@synthesize keyword;
@synthesize searchType;
@synthesize storeid;
@synthesize routeResourcePath=_routeResourcePath;

-(NSString *) routeResourcePath
{
//    if (!_routeResourcePath)
//        _routeResourcePath = RK_REQUEST_PRO_LIST;
    return _routeResourcePath;
}

-(void)setRouteResourcePath:(NSString *)aRouteResourcePath
{
    _routeResourcePath = aRouteResourcePath;
    if ([aRouteResourcePath isEqualToString:RK_REQUEST_PROD_SEARCH_LIST] ||
        [aRouteResourcePath isEqualToString:RK_REQUEST_PROD_LIST] ||
        [aRouteResourcePath isEqualToString:RK_REQUEST_PRO_LIST] ||
        [aRouteResourcePath isEqualToString:RK_REQUEST_PRO_BANNER_LIST]) {
        [self setBaseURL:2];
    }
}

- (RKRequestMethod) requestMethod{
    return RKRequestMethodGET;
}

-(void)setRequestType:(int)requestType
{
    _requestType = requestType;
    if (_requestType ==0 )
        requestTypeName = @"refresh";
}

- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];
    [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
    [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    [map mapKeyPath:@"sort" toAttribute:@"request.filterType"];
    [map mapKeyPath:@"refreshts" toAttribute:@"request.previousLatestDate"];
    [map mapKeyPath:@"type" toAttribute:@"request.requestTypeName"];
    [map mapKeyPath:@"tagid" toAttribute:@"request.tagid"];
    [map mapKeyPath:@"userid" toAttribute:@"request.drUserId"];
    [map mapKeyPath:@"brandid" toAttribute:@"request.brandId"];
    [map mapKeyPath:@"topicid" toAttribute:@"request.topicId"];
    [map mapKeyPath:@"promotionid" toAttribute:@"request.promotionId"];
    [map mapKeyPath:@"term" toAttribute:@"request.keyword"];
    [map mapKeyPath:@"storeid" toAttribute:@"request.storeid"];
}


@end
