

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
/*
 加密实现MD5和SHA1
 */
@interface ApiDigest :NSObject
-(NSString *) md5HexDigest:(NSString *)str;
-(NSString *) md5:(NSString *)str;
- (NSString*) sha1:(NSString *)str;
@end