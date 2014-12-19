//
//  FSCardRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-3-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCardRequest.h"

@implementation FSCardRequest
@synthesize cardNo;
@synthesize passWord;
@synthesize userToken;
@synthesize routeResourcePath;

- (RKRequestMethod) requestMethod{
    if ([self.routeResourcePath isEqualToString:RK_REQUEST_USER_CARD_BIND]) {
        return RKRequestMethodPOST;
    }
    return RKRequestMethodPUT;
}

- (void) setMappingRequestAttribute:(RKObjectMapping *)map{
    [map mapKeyPath:@"cardno" toAttribute:@"request.cardNo"];
    [map mapKeyPath:@"password" toAttribute:@"request.passWord"];
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
}

@end
