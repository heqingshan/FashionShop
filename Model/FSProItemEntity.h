//
//  FSProItemEntity.h
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityBase.h"
#import "FSModelBase.h"
#import "FSStore.h"
#import "FSResource.h"
//#import "FSUser.h"
#import "FSTag.h"

@interface FSProItemEntity : FSModelBase

//product detail need attributes

@property (nonatomic, assign) NSInteger  id;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic,assign) NSInteger couponTotal;
@property (nonatomic,assign) NSInteger favorTotal;
@property (nonatomic, strong) NSString * descrip;
@property (nonatomic,strong) NSNumber* isProductBinded;
@property (nonatomic, strong) FSStore * store;
@property (nonatomic,strong) NSMutableArray * resource;
//@property (nonatomic) int sharecount;
//@property (nonatomic, strong) FSTag * tag;

//other need attributes
@property (nonatomic) int targetType;
@property (nonatomic,strong) NSString *targetId;
@property (nonatomic,assign) BOOL isFavored;
@property (nonatomic,assign) BOOL isCouponed;

//no need mapping attributes
@property (nonatomic,assign) int height;//单元格高度，可合理利用
@property (nonatomic, strong) NSMutableArray *comments;

/*
@property (nonatomic,assign) double storeDistance;
@property (nonatomic, assign) NSInteger  type;

@property (nonatomic, strong) NSString * proImgs;
@property (nonatomic, strong) FSUser * fromUser;
@property (nonatomic, strong) NSDate * inDate;

@property (nonatomic,strong) NSMutableArray *coupons;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic) int tagId;


@property (nonatomic,assign) BOOL isPublication;
@property (nonatomic,strong) NSNumber *limitCount;

@property (nonatomic,strong) NSNumber *promotionid;

*/

@end
