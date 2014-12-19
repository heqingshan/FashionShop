//
//  FSPoint.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSPoint : FSModelBase

@property(nonatomic,assign) int32_t id;
@property(nonatomic,strong) NSString *getReason;
@property(nonatomic,strong) NSDate *inDate;
@property(nonatomic,assign) int32_t amount;
@property(nonatomic,strong) NSString *title;

@end
