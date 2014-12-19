//
//  FSSuggestProItem.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSSuggestProItem.h"

@implementation FSSuggestProItem


@synthesize id;
@synthesize startDate;
@synthesize store;
@synthesize title;
@synthesize type;
@synthesize descrip;
@synthesize endDate;
@synthesize proImgs;
@synthesize fromUserId;
@synthesize fromUserName;
@synthesize inDate;

+(void) setMappingAttribute:(RKObjectMapping *)map{
    //todo:set map
}
@end
