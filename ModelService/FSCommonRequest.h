//
//  FSCommonRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-3-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_KEYWORD_LIST @"/hotword/list"
#define RK_REQUEST_CHECK_VERSION @"/version/latest"
#define RK_REQUEST_ENVIROMENT_MESSAGE @"/environment/messages"
#define RK_REQUEST_SUPPORT_RMAREASONS @"/environment/supportrmareasons"//退货理由分类列表

@interface FSCommonRequest : FSEntityRequestBase

@end
