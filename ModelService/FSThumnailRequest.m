 //
//  FSThumnailRequest.m
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSThumnailRequest.h"
#import "FSModelManager.h"
#import "RKJSONParserJSONKit.h"

@implementation FSThumnailRequest
@synthesize image;
@synthesize uToken;
@synthesize routeResourcePath;
@synthesize type;

- (void)upload:(FSThumnailCompleteBlock)blockcomplete error:(FSThumnailCompleteBlock)blockerror
{
    RKParams *params = [RKParams params];
    [params setValue:uToken forParam:@"token"];
    [params setValue:[NSNumber numberWithInt:type] forParam:@"type"];
    [params setData:UIImageJPEGRepresentation(image, 0.8) MIMEType:@"image/jpeg" forParam:@"resource.jpeg"];
    NSString *baseUrl =[self appendCommonRequestQueryPara:[FSModelManager sharedManager]];
    completeBlock = blockcomplete;
    errorBlock = blockerror;
    [[RKClient sharedClient] post:baseUrl params:params delegate:self];
}

- (void)requestDidStartLoad:(RKRequest *)request
{
    NSLog(@"start load");
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    NSLog(@"did send body");
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    if ([response isOK] && completeBlock ) {
        RKJSONParserJSONKit* parser = [[RKJSONParserJSONKit alloc] init];
        NSError *error = NULL;
        NSDictionary *result = [parser objectFromString:response.bodyAsString error:&error];
        if (!error && [[result objectForKey:@"statusCode"] intValue]==200)
        {
            NSString *thumnail = [result valueForKeyPath:@"data.logo"];
            completeBlock(thumnail);
        }
        else
            errorBlock(error.description);
    } else if (errorBlock){
        errorBlock(response.failureErrorDescription);
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    errorBlock(error.description);
}

@end
