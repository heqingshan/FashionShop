//
//  FSSuggestListRequest.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSEntityRequestBase.h"

@interface FSSuggestListRequest : FSEntityRequestBase

@property(nonatomic,strong) NSNumber *nextPage;
@property(nonatomic,strong) NSNumber *pageSize;

@end
