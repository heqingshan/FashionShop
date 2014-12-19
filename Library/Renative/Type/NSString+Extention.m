//
//  NSString+MD5.m
//  Fara
//
//  Created by Josh Chen on 11-10-12.
//  Copyright (c) 2011 Fara Inc. All rights reserved.
//

#import "NSString+Extention.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h"
#include "GetIPAddress.h"
#import <CommonCrypto/CommonDigest.h>

const NSString* REG_EMAIL = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
const NSString* REG_MOBILE = @"^(13[0-9]|15[0-9]|18[0-9]|14[0-9])\\d{8}$";
const NSString* REG_PHONE = @"^(([0\\+]\\d{2,3}-?)?(0\\d{2,3})-?)?(\\d{7,8})";
const NSString* REG_IDCARD = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$";

@implementation NSString (Extention)

- (NSString*)MD5 
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (BOOL) contains:(NSString *) value
{
	NSRange range = [self rangeOfString: value];
	return ( range.location != NSNotFound );
}

-(NSString *)urlEncode {	
	return [self urlEncodeUsingEncoding:NSUTF8StringEncoding];	
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	
	//DLog(@"SELF: %@", self);
	
	CFStringRef buffer = CFURLCreateStringByAddingPercentEscapes(NULL,
															   (__bridge CFStringRef)self,
															   NULL,
															   (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
															   CFStringConvertNSStringEncodingToEncoding(encoding));
	
	//DLog(@"BUFFER: %@", buffer);
	NSString *output = [NSString stringWithFormat:@"%@", buffer];
	
	CFRelease(buffer);
	
	return output;
}
-(NSString *) trimReturnEmptyChar
{
    return [[self stringByReplacingOccurrencesOfString:@"\n" withString:@""]
            stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (BOOL)isNilOrEmpty:(NSString *)aNSString
{
	//DLog(@"isNilOrEmpty: %@", aNSString);
	
	if (aNSString == nil)
	{
		return YES;
	}
	
	if(aNSString.length == 0)
	{
		return YES;
	}
	
	return NO;
}

+(NSString *)stringMetersFromDouble:(double)input
{
    if (input <= 0)
        return @"";
//    int kilos = 1000;
    double numberOfKilos = input;//input/kilos;
    if (numberOfKilos > 10000) {
        return @"";
    }
    if (numberOfKilos >= 1)
        if (numberOfKilos >= 100) {
            return [NSString stringWithFormat:NSLocalizedString(@"%.0fkiloes", nil), numberOfKilos];
        }
        else{
            return [NSString stringWithFormat:NSLocalizedString(@"%.2fkiloes", nil), numberOfKilos];
        }
    else
        return [NSString stringWithFormat:NSLocalizedString(@"%dmeters", nil),(int)input];
}

+(BOOL)isEmail:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_EMAIL]];
}

+(BOOL)isPhoneNum:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_PHONE]];
}

+(BOOL)isMobileNum:(NSString *)input{
	return [input isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_MOBILE]];
}

+(BOOL)isIDCardNum:(NSString *)idCard
{
    return [idCard isMatchedByRegex:[NSString stringWithFormat:@"%@",REG_IDCARD]];
}

+(NSString*)getDeviceIpaddress
{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    return [NSString stringWithFormat:@"%s", ip_names[1]];
}

+(void)logControl:(UIView*)view
{
    static int level = 1;
    NSMutableString *lines = [NSMutableString string];
    for (int i = 0; i < level; i++) {
        [lines appendString:@"---"];
    }
    NSLog(@"%@%@", lines, view.class);
    for (UIView* _sub in view.subviews) {
        if (_sub.subviews.count == 0) {
            [lines appendString:@"---"];
            NSLog(@"%@%@", lines, _sub.class);
        }
        else{
            level ++;
            [NSString logControl:_sub];
        }
    }
    level --;
}

#define  NUMBER_OF_CHARS 32

+(NSString *)randomString
{
    srand((unsigned)time(NULL));
    char data[NUMBER_OF_CHARS];
    for (int x=0;x<NUMBER_OF_CHARS;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:NUMBER_OF_CHARS encoding:NSUTF8StringEncoding];
}

+ (NSString *)sha1:(NSString *)str {
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
