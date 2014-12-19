
//
//  FSAudioShowView.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-6.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAudioShowView.h"

#define AudioLabel_Height 47

@interface FSAudioShowView(){
    UIImageView     *audioView;//音频view
    UILabel         *audioLabel;//音频展示
    UIView          *_view;//音频展示view
    UIImageView     *trashView;//删除view
    UILabel         *_cancelDesc;//提示取消方法
    UILabel         *_deleteDesc;//提示伤处方法
}

@end

@implementation FSAudioShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initControl];
    }
    return self;
}

-(void)initControl
{
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 10;
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.6;
    
    audioView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_speaker.png"]];
    audioView.frame = CGRectMake((self.frame.size.width - 52)/2, (self.frame.size.height-70)/2, 52, 70);
    [self addSubview:audioView];
    
    trashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"audio_trash_icon.png"]];
    trashView.frame = CGRectMake((self.frame.size.width - 52)/2, (self.frame.size.height-70)/2, 52, 70);
    trashView.hidden = YES;
    [self addSubview:trashView];
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(audioView.frame.origin.x + 12, audioView.frame.origin.y, 28.5, AudioLabel_Height)];
    _view.layer.cornerRadius = 12;
    _view.layer.borderWidth = 0;
    _view.clipsToBounds = YES;
    [self addSubview:_view];
    
    audioLabel = [[UILabel alloc] initWithFrame:_view.bounds];
    audioLabel.backgroundColor = [UIColor greenColor];
    [_view addSubview:audioLabel];
    
    CGRect _rect = CGRectMake(5, self.frame.size.height - 25, self.frame.size.width - 10, 20);
    
    _cancelDesc = [[UILabel alloc] initWithFrame:_rect];
    _cancelDesc.backgroundColor = [UIColor clearColor];
    _cancelDesc.text = @"手指上滑,取消评论";
    _cancelDesc.textAlignment = UITextAlignmentCenter;
    _cancelDesc.font = ME_FONT(12);
    _cancelDesc.textColor = [UIColor whiteColor];
    [self addSubview:_cancelDesc];
    
    _deleteDesc = [[UILabel alloc] initWithFrame:_rect];
    _deleteDesc.backgroundColor = [UIColor redColor];
    _deleteDesc.layer.cornerRadius = 6;
    _deleteDesc.text = @"松开手指,取消评论";
    _deleteDesc.textAlignment = UITextAlignmentCenter;
    _deleteDesc.font = ME_FONT(12);
    _deleteDesc.textColor = [UIColor whiteColor];
    _deleteDesc.hidden = YES;
    [self addSubview:_deleteDesc];
    
    [self updateAudioLabelFrame:0];
}

-(void)updateAudioLabelFrame:(double)aRate
{
    double height = aRate;
    double yOffset = AudioLabel_Height - height;
    CGRect _rect = audioLabel.frame;
    _rect.origin.y = yOffset;
    _rect.size.height = height;
    audioLabel.frame = _rect;
}

-(void)showAudioView
{
    audioView.hidden = NO;
    _view.hidden = NO;
    trashView.hidden = YES;
    _cancelDesc.hidden = NO;
    _deleteDesc.hidden = YES;
}

-(void)showTrashView
{
    audioView.hidden = YES;
    _view.hidden = YES;
    trashView.hidden = NO;
    _cancelDesc.hidden = YES;
    _deleteDesc.hidden = NO;
}

-(void)showAudioViewInUpload
{
    audioView.hidden = NO;
    _view.hidden = NO;
    trashView.hidden = YES;
    _cancelDesc.hidden = YES;
    _deleteDesc.hidden = YES;
}

@end

