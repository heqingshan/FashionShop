//
//  FSSuggestEntity.h
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSuggestProdItem.h"
#import "FSSuggestProItem.h"
#import "CommonResponseHeader.h"
#import "FSEntityBase.h"

@interface FSSuggestEntity :FSEntityBase

@property (nonatomic,strong) NSMutableArray *products;
@property (nonatomic,strong) NSMutableArray *promotions;


+(void) setMappingListRequestAttribute:(RKObjectMapping *)map;
+(void) setMappingAttribute:(RKObjectMapping *)map;
@end
