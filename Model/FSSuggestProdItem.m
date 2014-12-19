//
//  FSSuggestProdItem.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSSuggestProdItem.h"
#import "RestKit.h"

@implementation FSSuggestProdItem
@synthesize id;
@synthesize imageUrls,brand,brandId,fromLevel,fromStore,fromUserid,comments,inDate,suggestSource,suggestType,tagId,tagName,couponTotal,likeTotal,descrip,price,promotion;

+(void) setMappingAttribute:(RKObjectMapping *)map{
    
    //todo: setmap for prod
}
@end
