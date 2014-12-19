//
//  FSPLetterRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_MY_PLETTER @"/pmessage/list"
#define RK_REQUEST_MY_PLETTER_CONVERSATION @"/pmessage/conversation"
#define RK_REQUEST_MY_PLETTER_SAY @"/pmessage/say"

@interface FSPLetterRequest : FSEntityRequestBase

@property(nonatomic,strong) NSNumber *nextPage;
@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSString *userToken;
@property(nonatomic,strong) NSNumber *lastconversationid;
@property(nonatomic,strong) NSString *textmsg;
@property(nonatomic,strong) NSNumber *touchUser;
@property(nonatomic,strong) NSNumber *userid;

@end
