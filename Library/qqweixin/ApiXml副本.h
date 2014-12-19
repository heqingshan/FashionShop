

#import <Foundation/Foundation.h>

@interface XMLHelper : NSObject<NSXMLParserDelegate> {
/*    NSString *_appid;
    NSString *_partnerid;
    NSString *_prepayid;
    NSString *_noncestr;
    UInt32   *_timestamp;
    NSString *_package;
    NSString *_sign;*/
    NSXMLParser *xmlParser;
    NSMutableArray *xmlElements;
    //定义一个可变字符串
    NSMutableDictionary *dictionary;
    NSMutableString *contentString;
}

@property (nonatomic, retain) NSString *appid;
/** 商家向财付通申请的商家id */
@property (nonatomic, retain) NSString *partnerid;
/** 预支付订单 */
@property (nonatomic, retain) NSString *prepayid;
/** 随机串，防重发 */
@property (nonatomic, retain) NSString *noncestr;
/** 时间戳，防重发 */
@property (nonatomic, assign) UInt32 timestamp;
/** 商家根据财付通文档填写的数据和签名 */
@property (nonatomic, retain) NSString *package;
/** 商家根据微信开放平台文档对数据做的签名 */
@property (nonatomic, retain) NSString *sign;

//@property(nonatomic,retain)NSMutableString *contentString;

-(void)startParse:(NSString *)xml;
@end
