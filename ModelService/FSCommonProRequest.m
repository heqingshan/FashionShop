//
//  FSProUploadRequest.m
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCommonProRequest.h"
#import "FSModelManager.h"
#import "CommonHeader.h"
#import "RKJSONParserJSONKit.h"

@interface FSCommonProRequest()
{
    dispatch_block_t completeBlock;
    dispatch_block_t errorBlock;
    BOOL isClientRequest;
}

@end
@implementation FSCommonProRequest
@synthesize uToken;
@synthesize imgs;
@synthesize descrip;
@synthesize tagId;
@synthesize tagName;
@synthesize storeId;
@synthesize brandId;
@synthesize title;
@synthesize brandName;
@synthesize storeName;
@synthesize id;
@synthesize longit,lantit;
@synthesize startdate;
@synthesize enddate;
@synthesize comment;
@synthesize pType;
@synthesize price;
@synthesize originalPrice;
@synthesize pID;
@synthesize fileName;
@synthesize is4sale;
@synthesize property;
@synthesize sizeIndex;
@synthesize upccode;

@synthesize routeResourcePath;

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"lng" toAttribute:@"request.longit"];
    [map mapKeyPath:@"lat" toAttribute:@"request.lantit"];

    [map mapKeyPath:@"token" toAttribute:@"request.uToken"];
    [map mapKeyPath:@"name" toAttribute:@"request.title"];
    [map mapKeyPath:@"description" toAttribute:@"request.descrip"];
    [map mapKeyPath:@"startdate" toAttribute:@"request.startdate"];
    [map mapKeyPath:@"enddate" toAttribute:@"request.enddate"];
    [map mapKeyPath:@"storeid" toAttribute:@"request.brandId"];
    [map mapKeyPath:@"tagid" toAttribute:@"request.tagId"];
    
    if (pType==FSSourceProduct)
    {
       [map mapKeyPath:@"productid" toAttribute:@"request.id"];
    }
    else if(pType ==FSSourcePromotion)
    {
        [map mapKeyPath:@"promotionid" toAttribute:@"request.id"];
    }
}

- (void)clean
{
    imgs = nil;
    descrip = nil;
    tagId = nil;
    tagName = nil;
    storeId = nil;
    brandId = nil;
    title = nil;
    brandName = nil;
    storeName = nil;
    self.id = nil;
    longit = nil;
    lantit = nil;
    startdate = nil;
    enddate = nil;
    comment = nil;
    pType = -1;
    price = nil;
    originalPrice = nil;
    pID = nil;
    fileName = nil;
    is4sale = nil;
    property = nil;
    sizeIndex = nil;
    upccode = nil;
}

-(void) send:(FSEntityRequestBase *)request completeCallBack:(dispatch_block_t)blockcomplete errorCallback:(dispatch_block_t)blockerror
{
    RKObjectManager *innerManager = [FSModelManager sharedManager];
    FSEntityBase * entityObject = [[FSEntityBase alloc] init];
    entityObject.request = request;
   // entityObject.dataClass = responseClass;
    RKObjectMapping *responseMap = [RKObjectMapping mappingForClass:[entityObject class]];
    [entityObject mapRequestReponse:responseMap toManager:innerManager];
    NSString *url = [request appendCommonRequestQueryPara:innerManager];
   // requestCompleteCallback = completeCallback;
    [innerManager sendObject:entityObject toResourcePath:url usingBlock:^(RKObjectLoader *loader) {
        loader.method = RKRequestMethodPOST;
        loader.delegate = self;
        loader.objectMapping = responseMap;
    }];
}


- (void)upload:(dispatch_block_t)blockcomplete error:(dispatch_block_t)blockerror
{
    RKParams *params = [RKParams params];
    [params setValue:uToken forParam:@"token"];
    [params setValue:title forParam:@"name"];
    [params setValue:descrip forParam:@"description"];
    [params setValue:startdate forParam:@"startdate"];
    [params setValue:enddate forParam:@"enddate"];
    [params setValue:storeId forParam:@"storeid"];
    //[params setValue:[is4sale boolValue]?@"true":@"false" forParam:@"is4sale"];
    if (brandId)
        [params setValue:brandId forParam:@"brandid"];
    if (tagId)
        [params setValue:tagId forParam:@"tagid"];
    if (price)
        [params setValue:price forParam:@"price"];
    if (originalPrice) {
        [params setValue:originalPrice forParam:@"unitprice"];
    }
    if (upccode) {
        [params setValue:upccode forParam:@"upccode"];
    }
    /*
    if (property)
        [params setValue:property forParam:@"property"];
     */
    
    for (int i = 0;i < imgs.count; i++) {
        UIImage* img = imgs[i];
        if (sizeIndex && i == [sizeIndex integerValue]) {
            [params setData:UIImageJPEGRepresentation(img, 0.6) MIMEType:@"image/jpeg" forParam:[NSString stringWithFormat:@"resource%d@cc.jpeg",i]];
        }
        else{
            [params setData:UIImageJPEGRepresentation(img, 0.6) MIMEType:@"image/jpeg" forParam:[NSString stringWithFormat:@"resource%d.jpeg",i]];
        }
    }
    if (fileName && ![fileName isEqualToString:@""]) {
        NSLog(@"fileName:%@",fileName);
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:fileName]) {
            NSData *data = [NSData dataWithContentsOfFile:fileName];
            if (data) {
                [params setData:data MIMEType:@"audio/x-m4a" forParam:@"audio.m4a"];
            }
        }
    }
    NSArray *keys = [params attachments];
    for (RKParamsAttachment *item in keys) {
        NSLog(@"%@:%@", item.name, item.value);
    }
    NSString *baseUrl =[self appendCommonRequestQueryPara:[FSModelManager sharedManager]];
    completeBlock = blockcomplete;
    errorBlock = blockerror;
    isClientRequest = true;
    [[RKClient sharedClient] post:baseUrl params:params delegate:self];
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([response isOK] && completeBlock && isClientRequest) {
        RKJSONParserJSONKit* parser = [[RKJSONParserJSONKit alloc] init];
        NSError *error = NULL;
        NSDictionary *result = [parser objectFromString:response.bodyAsString error:&error];
        if (!error && [[result objectForKey:@"statusCode"] intValue]==200) {
            id msg = [[result objectForKey:@"data"] objectForKey:@"id"];
            pID = [NSString stringWithFormat:@"%@", msg];
            completeBlock();
        }
        else
            errorBlock();
    } else if (errorBlock && isClientRequest){
        errorBlock();
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    if (errorBlock)
    errorBlock();
}

@end

