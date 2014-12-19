//
//  WxpayOrder.h
//  FashionShop
//
//  Created by HeQingshan on 13-11-13.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "FSOrder.h"

@interface WxpayOrder : NSObject {
    FSOrderWxPayInfo *purchase;
}
@property (nonatomic,strong) UIViewController *fromController;

- (BOOL)sendPay:(NSString*)productid;

@end
