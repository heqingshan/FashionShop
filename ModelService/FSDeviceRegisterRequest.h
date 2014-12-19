//
//  FSDeviceRegisterRequest.h
//  FashionShop
//
//  Created by gong yi on 11/29/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"
#define RK_REQUEST_DEVICE_REGISTER @"/device/register"

@interface FSDeviceRegisterRequest : FSEntityRequestBase

@property(nonatomic,strong) NSNumber* longit;
@property(nonatomic,strong) NSNumber *lantit;
@property(nonatomic,strong) NSString * deviceToken;
@property(nonatomic,strong) NSString * deviceName;
@property(nonatomic,strong) NSString * userToken;
@property(nonatomic,strong) NSString * userId;

@end
