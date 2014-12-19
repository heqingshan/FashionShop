//
//  FSProCommentInputView.m
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProCommentInputView.h"
#import "FSConfiguration.h"

@implementation FSProCommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareLayout];
    }
    return self;
}

-(void) prepareLayout
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:102 green:102 blue:102].CGColor;
    self.clipsToBounds = YES;
}

//type==1:评论文字
//type==2:评论语音
-(void)updateControls:(int)type
{
    if (type == 1) {
        _txtView.hidden = NO;
        _btnAudio.hidden = YES;
        _btnComment.hidden = NO;
    }
    else{
        _txtView.hidden = YES;
        _btnAudio.hidden = NO;
        _btnComment.hidden = YES;
    }
}

@end

@implementation FSPLetterCommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareLayout];
    }
    return self;
}

-(void) prepareLayout
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithRed:102 green:102 blue:102].CGColor;
    self.clipsToBounds = YES;
}

@end
