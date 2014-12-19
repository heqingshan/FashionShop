//
//  FSThumnailRequest.h
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define  RK_REQUEST_THUMNAIL_UPLOAD @"/customer/portrait/create"


typedef void (^FSThumnailCompleteBlock)(id);



@interface FSThumnailRequest : FSEntityRequestBase<RKRequestDelegate>
{
    FSThumnailCompleteBlock completeBlock;
    FSThumnailCompleteBlock errorBlock;
}

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) NSString *uToken;
@property(nonatomic) int type;

- (void)upload:(FSThumnailCompleteBlock)blockcomplete error:(FSThumnailCompleteBlock)blockerror;
@end
