//
//  FSCommonUserRequest.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"
#import "FSComment.h"


#define RK_REQUEST_POINT_LIST @"/point/list"
#define RK_REQUEST_LIKE_LIST @"/like/list"
#define RK_REQUEST_COUPON_LIST @"/coupon/list"
#define RK_REQUEST_DAREN_DETAIL @"/customer/show"
#define RK_REQUEST_LIKE_DO @"/like/create"
#define RK_REQUEST_LIKE_REMOVE @"/like/destroy"
#define RK_REQUEST_PRO_BOTH_LIST @"/items/list"

@interface FSCommonUserRequest : FSEntityRequestBase

@property(nonatomic,strong) NSString *userToken;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSNumber *pageIndex;
@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSNumber *sort;
@property(nonatomic,strong) NSNumber * likeType; //0-i like;1-- like me
@property(nonatomic,strong) NSString *likeTypeName;
@property(nonatomic,strong) NSString *likeUserId;

@property(nonatomic,strong) NSDate * previousLatestDate;
@property(nonatomic,assign) int requestType; //0:latest query, 1: more query
@property(nonatomic,strong) NSString *requestTypeName;

@end
