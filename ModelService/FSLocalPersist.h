//
//  FSLocalPersist.h
//  FashionShop
//
//  Created by gong yi on 11/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSUser.h"

@interface FSLocalPersist : NSObject



+(FSLocalPersist *) sharedPersist;

- (void) setObjectInMemory:(id)instance toKey:(NSString *)key;

- (void) removeObjectInMemory:(NSString *)key;

- (void) removeObjectInDisk:(NSString *)key;

- (void) setObjectInDisk:(id)instance toKey:(NSString *)key;

- (id) objectInMemory:(NSString *)key;

-(id) objectInDisk:(NSString *)key;

@end

