//
//  FSUser.m
//  FashionShop
//
//  Created by gong yi on 11/16/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSUser.h"
#import "FSLocalPersist.h"
#import "FSCoupon.h"
#import "FSModelManager.h"

#define LOCAL_STORE_USER_KEY @"useraccountprofile"
#define LOCAL_STORE_USER_LOGIN_TOKEN @"userlogintoken"
#define LOCAL_STORE_USER_LOGIN_UID @"userloginid"
#define LOCAL_STORE_DEVICE_TOKEN @"useraccountdevicetoken"

@implementation FSUser

@synthesize uid;
@synthesize uToken;
@synthesize nickie;
@synthesize phone;
@synthesize likeTotal;
@synthesize fansTotal;
@synthesize pointsTotal;
@synthesize userLevelId;
@synthesize userLevelName;
@synthesize thumnail;
@synthesize isLiked;
@synthesize couponsTotal;
@synthesize coupons;
//HeQingshan
@synthesize gender;
@synthesize signature;
@synthesize appID;
@synthesize isBindCard;
@synthesize cardInfo;
@synthesize logobg;
@synthesize thumnailUrl200,thumnailUrl,thumnailUrlOrigin;
@synthesize logobgURL;

+(RKObjectMapping *) getRelationDataMap
{
    return [self getRelationDataMap:false];
}


+(RKObjectMapping *) getRelationDataMap:(BOOL)isCollection
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"nickname",@"nickie",@"level",@"uLevel",@"pointtotal",@"pointsTotal",@"coupontotal",@"couponsTotal",@"token",@"uToken",@"id",@"uid",@"liketotal",@"likeTotal",@"likedtotal",@"fansTotal",@"mobile",@"phone",@"logo",@"thumnail",@"isliked",@"isLiked",@"gender",@"gender",@"desc",@"signature",@"appid",@"appID",@"isbindcard",@"isBindCard",nil];
    RKObjectMapping *resourceRelation = [FSResource getRelationDataMap];
    [relationMap mapKeyPath:@"logobg" toRelationship:@"logobg" withMapping:resourceRelation];
    return relationMap;
}

-(FSUserLevel)userLevelId
{
    if (!_uLevel) {
        return FSNormalUser;
    }
    return [_uLevel intValue];
}

+ (void) removeUserProfile
{
    [[FSLocalPersist sharedPersist] removeObjectInMemory:LOCAL_STORE_USER_KEY];
    [[FSLocalPersist sharedPersist] removeObjectInDisk:LOCAL_STORE_USER_LOGIN_TOKEN];
     [[FSLocalPersist sharedPersist] removeObjectInDisk:LOCAL_STORE_USER_LOGIN_UID];
    [[FSModelManager sharedModelManager] removeWeiboAuthCache];
}


+(FSUser *) localProfile
{
    return [[FSLocalPersist sharedPersist] objectInMemory:LOCAL_STORE_USER_KEY];
}

+(NSString *) localLoginToken
{
    return [[FSLocalPersist sharedPersist] objectInDisk:LOCAL_STORE_USER_LOGIN_TOKEN];
}
+(NSNumber *) localLoginUid
{
    return [[FSLocalPersist sharedPersist] objectInDisk:LOCAL_STORE_USER_LOGIN_UID];
}


+(NSString *) localDeviceToken
{
   return [[FSLocalPersist sharedPersist] objectInDisk:LOCAL_STORE_DEVICE_TOKEN];
}


+(void) saveDeviceToken:(NSString *)device
{
    [[FSLocalPersist sharedPersist] setObjectInDisk:device
                toKey:LOCAL_STORE_DEVICE_TOKEN];
}

- (void) save
{
    [[FSLocalPersist sharedPersist] setObjectInMemory:self toKey:LOCAL_STORE_USER_KEY];
    [[FSLocalPersist sharedPersist] setObjectInDisk:self.uToken toKey:LOCAL_STORE_USER_LOGIN_TOKEN];
    [[FSLocalPersist sharedPersist] setObjectInDisk:self.uid toKey:LOCAL_STORE_USER_LOGIN_UID];
}


-(NSURL *)thumnailUrl
{
    if (!thumnail)
        return nil;
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",thumnail]];
    /*
    if (isRetina) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",thumnail]];
    }
    else
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@_50x50.jpg",thumnail]];
     */
}

-(NSURL *)thumnailUrl200
{
    if (!thumnail)
        return nil;
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@_200x200.jpg",thumnail]];
}

-(NSURL*)thumnailUrlOrigin
{
    if (!thumnail)
        return nil;
    NSString *path = [NSString stringWithFormat:@"%@_original.jpeg",thumnail];
    return [NSURL URLWithString:path];
}

-(NSURL*)logobgURL
{
    if (!logobg)
        return nil;
    NSURL *url = [logobg absoluteUr:320 height:320];
    NSLog(@"url:%@", url.absoluteString);
    return url;
    
//    int width = 320 * RetinaFactor;
//    NSString *str = [NSString stringWithFormat:@"%@_%dx%d.jpg",logobg, width, width];
//    return [NSURL URLWithString:str];
}

-(FSUser*)copyUser:(FSCoreUser*)_aUser
{
    FSUser *user = [[[self class] alloc] init];
    user.uid = [NSNumber numberWithInt:_aUser.uid];
    user.uToken = _aUser.uToken;
    user.nickie = _aUser.nickie;
    user.thumnail = _aUser.thumnail;
    user.userLevelId = _aUser.userLevelId;
    
    return user;
}

@end
