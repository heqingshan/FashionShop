//
//  FSStoreDetailRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-21.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define REQUEST_STORE_DETAIL @"/store/detail"

@interface FSStoreDetailRequest : FSEntityRequestBase

@property(nonatomic) int storeid;
@property(nonatomic,strong) NSNumber* longit;
@property(nonatomic,strong) NSNumber *lantit;

@end
