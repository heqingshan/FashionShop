//
//  FSUserProfileRequest.m
//  FashionShop
//
//  Created by gong yi on 11/23/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSUserProfileRequest.h"

@implementation FSUserProfileRequest
@synthesize userToken;
@synthesize nickie;
@synthesize phone;

@synthesize routeResourcePath;

-(NSString *) routeResourcePath
{
    return routeResourcePath?routeResourcePath:@"/customer/detail";
}


- (RKRequestMethod) requestMethod{
    return RKRequestMethodPOST;
}



- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"nickname" toAttribute:@"request.nickie"];
    [map mapKeyPath:@"mobile" toAttribute:@"request.phone"];
    [map mapKeyPath:@"gender" toAttribute:@"request.gender"];
    [map mapKeyPath:@"desc" toAttribute:@"request.signature"];

   
}
@end
