//
//  FSCommonUserRequest.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCommonUserRequest.h"

@implementation FSCommonUserRequest

@synthesize userToken;
@synthesize userId;
@synthesize pageIndex;
@synthesize pageSize;
@synthesize sort;
@synthesize likeType=_likeType;
@synthesize likeTypeName;
@synthesize routeResourcePath;
@synthesize likeUserId;
@synthesize previousLatestDate;
@synthesize requestType = _requestType;
@synthesize requestTypeName;

-(void)setLikeType:(NSNumber *)likeType
{
    _likeType = likeType;
    switch ([likeType intValue]) {
        case 0:
            likeTypeName = @"like";
            break;
        case 1:
            likeTypeName = @"liked";
            break;
        default:
            break;
    }
}

-(void)setRequestType:(int)requestType
{
    _requestType = requestType;
    if (_requestType ==0 )
        requestTypeName = @"refresh";
}

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"sort" toAttribute:@"request.sort"];
    [map mapKeyPath:@"page" toAttribute:@"request.pageIndex"];
    [map mapKeyPath:@"type" toAttribute:@"request.likeType"];
    [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    [map mapKeyPath:@"userid" toAttribute:@"request.userId"];
    [map mapKeyPath:@"likeduserid" toAttribute:@"request.likeUserId"];

}
@end
