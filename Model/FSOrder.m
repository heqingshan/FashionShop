//
//  FSOrder.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrder.h"

@implementation FSOrderInfo
@synthesize orderno,totalamount,totalpoints,extendprice;
@synthesize needinvoice,invoicedetail,invoicesubject;
@synthesize canrma,rmas;
@synthesize shippingaddress,shippingcontactperson,shippingcontactphone,shippingfee,shippingno,shippingvianame,shippingzipcode;
@synthesize status,statust,paymentname,paymentcode,createdate,resource,products,memo;
@synthesize canvoid,totalquantity;

+(RKObjectMapping *)getRelationDataMap
{
    return [self getRelationDataMap:FALSE];
}

+(RKObjectMapping *)getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    
    [relationMapping mapKeyPath:@"orderno" toAttribute:@"orderno"];
    [relationMapping mapKeyPath:@"totalamount" toAttribute:@"totalamount"];
    [relationMapping mapKeyPath:@"totalpoints" toAttribute:@"totalpoints"];
    [relationMapping mapKeyPath:@"extendprice" toAttribute:@"extendprice"];
    
    [relationMapping mapKeyPath:@"needinvoice" toAttribute:@"needinvoice"];
    [relationMapping mapKeyPath:@"invoicetitle" toAttribute:@"invoicesubject"];
    [relationMapping mapKeyPath:@"invoicedetail" toAttribute:@"invoicedetail"];
    
    [relationMapping mapKeyPath:@"canrma" toAttribute:@"canrma"];
    
    [relationMapping mapKeyPath:@"shippingaddress" toAttribute:@"shippingaddress"];
    [relationMapping mapKeyPath:@"shippingno" toAttribute:@"shippingno"];
    [relationMapping mapKeyPath:@"shippingvianame" toAttribute:@"shippingvianame"];
    [relationMapping mapKeyPath:@"shippingfee" toAttribute:@"shippingfee"];
    [relationMapping mapKeyPath:@"shippingzipcode" toAttribute:@"shippingzipcode"];
    [relationMapping mapKeyPath:@"shippingcontactphone" toAttribute:@"shippingcontactphone"];
    [relationMapping mapKeyPath:@"shippingcontactperson" toAttribute:@"shippingcontactperson"];
    
    [relationMapping mapKeyPath:@"status" toAttribute:@"status"];
    [relationMapping mapKeyPath:@"statust" toAttribute:@"statust"];
    [relationMapping mapKeyPath:@"paymentname" toAttribute:@"paymentname"];
    [relationMapping mapKeyPath:@"paymentcode" toAttribute:@"paymentcode"];
    [relationMapping mapKeyPath:@"createdate" toAttribute:@"createdate"];
    [relationMapping mapKeyPath:@"memo" toAttribute:@"memo"];
    
    [relationMapping mapKeyPath:@"canvoid" toAttribute:@"canvoid"];
    [relationMapping mapKeyPath:@"totalquantity" toAttribute:@"totalquantity"];
    
    RKObjectMapping *relationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"resource" toRelationship:@"resource" withMapping:relationMap];
    relationMap = [FSOrderProduct getRelationDataMap];
    [relationMapping mapKeyPath:@"products" toRelationship:@"products" withMapping:relationMap];
    relationMap = [FSOrderRMAItem getRelationDataMap];
    [relationMapping mapKeyPath:@"rmas" toRelationship:@"rmas" withMapping:relationMap];
    
    return relationMapping;
}

@end

@implementation FSOrderRMAItem
@synthesize rejectreason,bankcard,bankaccount,rmatype,bankname,rmano,createdate,status;
@synthesize chargegiftfee,rmaamount,rebatepostfee,chargepostfee,actualamount,reason,mailAddress;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPath:@"rejectreason" toAttribute:@"rejectreason"];
    [relationMapping mapKeyPath:@"reason" toAttribute:@"reason"];
    [relationMapping mapKeyPath:@"bankcard" toAttribute:@"bankcard"];
    [relationMapping mapKeyPath:@"bankaccount" toAttribute:@"bankaccount"];
    [relationMapping mapKeyPath:@"rmatype" toAttribute:@"rmatype"];
    [relationMapping mapKeyPath:@"bankname" toAttribute:@"bankname"];
    [relationMapping mapKeyPath:@"rmano" toAttribute:@"rmano"];
    [relationMapping mapKeyPath:@"createdate" toAttribute:@"createdate"];
    [relationMapping mapKeyPath:@"status" toAttribute:@"status"];
    
    [relationMapping mapKeyPath:@"chargepostfee" toAttribute:@"chargepostfee"];
    [relationMapping mapKeyPath:@"rmaamount" toAttribute:@"rmaamount"];
    [relationMapping mapKeyPath:@"rebatepostfee" toAttribute:@"rebatepostfee"];
    [relationMapping mapKeyPath:@"chargegiftfee" toAttribute:@"chargegiftfee"];
    [relationMapping mapKeyPath:@"actualamount" toAttribute:@"actualamount"];
    [relationMapping mapKeyPath:@"mailaddress" toAttribute:@"mailAddress"];
    
    return relationMapping;
}

@end

@implementation FSOrderProduct
@synthesize itemdesc,itemno,quantity,price,productid,productname,resource,productdesc;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPath:@"itemdesc" toAttribute:@"itemdesc"];
    [relationMapping mapKeyPath:@"itemno" toAttribute:@"itemno"];
    [relationMapping mapKeyPath:@"quantity" toAttribute:@"quantity"];
    [relationMapping mapKeyPath:@"price" toAttribute:@"price"];
    [relationMapping mapKeyPath:@"productid" toAttribute:@"productid"];
    [relationMapping mapKeyPath:@"productname" toAttribute:@"productname"];
    [relationMapping mapKeyPath:@"productdesc" toAttribute:@"productdesc"];
    
    [relationMapping mapKeyPath:@"colorvalue" toAttribute:@"colorvalue"];
    [relationMapping mapKeyPath:@"colorvalueid" toAttribute:@"colorvalueid"];
    [relationMapping mapKeyPath:@"sizevalue" toAttribute:@"sizevalue"];
    [relationMapping mapKeyPath:@"sizevalueid" toAttribute:@"sizevalueid"];
    
    RKObjectMapping *relationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"resource" toRelationship:@"resource" withMapping:relationMap];
    
    return relationMapping;
}

@end

@implementation FSOrderWxPayInfo
@synthesize noncestr,package,parterid,prepayid,timestamp,sign;

+(RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPath:@"noncestr" toAttribute:@"noncestr"];
    [relationMapping mapKeyPath:@"package" toAttribute:@"package"];
    [relationMapping mapKeyPath:@"partnerid" toAttribute:@"parterid"];
    [relationMapping mapKeyPath:@"prepayid" toAttribute:@"prepayid"];
    [relationMapping mapKeyPath:@"timestamp" toAttribute:@"timestamp"];
    [relationMapping mapKeyPath:@"sign" toAttribute:@"sign"];
    
    return relationMapping;
}

@end
