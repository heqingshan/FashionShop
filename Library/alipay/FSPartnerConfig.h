//
//  PartnerConfig.h
//  FashionShop
//
//  Created by Heqingshan on 13-5-3.
//  Copyright (c) 2013年 All rights reserved.
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作商户ID。用签约支付宝账号登录ms.alipay.com后，在账户信息页面获取。
#define PartnerID @"2088011888580823"
//账户ID。用签约支付宝账号登录www.alipay.com后，在商家服务页面中获取。
#define SellerID  @"2088011888580823"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAIAmCjfyfDtazbQNq8sAW4DravuA3s+/g76smHbdUjWWb/v8xBGFoxy1BKPUykByMI3FKEZ4go3Afw8ogmkl4G9DbTiCxJKswNxgoH1/MuWvocmt4zfTVNofRb6Ydw4ezfMrSpX3wsxMWR08yH1GGoJxl0kdClerPwBBRhuTtGh9AgMBAAECgYAy+W61JIKgRZVvmsSMQn8jgAGVO4Tl1IN+VD9tgMoTwNyYusnvQl5IrATFen5dNk70BcnohkVAR6MDD5UYaFWmuiFKTt8X02Ree6XGNrOfywqEogk8hGzE2VWH3OF//Jzb3/pOgDPr9LyJrAzqh6Bl2xETnqvrrLl7wgc/VgKUDQJBANiAPaBWwDa4wQ48mQYOjpFB65zNGzF4Yb9B4VLXK7fFVFodgc64m8OsUOflB/DiiSdT28bA18WyPb/7jmsSewsCQQCXh0TeEyLzm+4ICi1ujDPbpNZQMQr9J+LGVjQyBSQCaKBrXA2qCs6DWP/Sh+Pczi1cigvlDl6SHeVhiHGhZp+XAkBx3+oKNvb9EWqB+X+nfuqgHqM2I2/lMmN/fMBumTymeYVnrNOFDvbnEfCwOHhXzF/FrscPoIkdtCXkoAUF7n+HAkEAhhfCrfOpXoOC5cJ76fRQf/MjZNvBqb3+RR5MGmfKMgd8zwUrYmslzb6YxSpUTzZ1lgrj89P/hLbIIsOoKviyCQJASZCBqysAbMh2xzSwKRm5XrFLyZTt7uh7tDkRBjzid0GjDZ14FMR8L6ieIvrbDQGUNmNabK3hrwCA/KEa09rWkA=="

//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#define AlipayProductCode @"xhytalipay"

#define AlipayNotifyURL [NSString stringWithFormat:@"%@/payment/notify2",REST_API_URL];

//安全校验码（MD5）密钥  用签约支付宝账号登录www.alipay.com后，在商家服务页面中获取。
#define MD5_KEY @"n4q74v8r3bnhzsbthx0yf3g1ama9mntm"

//商户公钥，不用
#define PartnerPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCAJgo38nw7Ws20DavLAFuA62r7gN7Pv4O+rJh23VI1lm/7/MQRhaMctQSj1MpAcjCNxShGeIKNwH8PKIJpJeBvQ204gsSSrMDcYKB9fzLlr6HJreM301TaH0W+mHcOHs3zK0qV98LMTFkdPMh9RhqCcZdJHQpXqz8AQUYbk7RofQIDAQAB"

#endif
