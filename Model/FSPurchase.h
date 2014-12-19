//
//  FSPurchase.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSResource.h"
#import "FSAddress.h"

#define Purchase_Count_Properties_Tag -123

@interface FSPurchase : FSModelBase

@property (nonatomic) int id;//商品主键
@property (nonatomic,strong) NSString *name;//商品名称
@property (nonatomic,strong) NSString *description;//商品描述
@property (nonatomic) float price;//销售价
@property (nonatomic) float originprice;//吊牌价
@property (nonatomic,strong) NSString *rmapolicy;//退货政策
@property (nonatomic,strong) NSMutableArray *saleColors;//商品所有颜色，数组 //FSPurchaseSaleColorsItem
@property (nonatomic,strong) NSMutableArray *supportpayments;//支持的支付方式数组
@property (nonatomic,strong) NSMutableArray *invoicedetails;//支持的发票明细数组
@property (nonatomic,strong) FSResource *sizeImage;//尺码对照表图片，参照图片信息格式
@property (nonatomic) int brandId;//商品品牌主键
@property (nonatomic,strong) NSString *brandName;//商品品牌名称

@property (nonatomic) int selectColorIndex;//选中的颜色索引，默认为第0项
@property (nonatomic) int selectSizeIndex;//选中的规格索引，默认为-1，如果只有一个则为第0项
@property (nonatomic) int selectCountIndex;//选中的数量索引，默认为1，总的范围1~5

//amount info
@property (nonatomic) float totalfee;
@property (nonatomic) int totalpoints;
@property (nonatomic) float extendprice;
@property (nonatomic) int totalquantity;
@property (nonatomic) float totalamount;

//other no map
@property (nonatomic,strong) NSString *addressDetailDesc;
@property (nonatomic,strong) NSString *paywayDesc;
@property (nonatomic,strong) NSString *voiceDesc;
@property (nonatomic,strong) NSString *orderNoteDesc;
@property (nonatomic,strong) NSString *phoneDesc;

@end

@interface FSPurchaseSaleColorsItem : FSModelBase

@property (nonatomic) int colorId; //颜色主键
@property (nonatomic,strong) NSString *colorName; //颜色描述
@property (nonatomic,strong) NSMutableArray *sizes;//FSPurchaseSaleSizeItem
@property (nonatomic,strong) FSResource *resource;
@property (nonatomic) BOOL isChecked;//是否选中

@end

//尺寸单元
@interface FSPurchaseSaleSizeItem : FSModelBase

@property (nonatomic) int sizeId; //尺码主键
@property (nonatomic,strong) NSString *sizeName; //尺码描述
@property (nonatomic) BOOL is4sale;//是否可销售

@end

@interface FSPurchaseSPaymentItem : FSModelBase

@property (nonatomic, strong) NSString *code;//支付方式编码
@property (nonatomic, strong) NSString *name;//支付方式名
@property (nonatomic) BOOL supportmobile;//是否支持mobile
@property (nonatomic) BOOL supportpc;//是否支持pc

@end


@interface FSPurchaseForUpload : NSObject

@property (nonatomic, strong) NSMutableArray *products;     //products  FSPurchaseProductItem
@property (nonatomic) BOOL needinvoice;                     //是否需要发票
@property (nonatomic) BOOL isCompany;                       //是否是公司
@property (nonatomic, strong) NSString *invoicetitle;       //发票抬头
@property (nonatomic, strong) NSString *invoicedetail;      //发票明细
@property (nonatomic, strong) NSString *memo;               //订单备注
@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) FSPurchaseSPaymentItem *payment;
@property (nonatomic, strong) FSAddress *address;

-(void)reset;

@end

@interface FSKeyValueItem : NSObject

@property (nonatomic,strong) NSString *value;
@property (nonatomic) int key;

@end

@interface FSPurchaseProductItem : NSObject

@property (nonatomic) int productid;                            //商品id
@property (nonatomic, strong) NSString *desc;                   //商品描述
@property (nonatomic) int quantity;                             //数量
@property (nonatomic, strong) NSMutableDictionary *properties;  //properties
/*
 sizevalueid：尺码主键
 sizevaluename：尺码描述
 colorvalueid：颜色主键
 colorvaluename：颜色描述
 */

@end
