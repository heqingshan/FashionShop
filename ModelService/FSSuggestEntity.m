//
//  FSSuggestEntity.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSSuggestEntity.h"
#import "RestKit.h"

@implementation FSSuggestEntity
@synthesize products;
@synthesize promotions;


+(void) setMappingListRequestAttribute:(RKObjectMapping *)map{
    //todo:modify request map
    [map mapKeyPath:@"outsitetoken" toAttribute:@"request.accessToken"];
    [map mapKeyPath:@"outsiteuid" toAttribute:@"request.thirdPartyUid"];
    [map mapKeyPath:@"outsitenickname" toAttribute:@"request.nickie"];
    [map mapKeyPath:@"outsitetype" toAttribute:@"request.thirdPartySourceType"];
}

+(void) setMappingAttribute:(RKObjectMapping *)map{
    [CommonResponseHeader setMappingForCommonHeader:map];
    RKObjectMapping *productMap = [RKObjectMapping mappingForClass:[FSSuggestProdItem class]];
    [FSSuggestProdItem setMappingAttribute:productMap];
    RKObjectMapping *promoMap = [RKObjectMapping mappingForClass:[FSSuggestProItem class]];
    [FSSuggestProItem setMappingAttribute:promoMap];
    [map mapKeyPath:@"data.products" toRelationship:@"products" withMapping:productMap];
     [map mapKeyPath:@"data.promotions" toRelationship:@"promotions" withMapping:promoMap];
   
    
}

@end
