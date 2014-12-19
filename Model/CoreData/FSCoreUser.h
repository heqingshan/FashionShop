//
//  FSCoreUser.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreModelBase.h"
#import "RestKit.h"
#import "FSUserLoginRequest.h"
#import "CommonResponseHeader.h"
#import "FSModelBase.h"
#import "FSCardInfo.h"
#import "FSResource.h"

@interface FSCoreUser : FSCoreModelBase

@property (nonatomic) int  uid;
@property (nonatomic,strong) NSString *uToken;
@property (nonatomic,strong) NSString *nickie;
@property (nonatomic,strong) NSString *thumnail;
@property (nonatomic,strong,readonly) NSURL *thumnailUrl;
@property (nonatomic) FSUserLevel  userLevelId;

+(FSCoreUser*)copyUser:(FSCoreUser*)_aUser;

-(void)show;

@end
