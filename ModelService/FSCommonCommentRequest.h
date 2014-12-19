//
//  FSCommonCommentRequest.h
//  FashionShop
//
//  Created by gong yi on 12/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_COMMENT_LIST @"/comment/list"
#define RK_REQUEST_COMMENT_SAVE @"/comment/create"
#define RK_REQUEST_MYCOMMENT_LIST @"/comment/my"

typedef void (^FSCommentCompleteBlock)(id);

@interface FSCommonCommentRequest : FSEntityRequestBase<RKRequestDelegate> {
    
}

@property(nonatomic,strong) NSNumber *id;
@property(nonatomic,strong) NSNumber *sourceid;
@property(nonatomic,strong) NSNumber *sourceType;//0:product,1:promotion
@property(nonatomic,strong) NSNumber *nextPage;
@property(nonatomic,strong) NSNumber *pageSize;
@property(nonatomic,strong) NSNumber *sort;
@property(nonatomic,strong) NSDate *refreshTime;
@property(nonatomic,strong) NSNumber* userId;
@property(nonatomic,strong) NSString *userToken;
@property(nonatomic,strong) NSString *comment;
@property(nonatomic,strong) NSNumber *replyuserID;
@property(nonatomic,strong) NSString *audioName;
@property(nonatomic) BOOL isAudio;

- (void)upload:(FSCommentCompleteBlock)blockcomplete error:(FSCommentCompleteBlock)blockerror;

@end
