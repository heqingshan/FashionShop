
//
//  FSCommonCommentRequest.m
//  FashionShop
//
//  Created by gong yi on 12/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCommonCommentRequest.h"
#import "FSModelManager.h"
#import "CommonHeader.h"
#import "RKJSONParserJSONKit.h"

@interface FSCommonCommentRequest()
{
    FSCommentCompleteBlock completeBlock;
    FSCommentCompleteBlock errorBlock;
    BOOL isClientRequest;
}

@end

@implementation FSCommonCommentRequest

@synthesize id;
@synthesize sourceid;
@synthesize sourceType;
@synthesize comment;
@synthesize userId;
@synthesize refreshTime;
@synthesize pageSize;
@synthesize nextPage;
@synthesize sort;
@synthesize userToken;
@synthesize routeResourcePath;
@synthesize replyuserID;
@synthesize audioName;

-(void) setMappingRequestAttribute:(RKObjectMapping *)map
{
    [map mapKeyPath:@"id" toAttribute:@"request.id"];
    [map mapKeyPath:@"sourceid" toAttribute:@"request.sourceid"];
    [map mapKeyPath:@"sourcetype" toAttribute:@"request.sourceType"];
    [map mapKeyPath:@"page" toAttribute:@"request.nextPage"];
    [map mapKeyPath:@"pagesize" toAttribute:@"request.pageSize"];
    [map mapKeyPath:@"sort" toAttribute:@"request.sort"];
    [map mapKeyPath:@"refreshts" toAttribute:@"request.refreshTime"];
    [map mapKeyPath:@"token" toAttribute:@"request.userToken"];
    [map mapKeyPath:@"content" toAttribute:@"request.comment"];
    [map mapKeyPath:@"replyuser" toAttribute:@"request.replyuserID"];
}

- (void)upload:(FSCommentCompleteBlock)blockcomplete error:(FSCommentCompleteBlock)blockerror
{
    RKParams *params = [RKParams params];
    [params setValue:sourceid forParam:@"sourceid"];
    [params setValue:sourceType forParam:@"sourcetype"];
    [params setValue:nextPage forParam:@"page"];
    [params setValue:pageSize forParam:@"pagesize"];
    [params setValue:sort forParam:@"sort"];
    [params setValue:refreshTime forParam:@"refreshts"];
    
    [params setValue:userToken forParam:@"token"];
    [params setValue:replyuserID forParam:@"replyuser"];
    
    NSString *errorMsg = nil;
    BOOL flag = YES;
    if (_isAudio) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:audioName]) {
            NSData *data = [NSData dataWithContentsOfFile:audioName];
            if (data) {
                [params setData:data MIMEType:@"audio/x-m4a" forParam:@"audio.m4a"];
            }
        }
        else{
            flag = NO;
            errorMsg = @"语音文件生成发生错误，请重新录入";
        }
    }
    else if(comment) {
        [params setValue:comment forParam:@"content"];
    }
    else{
        flag = NO;
        errorMsg = @"语音和文字描述都不存在，无法进行评论！";
    }
    
    NSArray *keys = [params attachments];
    for (RKParamsAttachment *item in keys) {
        NSLog(@"%@:%@", item.name, item.value);
    }
    
    if (flag) {
        NSString *baseUrl =[self appendCommonRequestQueryPara:[FSModelManager sharedManager]];
        completeBlock = blockcomplete;
        errorBlock = blockerror;
        isClientRequest = true;
        [[RKClient sharedClient] post:baseUrl params:params delegate:self];
    }
    else{
        errorBlock = blockerror;
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            errorBlock(errorMsg);
        });
    }
}

-(void)show:(NSString*)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"wen" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
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
            completeBlock([result objectForKey:@"data"]);
        }
        else
            errorBlock([result objectForKey:@"message"]);
    } else if (errorBlock && isClientRequest){
        errorBlock(nil);
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    if (errorBlock)
        errorBlock(error.description);
}

@end
