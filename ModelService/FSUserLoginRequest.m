//
//  FSUserLoginRequest.m
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSUserLoginRequest.h"
#import "RestKit.h"

@implementation FSUserLoginRequest
@synthesize thirdPartySourceType,thirdPartyUid;
@synthesize accessToken;
@synthesize nickie;
@synthesize thumnail;

-(NSString *)routeResourcePath{
    return @"/customer/outsitelogin";
}


- (RKRequestMethod) requestMethod{
    return RKRequestMethodPOST;
}

- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"outsitetoken" toAttribute:@"request.accessToken"];
    [map mapKeyPath:@"outsiteuid" toAttribute:@"request.thirdPartyUid"];
    [map mapKeyPath:@"outsitenickname" toAttribute:@"request.nickie"];
    [map mapKeyPath:@"outsitetype" toAttribute:@"request.thirdPartySourceType"];
    [map mapKeyPath:@"thumnailurl" toAttribute:@"request.thumnail"];
}

@end

