//
//  FSCoreUser.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreUser.h"

@implementation FSCoreUser
@synthesize uid;
@synthesize uToken;
@synthesize nickie;
@synthesize thumnail;
@synthesize thumnailUrl;
@synthesize userLevelId;

+(RKObjectMapping *)getRelationDataMap:(Class)type withParentMap:(RKObjectMapping *)parentMap
{
    RKManagedObjectStore *objectStore = [FSModelManager sharedManager].objectStore;
    RKManagedObjectMapping *relationMap = [RKManagedObjectMapping mappingForClass:[self class] inManagedObjectStore:objectStore];
    relationMap.primaryKeyAttribute = @"id";
    [relationMap mapKeyPath:@"nickname" toAttribute:@"nickie"];
    [relationMap mapKeyPath:@"token" toAttribute:@"uToken"];
    [relationMap mapKeyPath:@"id" toAttribute:@"uid"];
    [relationMap mapKeyPath:@"logo" toAttribute:@"thumnail"];
    [relationMap mapKeyPath:@"level" toAttribute:@"userLevelId"];
    
    return relationMap;
}

-(NSURL *)thumnailUrl
{
    if (!thumnail)
        return nil;
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@_100x100.jpg",thumnail]];
}

+(FSCoreUser*)copyUser:(FSCoreUser*)_aUser
{
    FSCoreUser *user = [[[self class] alloc] init];
    user.uid = [NSNumber numberWithInt:_aUser.uid];
    user.nickie = _aUser.nickie;
    user.uToken = _aUser.uToken;
    user.thumnail = _aUser.thumnail;
    return user;
}

-(void)show
{
    NSLog(@"nickname:%@,id:%d,logo:%@_100x100.jpg", self.nickie, self.uid, self.thumnail);
}

@end
