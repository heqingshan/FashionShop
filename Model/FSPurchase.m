//
//  FSPurchase.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPurchase.h"

@implementation FSPurchase
@synthesize id;
@synthesize name;
@synthesize description;
@synthesize price;
@synthesize originprice;
@synthesize rmapolicy;
@synthesize saleColors;
@synthesize supportpayments;
@synthesize sizeImage;
@synthesize selectColorIndex;
@synthesize selectSizeIndex;
@synthesize selectCountIndex;

//amount info
@synthesize totalamount,totalfee,totalpoints,totalquantity,extendprice;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [relationMapping mapKeyPath:@"description" toAttribute:@"description"];
    [relationMapping mapKeyPath:@"price" toAttribute:@"price"];
    [relationMapping mapKeyPath:@"originprice" toAttribute:@"originprice"];
    [relationMapping mapKeyPath:@"rmapolicy" toAttribute:@"rmapolicy"];
    [relationMapping mapKeyPath:@"brandid" toAttribute:@"brandId"];
    [relationMapping mapKeyPath:@"brandname" toAttribute:@"brandName"];
    
    RKObjectMapping *relationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"dimension" toRelationship:@"sizeImage" withMapping:relationMap];
    
    relationMap = [FSPurchaseSaleColorsItem getRelationDataMap];
    [relationMapping mapKeyPath:@"salecolors" toRelationship:@"saleColors" withMapping:relationMap];
    
    relationMap = [FSPurchaseSPaymentItem getRelationDataMap];
    [relationMapping mapKeyPath:@"supportpayments" toRelationship:@"supportpayments" withMapping:relationMap];
    
    
    //请求计算金额返回数据
    [relationMapping mapKeyPath:@"totalamount" toAttribute:@"totalamount"];
    [relationMapping mapKeyPath:@"totalfee" toAttribute:@"totalfee"];
    [relationMapping mapKeyPath:@"totalpoints" toAttribute:@"totalpoints"];
    [relationMapping mapKeyPath:@"totalquantity" toAttribute:@"totalquantity"];
    [relationMapping mapKeyPath:@"extendprice" toAttribute:@"extendprice"];
    
    return relationMapping;
}

@end

@implementation FSPurchaseSaleColorsItem
@synthesize colorId;
@synthesize colorName;
@synthesize sizes;
@synthesize resource;
@synthesize isChecked;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"colorid" toAttribute:@"colorId"];
    [relationMapping mapKeyPath:@"colorname" toAttribute:@"colorName"];
    RKObjectMapping *relationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"resource" toRelationship:@"resource" withMapping:relationMap];
    relationMap = [FSPurchaseSaleSizeItem getRelationDataMap];
    [relationMapping mapKeyPath:@"sizes" toRelationship:@"sizes" withMapping:relationMap];
    
    return relationMapping;
}

@end

@implementation FSPurchaseSaleSizeItem
@synthesize sizeId;
@synthesize sizeName;
@synthesize is4sale;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"sizeid" toAttribute:@"sizeId"];
    [relationMapping mapKeyPath:@"sizename" toAttribute:@"sizeName"];
    [relationMapping mapKeyPath:@"is4sale" toAttribute:@"is4sale"];
    
    return relationMapping;
}

@end

@implementation FSPurchaseSPaymentItem
@synthesize code,name,supportmobile,supportpc;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPath:@"code" toAttribute:@"code"];
    [relationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [relationMapping mapKeyPath:@"supportmobile" toAttribute:@"supportmobile"];
    [relationMapping mapKeyPath:@"supportpc" toAttribute:@"supportpc"];
    
    return relationMapping;
}

@end


@implementation FSPurchaseForUpload
@synthesize products,needinvoice,invoicetitle,invoicedetail,memo,payment,address,telephone;

-(id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

-(void)reset
{
    needinvoice = NO;
    [products removeAllObjects];
    products = nil;
    invoicetitle = nil;
    invoicedetail = nil;
    memo = nil;
    telephone = nil;
    payment = nil;
    address = nil;
}

@end

@implementation FSKeyValueItem

@synthesize key,value;

@end

@implementation FSPurchaseProductItem
@synthesize productid,desc,quantity,properties;

-(id)init
{
    self = [super init];
    if (self) {
        [self reset];
    }
    return self;
}

-(void)reset
{
    productid = -1;
    quantity = -1;
    properties = nil;
    desc = nil;
}

@end