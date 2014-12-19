//
//  FSProdItemEntity.h
//  FashionShop
//
//  Created by gong yi on 11/24/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSStore.h"
#import "FSUser.h"
#import "FSBrand.h"

@interface FSProdItemEntity : FSModelBase

//product detail need attributes

@property (nonatomic, assign) NSInteger  id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic,assign) NSInteger couponTotal;
@property (nonatomic,assign) NSInteger favorTotal;
@property (nonatomic,assign) NSInteger likeCount;
@property (nonatomic,strong) NSNumber *price;
@property (nonatomic,strong) NSNumber *unitPrice;
@property (nonatomic, strong) NSString * descrip;
@property (nonatomic) BOOL is4sale;
@property (nonatomic,strong) NSString *upccode;
@property (nonatomic, strong) NSString * contactPhone;

//@property (nonatomic, strong) NSString * recommendUser_id;
//@property (nonatomic, strong) NSString * recommendedReason;
//@property (nonatomic) float unitPrice;
//@property (nonatomic) int shareCount;

@property (nonatomic,strong) FSBrand * brand;
@property (nonatomic, strong) FSUser * fromUser;
@property (nonatomic, strong) FSStore * store;
@property (nonatomic, strong) NSMutableArray *promotions;
@property (nonatomic,strong) NSMutableArray * resource;
//@property (nonatomic,strong) FSTag * tag;

//other need attributes
@property (nonatomic,strong) NSString *brandDesc;
@property (nonatomic,assign) BOOL promotionFlag;
@property (nonatomic,assign) BOOL isCanBuyFlag;
@property (nonatomic,assign) BOOL isFavored;
@property (nonatomic,assign) BOOL isCouponed;
@property (nonatomic,assign) BOOL isCanTalk;

//no need mapping attributes
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic,readonly) BOOL hasPromotion;

/*
@property (nonatomic, assign) NSInteger  type;
@property (nonatomic, strong) NSDate * inDate;
@property (nonatomic,strong) NSMutableArray *coupons;
*/

@end
