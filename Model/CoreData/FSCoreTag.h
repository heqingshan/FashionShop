//
//  FSTag.h
//  FashionShop
//
//  Created by gong yi on 11/29/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCoreModelBase.h"

@interface FSCoreTag : FSCoreModelBase

@property(nonatomic) int32_t id;
@property(nonatomic,retain) NSString * name;
@property(nonatomic) int16_t sort;
@property(nonatomic,retain) NSString* desc;

+ (NSArray *) allLocal;

@end
