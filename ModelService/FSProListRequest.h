//
//  FSProListRequest.h
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"
#import "FSProductListViewController.h"

#define RK_REQUEST_PRO_LIST  @"/promotion/list"
#define RK_REQUEST_PROD_LIST @"/product/list"
#define RK_REQUEST_PROD_DR_LIST @"/product/daren/list"
#define RK_REQUEST_PROD_SEARCH_LIST @"/product/search"
#define RK_REQUEST_PRO_BANNER_LIST @"/banner/list"

@interface FSProListRequest : FSEntityRequestBase

@property (nonatomic) FSPageType pageType;
@property(nonatomic,strong) NSNumber* longit;
@property(nonatomic,strong) NSNumber *lantit;
@property(nonatomic,assign) int nextPage;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) FSProSortType filterType;
@property(nonatomic,assign) int previousMaxTransactionId;
@property(nonatomic,strong) NSDate * previousLatestDate;
@property(nonatomic,assign) int requestType; //0:latest query, 1: more query
@property(nonatomic,strong) NSString *requestTypeName;
@property(nonatomic,strong) NSNumber * tagid;
@property(nonatomic,strong) NSNumber * drUserId;
@property(nonatomic,strong) NSNumber *brandId;
@property(nonatomic,strong) NSNumber *topicId;
@property(nonatomic,strong) NSNumber *promotionId;
@property(nonatomic,strong) NSString *keyword;//关键字
@property(nonatomic,assign) FSProdSortType searchType;
@property(nonatomic,assign) int storeid;

@end
