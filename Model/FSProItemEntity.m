//
//  FSProItemEntity.m
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProItemEntity.h"
#import "FSCoupon.h"
#import "FSComment.h"

@implementation FSProItemEntity

//product detail need attributes
@synthesize id;
@synthesize title;
@synthesize startDate;
@synthesize endDate;
@synthesize couponTotal;
@synthesize favorTotal;
@synthesize descrip;
@synthesize isProductBinded;
@synthesize store;
@synthesize resource;
//@synthesize sharecount;
//@synthesize tag;


//other need attributes
@synthesize targetId;
@synthesize targetType;
@synthesize isFavored;
@synthesize isCouponed;

/*
@synthesize type;
@synthesize proImgs;
@synthesize fromUser;
@synthesize inDate;


@synthesize coupons;
@synthesize comments=_comments;
@synthesize tagId;
@synthesize isPublication;
@synthesize limitCount;
@synthesize height;
@synthesize promotionid;

*/

+(RKObjectMapping *) getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    
    //product detail need attributes
    [relationMap mapKeyPath:@"id" toAttribute:@"id"];
    [relationMap mapKeyPath:@"name" toAttribute:@"title"];
    [relationMap mapKeyPath:@"startdate" toAttribute:@"startDate"];
    [relationMap mapKeyPath:@"enddate" toAttribute:@"endDate"];
    [relationMap mapKeyPath:@"favoritecount" toAttribute:@"favorTotal"];
    [relationMap mapKeyPath:@"couponcount" toAttribute:@"couponTotal"];
    [relationMap mapKeyPath:@"description" toAttribute:@"descrip"];
    [relationMap mapKeyPath:@"isproductbinded" toAttribute:@"isProductBinded"];
    //[relationMap mapKeyPath:@"sharecount" toAttribute:@"sharecount"];
    
    RKObjectMapping *storeRelationMap = [FSStore getRelationDataMap];
    [relationMap mapKeyPath:@"store" toRelationship:@"store" withMapping:storeRelationMap];
    
    RKObjectMapping *resourceRelationMap = [FSResource getRelationDataMap];
    [relationMap mapKeyPath:@"resources" toRelationship:@"resource" withMapping:resourceRelationMap];
    
//    RKObjectMapping *storeRelationMap = [FSTag getRelationDataMap];
//    [relationMap mapKeyPath:@"tag" toRelationship:@"tag" withMapping:storeRelationMap];
    
    //other need attributes
    [relationMap mapKeyPath:@"targetId" toAttribute:@"targetId"];
    [relationMap mapKeyPath:@"targetType" toAttribute:@"targetType"];
    [relationMap mapKeyPath:@"isfavored" toAttribute:@"isFavored"];
    [relationMap mapKeyPath:@"ifcancoupon" toAttribute:@"isCouponed"];
    
    return relationMap;
    
    /*
    [relationMap mapKeyPath:@"tagid" toAttribute:@"tagId"];/////////////////
    [relationMap mapKeyPath:@"ispublication" toAttribute:@"isPublication"];/////////////////
    [relationMap mapKeyPath:@"limitcount" toAttribute:@"limitCount"];/////////////////
    [relationMap mapKeyPath:@"promotionid" toAttribute:@"promotionid"];/////////////////
    
    RKObjectMapping *userRelationMap = [FSUser getRelationDataMap];
    [relationMap mapKeyPath:@"promotionuser" toRelationship:@"fromUser" withMapping:userRelationMap];/////////////////
    
    RKObjectMapping *commentRelationMap = [FSComment getRelationDataMap];
    [relationMap mapKeyPath:@"comment" toRelationship:@"comments" withMapping:commentRelationMap];/////////////////
        return relationMap;
    
    [relationMap mapKeyPathsToAttributes:@"id",@"id",@"name",@"title",@"startdate",@"startDate",@"enddate",@"endDate",@"favoritecount",@"favorTotal",@"couponcount",@"couponTotal",@"description",@"descrip",@"isfavorited",@"isFavored",@"tagid",@"tagId",@"isproductbinded",@"isProductBinded",@"ispublication",@"isPublication",@"limitcount",@"limitCount",@"promotionid",@"promotionid",nil];
     */
}

-(NSMutableArray *)comments
{
    if (!_comments)
        _comments= [@[] mutableCopy];
    return _comments;
}

@end
