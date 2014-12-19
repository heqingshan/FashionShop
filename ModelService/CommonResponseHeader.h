//
//  CommonResponseHeader.h
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface CommonResponseHeader : NSObject
@property(nonatomic,strong) NSNumber * statusCode;
@property(nonatomic,strong) NSNumber * isSuccessful;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) NSString *token;


+(void) setMappingForCommonHeader:(RKObjectMapping *)mapping;
@end
