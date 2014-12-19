//
//  FSFavorRequest.h
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_FAVOR_DO @"/promotion/favor"
#define RK_REQUEST_FAVOR_PROD_DO @"/product/favor"
#define RK_REQUEST_FAVOR_LIST @"/favorite/list"
#define RK_REQUEST_FAVOR_REMOVE @"/favorite/destroy"
#define RK_REQUEST_FAVOR_PRO_REMOVE @"/promotion/favor/destroy"
#define RK_REQUEST_FAVOR_PROD_REMOVE @"/product/favor/destroy"
#define RK_REQUEST_FAVOR_PROD_LIST @"/favorite/daren/list"

@interface FSFavorRequest : FSEntityRequestBase

@property(nonatomic,strong) NSString *userToken;
@property(nonatomic,strong) NSNumber * productId;
@property(nonatomic,assign) FSSourceType productType;
@property(nonatomic,strong) NSNumber *id;

@property(nonatomic,strong) NSNumber* longit;
@property(nonatomic,strong) NSNumber *lantit;
@property(nonatomic,strong) NSNumber * nextPage;
@property(nonatomic,strong) NSNumber * pageSize;
@property(nonatomic,strong) NSNumber *userid;

@end
