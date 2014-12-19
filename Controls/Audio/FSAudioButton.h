//
//  FSAudioButton.h
//  FashionShop
//
//  Created by HeQingshan on 13-3-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Normal,
    Playing,
    Stop,
    Loading,
    Pause,
}AudioState;

@class FSAudioButton;
@protocol FSAudioDelegate <NSObject>

-(void)clickAudioButton:(FSAudioButton*)aButton;

@end

@interface FSAudioButton : UIButton<AVAudioPlayerDelegate>

@property (nonatomic,strong) NSString *fullPath;//声音文件
@property (nonatomic,assign) AudioState state;
@property (nonatomic,assign) id<FSAudioDelegate> audioDelegate;
@property (nonatomic,strong) NSString *audioTime;

-(void)play;
-(void)stop;
-(void)pause;

-(void)initControl;
-(BOOL)isPlaying;

-(void)setTitleFrame:(CGRect)_rect;
-(void)setPlayButtonFrame:(CGRect)_rect;

@end
