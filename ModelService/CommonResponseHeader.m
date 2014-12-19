//
//  CommonResponseHeader.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "CommonResponseHeader.h"

@implementation CommonResponseHeader
@synthesize statusCode,isSuccessful,token,message;

+ (void) setMappingForCommonHeader:(RKObjectMapping *)mapping{

    [mapping mapKeyPathsToAttributes:@"isSuccessful",@"isSuccessful",@"message",@"message",nil];
     
}
@end
