//
//  FSDeviceRegisterRequest.m
//  FashionShop
//
//  Created by gong yi on 11/29/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSDeviceRegisterRequest.h"

@implementation FSDeviceRegisterRequest

@synthesize longit;
@synthesize lantit;
@synthesize deviceName;
@synthesize deviceToken;
@synthesize userToken;
@synthesize userId;

-(NSString *)routeResourcePath
{
    return RK_REQUEST_DEVICE_REGISTER;
}


- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"devicetoken" toAttribute:@"request.deviceToken"];
    [map mapKeyPath:@"userid" toAttribute:@"request.userId"];
    
}

@end
