//
//  NSDictionary+Extention.h
//  Fara
//
//  Created by Junyu Chen on 12/11/11.
//  Copyright (c) 2011 Fara Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extention)

- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;

@end
