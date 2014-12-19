//
//  WxpayOrder.m
//  FashionShop
//
//  Created by HeQingshan on 13-11-13.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "WxpayOrder.h"
#import "WXApi.h"
#import "NSString+Extention.h"
#import "WxpayConfig.h"
#import "WxpayReq.h"
#import "WxpayResp.h"
#import "FSPurchaseRequest.h"

@implementation WxpayOrder
@synthesize fromController;

- (BOOL)sendPay:(NSString*)productid
{
    if ([NSString isNilOrEmpty:productid]) {
        return NO;
    }
    [WXApi registerApp:WEIXIN_API_APP_KEY];
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有安装微信，现在去安装" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    
    [FSModelManager localLogin:fromController withBlock:^{
        FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_ORDER_WXAPPPAY;
        NSString *changeOrderNumber = [NSString stringWithFormat:@"%@", productid];
        request.orderno = changeOrderNumber;
        [fromController beginLoading:fromController.view];
        request.uToken = [[FSModelManager sharedModelManager] loginToken];
        [request send:[FSOrderWxPayInfo class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
            [fromController endLoading:fromController.view];
            if (respData.isSuccess)
            {
                purchase = respData.responseData;
                NSString *appid = WXAppId;//@"wxd930ea5d5a258f4f";
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                req.openID      = appid;
                [WXApi registerApp:req.openID];
                req.partnerId   = purchase.parterid;
                req.prepayId    = purchase.prepayid;
                req.nonceStr    = purchase.noncestr;
                req.timeStamp   = [purchase.timestamp intValue];
                req.package     = purchase.package;
                req.sign        = purchase.sign;
                [WXApi safeSendReq:req];
            }
            else
            {
                [fromController reportError:respData.errorDescrip];
            }
        }];
    }];
    
    return YES;
}

+ (NSString *)changeOrderNumber:(NSString*)orderNum
{
    return [NSString stringWithFormat:@"1-%@", orderNum];
    
    /*
     微信支付的的productid有三种类型（app使用第一种，后两种H5使用）：
     组成方式为{类型}-{数据}。
     1. 订单号支付，类型为1， productid举例为1-11018200000
     2. sku号支付，类型为2，类型-skuid-storeid-sectionid
     3. product号支付，类型为3， 类型inventoryid-storeid-sectionid
     */
}
/*

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
 */

@end
