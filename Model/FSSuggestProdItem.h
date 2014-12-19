//
//  FSSuggestProdItem.h
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSStore.h"
#import "RestKit.h"


@interface FSSuggestProdItem : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSMutableArray * imageUrls;
@property (nonatomic,strong) NSNumber * brandId;
@property (nonatomic, strong) NSString * brand;
@property (nonatomic, strong) FSStore * fromStore;
@property (nonatomic, strong) id comments;
@property (nonatomic, strong) NSNumber * fromUserid;
@property (nonatomic, strong) NSDate * inDate;
@property (nonatomic, strong) NSNumber * suggestType;
@property (nonatomic, strong) NSString * suggestSource;
@property (nonatomic, strong) NSNumber *tagId;
@property (nonatomic,strong) NSString *tagName;
@property (nonatomic, strong) NSNumber * couponTotal;
@property (nonatomic, strong) NSNumber * likeTotal;
@property (nonatomic, strong) NSString * descrip;
@property (nonatomic, strong) NSDecimalNumber * price;
@property (nonatomic, strong) NSString * promotion;
@property (nonatomic, strong) NSNumber * fromLevel;

+(void) setMappingAttribute:(RKObjectMapping *)map;

@end
