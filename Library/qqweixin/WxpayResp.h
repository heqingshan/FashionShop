

#import <Foundation/Foundation.h>
#import "ApiXml.h"
#import "ApiDigest.h"
/*
 服务器返回操作处理
 */
@interface WxpayResp : NSObject{
    NSString *m_key;
    NSMutableString *debug_info;
    //定义一个可变字符串
    NSMutableDictionary *dictionary;
}
-(WxpayResp *) init;
-(NSString *) getDebugifo;
-(void) setKey:(NSString *)key;
-(BOOL) istenpaySign:(NSMutableDictionary*)dict;
@end