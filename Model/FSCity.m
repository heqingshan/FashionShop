//
//  FSCity.m
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCity.h"

@implementation FSCity

@synthesize id,name,longit,lantit;

+(RKObjectMapping *)mapAttributes
{
    RKObjectMapping *map = [RKObjectMapping mappingForClass:[FSCity class]];
    [map mapKeyPath:@"outsitetoken" toAttribute:@"request.accessToken"];
    [map mapKeyPath:@"outsiteuid" toAttribute:@"request.thirdPartyUid"];
    [map mapKeyPath:@"outsitenickname" toAttribute:@"request.nickie"];
    [map mapKeyPath:@"outsitetype" toAttribute:@"request.thirdPartySourceType"];
    return map;
}
@end
