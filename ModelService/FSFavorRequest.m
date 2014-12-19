//
//  FSFavorRequest.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSFavorRequest.h"

@implementation FSFavorRequest

@synthesize userToken,productId,productType;
@synthesize routeResourcePath=_routeResourcePath;
@synthesize id;
@synthesize pageSize;
@synthesize nextPage;
@synthesize longit;
@synthesize lantit;
@synthesize userid;

-(NSString *) routeResourcePath
{
    if (!_routeResourcePath)
    {
        if (productType == FSSourcePromotion)
        _routeResourcePath = RK_REQUEST_FAVOR_DO;
        else
        {
            _routeResourcePath = RK_REQUEST_FAVOR_PROD_DO;
        }
    }
    return _routeResourcePath;
}



-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    if (productType == FSSourcePromotion)
    {
        [map mapKeyPath:@"promotionid" toAttribute:@"request.productId"];
    } else if (productType == FSSourceProduct)
    {
        [map mapKeyPath:@"productid" toAttribute:@"request.productId"];

    }
    [map mapKeyPath:@"favoriteid" toAttribute:@"request.id"];
    [map mapKeyPath:@"sourcetype" toAttribute:@"request.productType"];
    [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
    [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];
    [map mapKeyPath:@"userid" toAttribute:@"request.userid"];
}
@end
