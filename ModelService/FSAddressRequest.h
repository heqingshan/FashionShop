//
//  FSAddressRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define REQUEST_ADDRESS_MY @"/address/my"           //获取用户地址列表
#define REQUEST_ADDRESS_DETAIL @"/address/details"   //获取单个地址信息
#define REQUEST_ADDRESS_CREATE @"/address/create"   //新建地址
#define REQUEST_ADDRESS_EDIT @"/address/edit"       //更新地址
#define REQUEST_ADDRESS_DELETE @"/address/delete"   //地址删除
#define REQUEST_ADDRESS_SUPORT_LIST @"/environment/supportshipments"    //返回所有支持送货区域

@interface FSAddressRequest : FSEntityRequestBase

@property (nonatomic) int id;//地址ID
@property (nonatomic,strong) NSString *shippingcontactperson;
@property (nonatomic,strong) NSString *shippingaddress;
@property (nonatomic,strong) NSString *shippingcontactphone;
@property (nonatomic,strong) NSString *shippingzipcde;
@property (nonatomic,strong) NSString *shippingprovince;
@property (nonatomic) int shippingprovinceid;
@property (nonatomic,strong) NSString *shippingcity;
@property (nonatomic) int shippingcityid;
@property (nonatomic,strong) NSString *shippingdistrict;
@property (nonatomic) int shippingdistrictid;

@property(nonatomic,strong) NSString *userToken;
@property(nonatomic) int nextPage;
@property(nonatomic) int pageSize;

@end
