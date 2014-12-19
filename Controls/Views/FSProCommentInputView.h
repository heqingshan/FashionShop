//
//  FSProCommentInputView.h
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSKeyboardAvoidingUIView.h"

@interface FSProCommentInputView : FSKeyboardAvoidingUIView<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;
@property (strong, nonatomic) IBOutlet UIButton *btnChange;//切换状态按钮
@property (strong, nonatomic) IBOutlet UIButton *btnAudio;
@property (strong, nonatomic) IBOutlet UIView *txtView;
@property (strong, nonatomic) IBOutlet UILabel *replyLabel;

//type==1:评论文字
//type==2:评论语音
-(void)updateControls:(int)type;

@end


@interface FSPLetterCommentInputView : FSKeyboardAvoidingUIView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *txtView;
@property (strong, nonatomic) IBOutlet UITextView *txtComment;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet UIButton *btnComment;

@end