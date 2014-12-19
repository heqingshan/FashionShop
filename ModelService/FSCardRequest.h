//
//  FSCardRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-3-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_USER_CARD_BIND @"/card/bind"
#define RK_REQUEST_USER_CARD_UNBIND @"/card/unbind"
#define RK_REQUEST_USER_CARD_DETAIL @"/card/detail"

@interface FSCardRequest : FSEntityRequestBase

@property (nonatomic,strong) NSString *cardNo;
@property (nonatomic,strong) NSString *passWord;
@property (nonatomic,strong) NSString *userToken;

@end
