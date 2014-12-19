//
//  FSCouponRequest.m
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCouponRequest.h"

@implementation FSCouponRequest

@synthesize userToken,productId,productType;
@synthesize routeResourcePath = _routeResourcePath;
@synthesize includePass;

-(NSString *) routeResourcePath
{
    if (!_routeResourcePath)
    {
        if (productType == FSSourcePromotion)
            _routeResourcePath = RK_REQUEST_COUPON_CREATE;
        else
            _routeResourcePath = RK_REQUEST_COUPON_PRODCREATE;
    }
    return _routeResourcePath;
}

-(void) setRouteResourcePath:(NSString *)routeResourcePath
{
    _routeResourcePath = routeResourcePath;
}

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    if (productType == FSSourcePromotion)
        [map mapKeyPath:@"promotionid" toAttribute:@"request.productId"];
    else if (productType == FSSourceProduct)
        [map mapKeyPath:@"productid" toAttribute:@"request.productId"];
    [map mapKeyPath:@"ispass" toAttribute:@"request.includePass"];
   
}
@end
