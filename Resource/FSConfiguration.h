//
//  FSConfiguration.h
//  FashionShop
//
//  Created by gong yi on 11/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#include "FSConfiguration+Fonts.h"
#import "FSAppDelegate.h"
#include "GetIPAddress.h"

#ifndef FashionShop_FSConfiguration_h
#define FashionShop_FSConfiguration_h

/*
 1、切换成正式库接口地址
 2、检查版本号
 3、检查是否打开了支付宝支付功能
 4、检查是否Flurry是正式库
 5、检查是否使用了正确的证书
 */

#define REST_API_CLIENT_VERSION @"2.5.2"

//正式库
#define REST_API_URL   @"http://iapi.intime.com.cn/api"
#define REST_API_URL_OUT @"http://i.intime.com.cn"
#define REST_API_APP_SECRET_KEY @"yintai123456"

//#define REST_API_URL   @"http://itoo.yintai.com/api"
//#define REST_API_URL_OUT @"http://api.youhuiin.com"
//#define REST_API_APP_SECRET_KEY @"yintai123456"

//预生产库-内网
//    #define REST_API_URL   @"http://10.92.200.109/api"
//    #define REST_API_URL_OUT @"http://stage.youhuiin.com"
//    #define REST_API_APP_SECRET_KEY @"yintai123456"

////预生产库
//    #define REST_API_URL   @"http://apis.youhuiin.com/api"
//    #define REST_API_URL_OUT @"http://stage.youhuiin.com"
//    #define REST_API_APP_SECRET_KEY @"yintai123456"

//新浪微博
#define SINA_WEIBO_APP_KEY @"2978041275"
#define SINA_WEIBO_APP_SECRET_KEY @"ea68b2a26ca930c6b51d434decdd2c9b"
#define SINA_WEIBO_APP_REDIRECT_URI @"http://www.intime.com.cn"

//腾讯微博
#define QQ_WEIBO_APP_KEY @"801302732"
#define QQ_WEIBO_APP_SECRET_KEY @"cd497771f88f6971ad11855088d050fd"
#define QQ_WEIBO_APP_REDIRECT_URI @"http://www.intime.com.cn"

//微信
#define WEIXIN_API_APP_KEY @"wx413d6a12d10df434"

//QQ联合登陆
#define QQ_CONNECT_APP_ID @"100382932"
#define QQ_CONNECT_APP_KEY @"8acc22a900a6cf3a144c4e7364dafa78"

//Flurry hangzhou
//正式环境
#define FLURRY_APP_KEY @"BVP8QWHDDXKCBPZRPFT4"
//测试环境
//#define FLURRY_APP_KEY @"XSKSXR35ZFQ8CBVC9YD7"

#define BAIDU_MAP_KEY @"D768745A12D429DEC85D896036A25C50A52313E6"

//notification
#define LN_USER_UPDATED @"LN_USER_UPDATED"
#define LN_FAVOR_UPDATED @"LN_USER_FAVOR_UPDATED"
#define LN_ITEM_UPDATED @"LN_USER_ITEM_UPDATED"
#define COMMON_PAGE_SIZE 20

//Enviroment Message
#define EM_O_C_SUCC @"O_C_SUCC"
#define EM_O_R_SUCC @"O_R_SUCC"
#define EM_O_C_HELP @"O_C_HELP"

//支付方式代码
#define DELIVERY_PAY_CODE @"1001" //货到付款
#define ALI_PAY_CODE @"25"    //支付宝支付
#define CAIFUTONG_PAY_CODE @"26" //财付通支付
#define WEIXIN_PAY_CODE @"28" //微信支付

#define CollectionView_Default_Height 100.0f

//判断系统是否是iOS7
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define MinIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0 ? YES : NO)

#define NAV_HIGH        44
#define TAB_HIGH        49
#define IPHONE5_AddHEIGHT 88
#define APP_HIGH        [[UIScreen mainScreen] applicationFrame].size.height
#define APP_WIDTH       [[UIScreen mainScreen] applicationFrame].size.width
#define SCREEN_HIGH     [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define MAIN_HIGH       APP_HIGH - NAV_HIGH
#define BODY_HIGH       APP_HIGH - NAV_HIGH - TAB_HIGH
#define theApp          ((FSAppDelegate *) [[UIApplication sharedApplication] delegate])
#define STATUSBAR_HIGH  ([UIApplication sharedApplication].statusBarHidden?0:20)
//当前设备是否支持高清
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.width == 640 || [[UIScreen mainScreen] currentMode].size.width == 1536) : NO)
//是否高清，放大系数
#define RetinaFactor (isRetina?2:1)
// 是否iPad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Audios"]

#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLOR(r,g,b)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define XRGBCOLOR(r,g,b)         [UIColor colorWithRed:(0x##r)/255.0 green:(0x##g)/255.0 blue:(0x##b)/255.0 alpha:1]

#define FONT(a)             [UIFont systemFontOfSize:a]
#define BFONT(a)            [UIFont boldSystemFontOfSize:a]

#define ATTENTION_XHYT_URL @"http://weixin.qq.com/r/FHWNghXEhiv5hwThnyAw"

#define PickerView_Background_Color RGBACOLOR(255,255,255,1.0)
#define PickerView_Alpha 0.9

#endif


typedef enum {
    SortByUnUsed = 0,//未使用
    SortByUsed,//已使用
    SortByDisable//无效
}FSGiftSortBy;

typedef enum {
    OrderSortByCarryOn,
    OrderSortByCompletion,
    OrderSortByDisable,
}FSOrderSortBy;

typedef enum {
    SortByNone = -1,
    SortByDistance = 0,
    SortByDate = 1,
    SortByPre = 2
}FSProSortBy;

typedef enum {
    SkipTypeDefault = 0,
    SkipTypeProductList,
    SkipTypePromotionDetail,
    SkipTypeProductDetail,
    SkipTypeNone,
    SkipTypeURL,
    SkipTypePointEx,
    /*
     SkipTypeDefault = 0;默认跳转商品列表，兼容老版本数据
     a、SkipTypeProductList=1：专题商品列表
     b、SkipTypePromotionDetail=2：活动详情
     c、SkipTypeProductDetail=3：商品详情
     d、SkipTypeNone=4：不跳转，即不能点击，主要做展示使用。
     e、SkipTypeURL=5：根据给定的URL，连接到特定的Web页面。
     f、SkipTypePointEx=6：积点兑换
     */
}FSSkipType;

typedef enum {
    FSAddressDetailStateShow,
    FSAddressDetailStateEdit,
    FSAddressDetailStateNew,
}FSAddressDetailState;

