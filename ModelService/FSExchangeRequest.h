//
//  FSExchangeRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-7.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_STOREPROMOTION_LIST @"/storepromotion/list"//积点兑换活动列表
#define RK_REQUEST_STOREPROMOTION_DETAIL @"/storepromotion/detail"//积点兑换活动详情
#define RK_REQUEST_STOREPROMOTION_AMOUNT @"/storepromotion/amount"//积点兑换金钱

#define RK_REQUEST_STOREPROMOTION_EXCHANGE @"/storepromotioncoupon/exchange"
#define RK_REQUEST_STOREPROMOTION_COUPON_LIST @"/storepromotioncoupon/list"//代金券列表
#define RK_REQUEST_STOREPROMOTION_COUPON_DETAIL @"/storepromotioncoupon/detail"//代金券详情
#define RK_REQUEST_STOREPROMOTION_CANCEL @"/storepromotioncoupon/void"//取消兑换

@interface FSExchangeRequest : FSEntityRequestBase

@property(nonatomic,strong) NSString *userToken;
@property(nonatomic) int nextPage;
@property(nonatomic) int pageSize;
@property(nonatomic) int id;//兑换活动ID
@property(nonatomic) int storePromotionId;//兑换活动ID
@property(nonatomic) int points;//需要兑换的积点数
@property(nonatomic,strong) NSString *identityNo;//身份证号
@property(nonatomic) int type;//代金券类型
@property(nonatomic) int storeID;//实体店ID
@property(nonatomic) int storeCouponId;

@end
