//
//  FSUserLoginRequest.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "FSEntityRequestBase.h"


@interface FSUserLoginRequest : FSEntityRequestBase
@property(nonatomic,strong) NSString *thirdPartyUid;
@property(nonatomic,strong) NSString *accessToken;
@property(nonatomic,strong) NSString *nickie;
@property(nonatomic,strong) NSNumber *thirdPartySourceType;
@property(nonatomic,strong) NSString* thumnail;

@end
