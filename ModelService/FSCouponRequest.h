//
//  FSCouponRequest.h
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_COUPON_CREATE @"/promotion/coupon/create"
#define RK_REQUEST_COUPON_PRODCREATE @"/product/coupon/create"
#define  RK_REQUEST_COUPON_LIST @"/user/coupon/list"

@interface FSCouponRequest : FSEntityRequestBase

@property(nonatomic,strong) NSString *userToken;
@property(nonatomic,assign) int productId;
@property(nonatomic,assign) FSSourceType productType;
@property(nonatomic,assign) BOOL includePass;

@end
