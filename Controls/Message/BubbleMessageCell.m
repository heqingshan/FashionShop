//
//  BubbleMessageCell.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "BubbleMessageCell.h"
#import "NSDate+Locale.h"

@interface BubbleMessageCell()

- (void)setup;

@end



@implementation BubbleMessageCell

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    
    self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _bubbleView = [[BubbleView alloc] init];
    [self.contentView addSubview:_bubbleView];
    
    _thumView = [[FSThumView alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    [self.contentView addSubview:_thumView];
    
    //[self attachTapHandler];
}

-(void)updateControls:(FSCoreMyLetter *)aData showTime:(BOOL)flag
{
    [aData show];
    CGRect _rect;
    int unit = 5;
    int yOffset = unit+5;
    if (flag) {
        NSTimeInterval fromNow = abs([aData.createdate timeIntervalSinceNow]);
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        if (fromNow < 12 * 60 * 60) {
            [df setDateFormat:@"HH:mm:ss"];
        }
        else{
            [df setDateFormat:@"yy年MM月dd日 HH:mm:ss"];
        }
        _time.text = [df stringFromDate:aData.createdate];
        _time.hidden = NO;
        _rect = _time.frame;
        _rect.origin.y = yOffset;
        _time.frame = _rect;
        yOffset += _rect.size.height;
    }
    else{
        _time.hidden = YES;
    }

    self.bubbleView.text = aData.msg;
    int height = [BubbleView cellHeightForText:aData.msg];
    self.bubbleView.frame = CGRectMake(45,
                                       yOffset,
                                       self.contentView.frame.size.width - 90,
                                       height);
    
    yOffset += height + unit;
    
    _rect = _thumView.frame;
    _rect.origin.y = yOffset - _rect.size.height - unit - 7;
    
    int _id = aData.fromuser.uid;
    if (_id != [[FSModelManager sharedModelManager].localLoginUid intValue] && _id != 0)
    {
        _rect.origin.x = 5;
    }
    else
    {
        _rect.origin.x = SCREEN_WIDTH - _rect.size.width - 5;
    }
    _thumView.layer.cornerRadius = 8;
    _thumView.clipsToBounds = YES;
    _thumView.ownerUser = [[FSUser alloc] copyUser:aData.fromuser];
    _thumView.frame = _rect;
    
    _cellHeight = yOffset;
}

- (id)initWithBubbleStyle:(BubbleMessageStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        [self.bubbleView setStyle:style];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.bubbleView setBackgroundColor:backgroundColor];
}

#pragma mark - menu

//UILabel默认是不接收事件的，我们需要自己添加touch事件
-(void)attachTapHandler{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    //长按压
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 1.0;
    [self addGestureRecognizer:press];
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.bubbleView.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

// default is NO
- (BOOL)canBecomeFirstResponder{
    return YES;
}

//"反馈"关心的功能
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

@end