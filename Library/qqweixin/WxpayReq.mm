
#import <Foundation/Foundation.h>
#import "WxpayReq.h"
/*
 服务器请求操作处理
 */
@implementation WxpayReq
-(WxpayReq *) init
{
    debug_info = [NSMutableString string];
    m_getway = @"https://wpay.tenpay.com/wx_pub/v1.0/wx_app_api.cgi";
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
-(NSString*) genMd5Sign:(NSMutableDictionary*)dict
{
    //生成签名获取token
    NSMutableString *contentString=[NSMutableString string];
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
            //NSLog(@"key: %@ ,value: %@",categoryId, [params objectForKey:categoryId]);
        }
        
    }
    [contentString appendFormat:@"key=%@", m_key];
    [debug_info appendFormat:@"MD5签名字符串：\n%@\n",contentString];
    ApiDigest *dig = [ApiDigest alloc];
    //得到MD5 sign签名
    NSString *md5Sign =[dig md5:contentString];
    return md5Sign;
}
-(NSString*) genUrlstr:(NSMutableDictionary*)dict
{//请求TOKEN请求串
    NSMutableString *queryString=[NSMutableString string];

    /*   NSArray *keys = [params allKeys];
     NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
 
     return [obj1 compare:obj2 options:NSNumericSearch];
     }];*/
    //生成提交querystring
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        [queryString appendFormat:@"%@=%@&", categoryId, [[dict objectForKey:categoryId]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    }
    //[queryString appendFormat:@"sign=%@", md5Sign];
    
    NSString *urlString =[NSString stringWithFormat:@"%@?%@",m_getway,queryString];
    
    return urlString;
}
-(NSString *)genSHAsign:(NSMutableDictionary *)dictResp
{
    NSMutableString *signString=[NSMutableString string];
    
    /*   NSArray *keys = [params allKeys];
     NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
     
     return [obj1 compare:obj2 options:NSNumericSearch];
     }];*/
    //生成提交querystring
    NSArray *keys = [dictResp allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        if ( [signString length] > 0) {
            [signString appendString:@"&"];
        }
        [signString appendFormat:@"%@=%@", categoryId, [[dictResp objectForKey:categoryId]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
    }

    [debug_info appendFormat:@"SHA1签名字符串：\n%@\n",signString];
    ApiDigest *dig = [ApiDigest alloc];
    //得到sha1 sign签名
    NSString *sign =[dig sha1:signString];

    return sign;
}


@end