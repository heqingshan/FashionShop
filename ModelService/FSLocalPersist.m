//
//  FSLocalPersist.m
//  FashionShop
//
//  Created by gong yi on 11/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSLocalPersist.h"
#import "NSString+Extention.h"

#define LOCAL_STORE_USER_KEY @"useraccountprofile"
#define LOCAL_STORE_USER_NICKIE_KEY @"useraccountprofile_nickie"
#define LOCAL_STORE_USER_LOGIN_TOKEN @"userlogintoken"
#define LOCAL_STORE_COUPON_KEY @"local stored coupon"

static FSLocalPersist *_singleonPersist;

@implementation FSLocalPersist{
    NSMutableDictionary *_cacheInMemory;
    
}


-(id) initWithMemory
{
    FSLocalPersist *instance = [self init];
    _cacheInMemory = [@{} mutableCopy];
    return instance;
}

+(FSLocalPersist *) sharedPersist
{
    if (!_singleonPersist)
    {
        _singleonPersist = [[FSLocalPersist alloc] initWithMemory];
        
    }
    return _singleonPersist;
}

- (void) removeObjectInMemory:(NSString *)key
{
    [_cacheInMemory removeObjectForKey:key];
}
- (void) setObjectInMemory:(id)instance toKey:(NSString *)key
{
    [_cacheInMemory setObject:instance forKey:key];
}

- (void) removeObjectInDisk:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

- (void) setObjectInDisk:(id)instance toKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:instance forKey:key];
}

- (id) objectInMemory:(NSString *)key
{
    return [_cacheInMemory objectForKey:key];
}

- (id) objectInDisk:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (id) persistStorage{
    return [NSUserDefaults standardUserDefaults] ;
}



+ (void) updateObjectFromKey:(NSString *)key withProperty:(NSString *)property withValue:(id)value
{
    id persistObject = [[self persistStorage] objectForKey:key];
    if (persistObject == nil)
    {
        DLog(@"user default storage is emtpy for key:%@",key);
        return;
    }
    [persistObject setObject:value forKey:property];
    return;
}


@end
