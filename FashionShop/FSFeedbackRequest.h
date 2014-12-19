//
//  FSFeedbackRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "FSEntityRequestBase.h"

#define RK_REQUEST_USER_FEEDBACK   @"feedback/create"

@interface FSFeedbackRequest : FSEntityRequestBase

@property(nonatomic,strong) NSString *userToken;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *phone;

@end
