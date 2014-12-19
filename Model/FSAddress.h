//
//  FSAddress.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSAddress : FSModelBase

@property (nonatomic) int id;
@property (nonatomic,strong) NSString *shippingperson;
@property (nonatomic,strong) NSString *shippingaddress;
@property (nonatomic,strong) NSString *shippingphone;
@property (nonatomic,strong) NSString *shippingzipcode;
@property (nonatomic,strong) NSString *shippingprovince;
@property (nonatomic) int shippingprovinceid;
@property (nonatomic,strong) NSString *shippingcity;
@property (nonatomic) int shippingcityid;
@property (nonatomic,strong) NSString *shippingdistrict;
@property (nonatomic) int shippingdistrictid;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *displayaddress;

@end

@interface FSAddressDB : FSModelBase

@property (nonatomic, strong) NSString *province;
@property (nonatomic) int provinceID;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) int cityID;
@property (nonatomic, strong) NSString *district;
@property (nonatomic) int districtID;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic,strong) NSMutableArray *items;

@end
