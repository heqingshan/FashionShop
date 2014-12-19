//
//  FSAudioHelper.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-5.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSAudioHelper : NSObject{
    BOOL recording;
}

- (void)initSession;
- (BOOL)hasHeadset;
- (BOOL)hasMicphone;
- (void)cleanUpForEndRecording;
- (BOOL)checkAndPrepareCategoryForRecording;

@end
