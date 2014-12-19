//
//  FSFavor.h
//  FashionShop
//
//  Created by gong yi on 12/3/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSStore.h"

@interface FSFavor : FSModelBase

@property (nonatomic) int id;
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
