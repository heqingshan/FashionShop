//
//  FSSuggestProItem.h
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSStore.h"
#import "RestKit.h"

@interface FSSuggestProItem : NSObject
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) FSStore * store;
@property (nonatomic, strong) NSString * descrip;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * proImgs;
@property (nonatomic, strong) NSNumber * fromUserId;
@property (nonatomic, strong) NSString * fromUserName;
@property (nonatomic, strong) NSDate * inDate;


+(void) setMappingAttribute:(RKObjectMapping *)map;


@end
