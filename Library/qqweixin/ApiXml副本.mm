
#import <Foundation/Foundation.h>
#import "ApiXml.h"

@implementation XMLHelper
-(void) startParse:(NSString *)url{
    //NSData *data = [xml dataUsingEncoding:NSUTF8StringEncoding];
    //创建xml解析器
    //NSXMLParser *xmlParse=[[NSXMLParser alloc] initWithData:data];
    //设置委托
    //[xmlParse setDelegate:self];
    //[xmlParse parse];

    dictionary =[NSMutableDictionary dictionary];
    contentString=[NSMutableString string];
    
    //Demo XML解析实例
    xmlElements = [[NSMutableArray alloc] init];
    
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:
                 [NSURL URLWithString:url]];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    
}
//解析文档开始
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //NSLog(@"解析文档开始");
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //NSLog(@"遇到启始标签:%@",elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //NSLog(@"遇到内容:%@",string);
    [contentString setString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"遇到结束标签:%@",elementName);
    NSLog(@"支付参数：%@=%@",elementName, contentString);
    [dictionary setObject: contentString forKey:elementName];
  /*  if ([elementName isEqualToString:@"appid"]) {
        self.appid      = [NSString stringWithFormat:@"%@",contentString];
    }
    if ([elementName isEqualToString:@"partnerid"]) {
        self.partnerid  = [NSString stringWithFormat:@"%@",contentString];
    }
    if ([elementName isEqualToString:@"prepayid"]) {
        self.prepayid   = [NSString stringWithFormat:@"%@",contentString];
    }
    if ([elementName isEqualToString:@"noncestr"]) {
        self.noncestr   = [NSString stringWithFormat:@"%@",contentString];
    }
    if ([elementName isEqualToString:@"timestamp"]) {
        self.timestamp  = contentString.intValue;
    }
    if ([elementName isEqualToString:@"package"]) {
        self.package    = [NSString stringWithFormat:@"%@",contentString];
    }
    if ([elementName isEqualToString:@"sign"]) {
        self.sign       = [NSString stringWithFormat:@"%@",contentString];
    }*/
    //   [contentString setString:@""];
}

//解析文档结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //NSLog(@"文档解析结束");
    [xmlElements release];
    [xmlParser release];
}

@end