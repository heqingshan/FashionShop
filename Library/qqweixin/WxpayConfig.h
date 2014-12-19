//
//  FSWXConfig.h
//  FashionShop
//
//  Created by Heqingshan on 13-5-3.
//  Copyright (c) 2013年 All rights reserved.
//

#ifndef MQPDemo_FSWXConfig_h
#define MQPDemo_FSWXConfig_h

//公众号身份标识
#define WXAppId @"wx413d6a12d10df434"//wxec92040268f6acec/

//公众号支付请求中用于加密的密钥 Key,可验证商户唯一身份,PaySignKey 对应于支付场景中的 appKey 值。
#define WXPaySignKey @"EmamuLc5zRJ8eCnQRhelhFnaQIgYPSiZKvRMO7mVtBzIJsB9MT165VNsa8Wvvf1NNp6C2X5wBGhSGWwtl57XyXXeAphDIPWwf5cOxjnGvIzJFDKyLU4Pn2ztroEHJ7hw"

//财付通商户身份标识。
#define WXPartnerId @"1217446001"

//微信OpenId
//#define WxOpenId @"wx413d6a12d10df434"

//财付通商户权限密钥 Key。
#define WXPartnerKey @"ea4d56fec98cb57d948cd697c683b2a2"

//公众平台 API(参考文档 API 接口部分)的权限获取所需密钥 Key,在使用所 有公众平台 API 时,都需要先用它去换取 access_token,然后再进行调用。
#define WXAppSecret @"d3bd5d1068c0df6bcde1c757702e1647"

//微信跳转标记
#define WXpayProductCode @"xhytwxpay"


#endif
