//
//  FSConfigListRequest.h
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"


#define RK_REQUEST_CONFIG_BRAND_ALL @"/brand/all"
#define RK_REQUEST_CONFIG_STORE_ALL @"/store/all"
#define RK_REQUEST_CONFIG_TAG_ALL @"/tag/all"
#define RK_REQUEST_CONFIG_GROUP_BRAND_ALL @"/brand/groupall"

@interface FSConfigListRequest : FSEntityRequestBase

@property (nonatomic,strong) NSNumber * longit;
@property (nonatomic,strong) NSNumber * lantit;


@end
