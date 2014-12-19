
#import <Foundation/Foundation.h>
#import "WxpayResp.h"
/*
 服务器返回操作处理
 */
@implementation WxpayResp
-(WxpayResp *) init
{
    debug_info = [NSMutableString string];
    return self;
}
-(void) setKey:(NSString *)key
{
    m_key = key;
}
-(NSString*) getDebugifo
{
    return debug_info;
}
-(BOOL) istenpaySign:(NSMutableDictionary*)dict;
{
    //生成签名获取token
    NSMutableString *contentString=[NSMutableString string];
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if (   [[dict objectForKey:categoryId] isEqualToString:@""] == NO
            && [categoryId isEqualToString:@"sign"] == NO
            && [categoryId isEqualToString:@"key"] == NO
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
            //NSLog(@"key: %@ ,value: %@",categoryId, [params objectForKey:categoryId]);
        }
        
    }
    [contentString appendFormat:@"key=%@", m_key];
    
    ApiDigest *dig = [ApiDigest alloc];
    //得到MD5 sign签名
    NSString *md5Sign =[dig md5:contentString];
    NSString *sign = [dict objectForKey:@"sign"];
    
    [debug_info appendFormat:@"签名字符串：\n%@\n生成的sign＝%@\n获取的sign=%@",contentString, md5Sign,sign];
    
    return [md5Sign isEqualToString:sign];
}

@end