//
//  FSMyLetter.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreModelBase.h"
#import "FSCoreUser.h"

@interface FSCoreMyLetter : FSCoreModelBase

@property (nonatomic,strong) FSCoreUser *touser;
@property (nonatomic,strong) FSCoreUser *fromuser;
@property (nonatomic) BOOL isauto;
@property (nonatomic) int id;
@property (nonatomic) BOOL isvoice;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSDate *createdate;

+ (NSArray*) fetchData:(int)latestId one:(int)oneId two:(int)twoId length:(int)length ascending:(BOOL)flag;
+(int) lastConversationId:(int)oneId two:(int)twoId;
+(FSCoreMyLetter*)findLetterByConversationId:(int)id;
+(NSArray*) fetchLatestLetters:(int)length one:(int)oneId two:(int)twoId;
+(void) cleanMessage;

-(void)show;

@end
