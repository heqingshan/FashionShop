//
//  FSUser.h
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "FSUserLoginRequest.h"
#import "CommonResponseHeader.h"
#import "FSModelBase.h"
#import "FSCardInfo.h"
#import "FSResource.h"
#import "FSCoreUser.h"

@interface FSUser : FSModelBase

@property (nonatomic) NSNumber*  uid;
@property (nonatomic,strong) NSString *uToken;
@property (nonatomic,strong) NSString *nickie;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,assign) int likeTotal;
@property (nonatomic,assign) int fansTotal;
@property (nonatomic,assign) int pointsTotal;
@property (nonatomic,assign) NSNumber*  uLevel;
@property (nonatomic,assign) FSUserLevel  userLevelId;
@property (nonatomic,strong) NSString *userLevelName;
@property (nonatomic,strong) NSString *thumnail;
@property (nonatomic,readonly) NSURL *thumnailUrl;
@property (nonatomic,readonly) NSURL *thumnailUrlOrigin;
@property (nonatomic,readonly) NSURL *thumnailUrl200;
@property (nonatomic,strong) FSResource *logobg;
@property (nonatomic,readonly) NSURL *logobgURL;
@property (nonatomic,assign) BOOL isLiked;
@property (nonatomic,assign) int couponsTotal;
@property (nonatomic,strong) NSMutableArray *coupons;

@property (nonatomic,assign) int gender;//性别
@property (nonatomic,strong) NSString *signature;//签名
@property (nonatomic,strong) NSString *appID;//应用程序ID
@property (nonatomic,assign) NSNumber * isBindCard;//是否绑定了会员卡
@property (nonatomic,strong) FSCardInfo *cardInfo;//会员卡信息

+ (void) removeUserProfile;

+(FSUser *) localProfile;

+(NSString *) localLoginToken;
+(NSNumber *) localLoginUid;

+(NSString *) localDeviceToken;

+(void) saveDeviceToken:(NSString *)device;

-(NSMutableArray *) localCoupons;

- (void) save;

-(FSUser*)copyUser:(FSCoreUser*)_aUser;


@end
