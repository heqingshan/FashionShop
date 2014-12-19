//
//  NSDictionary+Extention.m
//  Fara
//
//  Created by Junyu Chen on 12/11/11.
//  Copyright (c) 2011 Fara Inc. All rights reserved.
//

#import "NSDictionary+Extention.h"

@implementation NSDictionary (Extention)

- (NSArray *)arrayForKey:(NSString *)key
{
	id obj = [self objectForKey:key];
	
	if(obj == [NSNull null])
	{
		return [[NSArray alloc]init];
	}
	
	return (NSArray *)[self objectForKey:key];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
	id obj = [self objectForKey:key];
	
	if(obj == [NSNull null])
	{
		return [[NSDictionary alloc]init];
	}
	
	return (NSDictionary *)obj;

}

- (NSString *)stringForKey:(NSString *)key
{
	id obj = [self objectForKey:key];
	
	if(obj == [NSNull null])
	{
		return [[NSString alloc]init];
	}
	
	return (NSString *) obj;

}

- (NSInteger)integerForKey:(NSString *)key
{
	return [[self objectForKey:key] integerValue];
}

- (double)doubleForKey:(NSString *)key
{
	return [[self objectForKey:key] doubleValue];
}

- (NSNumber *)numberForKey:(NSString *)key
{
	NSNumber* obj = (NSNumber *)[self objectForKey:key];
	
	if ([obj isEqualToNumber: [NSNumber numberWithInt:0]])
	{
		return 0;
	}
	
	return obj;	
}

- (BOOL)boolForKey:(NSString *)key
{
	return [[self objectForKey:key] boolValue];
}

@end
