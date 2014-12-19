

#import <Foundation/Foundation.h>
/*
 XML 解析库
 */
@interface XMLHelper : NSObject<NSXMLParserDelegate> {

    NSXMLParser *xmlParser;
    NSMutableArray *xmlElements;
    //定义一个可变字符串
    NSMutableDictionary *dictionary;
    NSMutableString *contentString;
}

-(void)startParse:(NSString *)url;
-(NSMutableDictionary*) getDict;
@end
