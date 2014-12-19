

#import <Foundation/Foundation.h>
#import "ApiXml.h"
#import "ApiDigest.h"
/*
 服务器请求操作处理
 */
@interface WxpayReq : NSObject{
    NSString *m_key;
    NSString *m_getway;
    NSMutableString *debug_info;
    //定义一个可变字符串
    NSMutableDictionary *dictionary;
}
-(WxpayReq *) init;
-(NSString *) getDebugifo;
-(void) setKey:(NSString *)key;
-(NSString *) genMd5Sign:(NSMutableDictionary*)dict;
-(NSString *) genUrlstr:(NSMutableDictionary*)dict;
-(NSString *) genSHAsign:(NSMutableDictionary *)dictResp;
@end
