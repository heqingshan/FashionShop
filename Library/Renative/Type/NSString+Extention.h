//
//  NSString+MD5.h
//  Fara
//
//  Created by Josh Chen on 11-10-12.
//  Copyright (c) 2011 Fara Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extention)

- (NSString *)MD5;
- (NSString *)urlEncode;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
- (BOOL) contains:(NSString *)value;
-(NSString *) trimReturnEmptyChar;
+ (BOOL)isNilOrEmpty:(NSString *)aNSString;

+(NSString *)stringMetersFromDouble:(double)input;

/**
 判断字符串是否符合Email格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+(BOOL)isEmail:(NSString *)input;

/**
 判断字符串是否符合手机号格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+(BOOL)isPhoneNum:(NSString *)input;

/**
 判断字符串是否符合电话格式。
 @param input 字符串
 @returns 布尔值 YES: 符合 NO: 不符合
 */
+(BOOL)isMobileNum:(NSString *)input;

+(BOOL)isIDCardNum:(NSString *)idCard;

+(NSString*)getDeviceIpaddress;

+(void)logControl:(UIView*)view;

+(NSString *)randomString;

+(NSString *)sha1:(NSString *)str;

@end
