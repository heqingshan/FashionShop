//
//  JsonInfoBase.m
//  Monogram
//
//  Created by Junyu Chen on 3/17/2012.
//  Copyright (c) 2012 Fara Inc. All rights reserved.
//


#import "CommonHeader.h"
#import "UIDevice+Extention.h"
#import "NSString+Extention.h"

#define UNIQUE_DEVICE_IDENTIFIER @"UNIQUE_DEVICE_IDENTIFIER"
@implementation CommonHeader


- (NSString *)version{
    return REST_API_CLIENT_VERSION;
}

- (NSString *)uid{
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] objectForKey:UNIQUE_DEVICE_IDENTIFIER];
    if ([NSString isNilOrEmpty:deviceId]){
        deviceId=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
        [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:UNIQUE_DEVICE_IDENTIFIER];
    }
    return deviceId;
}

- (NSString *)sign{
    NSMutableString *hashResult = [@"" mutableCopy];
    [hashResult appendString:REST_API_APP_SECRET_KEY];
    [hashResult appendFormat:@"%@%@",@"client_version",[self version]];
    [hashResult appendFormat:@"%@%@",@"uid",[self uid]];
    [hashResult appendString:REST_API_APP_SECRET_KEY];
    hashResult = [[hashResult MD5] uppercaseString];
    return hashResult;
}

- (NSMutableDictionary *) toQueryDic{
    NSMutableDictionary *dic = [@{} mutableCopy];
    [dic setValue:[self uid] forKey:@"uid"];
    [dic setValue:[self version] forKey:@"client_version"];
    [dic setValue:[self sign] forKey:@"sign"];
    
    return dic;
}
@end
