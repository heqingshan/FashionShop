//
//  FSItemBase.h
//  FashionShop
//
//  Created by gong yi on 1/9/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSStore.h"

@interface FSItemBase : FSModelBase

@property (nonatomic) int uId;
@property (nonatomic) FSSourceType sourceType;
@property (nonatomic) int sourceId;
@property (nonatomic, strong) NSDate * indate;
@property (nonatomic,strong) NSString * sourceName;
@property (nonatomic,strong) NSMutableArray *resources;
@property (nonatomic, strong) NSMutableArray *promotions;
@property (nonatomic,readonly) BOOL hasPromotion;
@property (nonatomic,strong) FSStore *store;

@end
