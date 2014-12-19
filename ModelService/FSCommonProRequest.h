//
//  FSProUploadRequest.h
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"
#import "FSComment.h"


#define RK_REQUEST_PRO_UPLOAD @"/promotion/create"
#define RK_REQUEST_PRO_DETAIL @"/promotion/detail"
#define RK_REQUEST_PRO_REMOVE @"/promotion/destroy"
#define RK_REQUEST_PRO_AVAILOPERATIONS @"/promotion/availoperations"    //获取当前用户对促销详情的操作权限
#define RK_REQUEST_PROD_UPLOAD @"/product/create"
#define RK_REQUEST_PROD_DETAIL @"/product/detail"
#define RK_REQUEST_PROD_REMOVE @"/product/destroy"
#define RK_REQUEST_PROD_AVAILOPERATIONS @"/product/availoperations"     //获取当前用户对产品详情的操作权限
#define RK_REQUEST_TAG_PROPERTIES  @"/tag/property"    //获取tagid对应的商品属性

@interface FSCommonProRequest : FSEntityRequestBase<RKRequestDelegate>

@property(nonatomic,strong) NSString *uToken;
@property(nonatomic,strong) NSMutableArray *imgs;
@property(nonatomic,strong) NSNumber * storeId;
@property(nonatomic,strong) NSString *storeName;
@property(nonatomic,strong) NSNumber * tagId;
@property(nonatomic,strong) NSString *tagName;
@property(nonatomic,strong) NSString *descrip;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSNumber * brandId;
@property(nonatomic,strong) NSString * brandName;
@property(nonatomic,strong) NSNumber *id;
@property(nonatomic,strong) NSNumber *longit;
@property(nonatomic,strong) NSNumber *lantit;
@property(nonatomic,strong) NSDate* startdate;
@property(nonatomic,strong) NSDate* enddate;
@property(nonatomic,strong) NSNumber *price;
@property(nonatomic,strong) NSNumber *originalPrice;
@property(nonatomic,strong) FSComment *comment;
@property(nonatomic) FSSourceType pType;
@property(nonatomic,strong) NSString *fileName;
@property(nonatomic,strong) NSNumber *is4sale;
@property(nonatomic,strong) NSString *property;
@property(nonatomic,strong) NSNumber *sizeIndex;
@property(nonatomic,strong) NSString *upccode;

@property(nonatomic,strong) NSString *pID;

- (void)upload:(dispatch_block_t)blockcomplete error:(dispatch_block_t)blockerror;
- (void)clean;
@end
