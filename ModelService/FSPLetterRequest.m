//
//  FSPLetterRequest.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPLetterRequest.h"

@implementation FSPLetterRequest
@synthesize userToken,pageSize,nextPage,lastconversationid,touchUser,textmsg,userid;
@synthesize routeResourcePath = _routeResourcePath;

-(NSString *) routeResourcePath
{
    if (!_routeResourcePath)
    {
        return nil;
    }
    return _routeResourcePath;
}

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
    [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    [map mapKeyPath:@"lastconversationid" toAttribute:@"request.lastconversationid"];
    [map mapKeyPath:@"textmsg" toAttribute:@"request.textmsg"];
    [map mapKeyPath:@"touser" toAttribute:@"request.touchUser"];
    [map mapKeyPath:@"userid" toAttribute:@"request.userid"];
}

@end
