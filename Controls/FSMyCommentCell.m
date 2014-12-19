//
//  FSMyCommentCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSMyCommentCell.h"
#import "NSDate+Locale.h"

#define PRO_DETAIL_COMMENT_CELL_HEIGHT 74

@interface FSMyCommentCell() {
    CGRect _originalRect;
}

@end

@implementation FSMyCommentCell
@synthesize data = _data;
@synthesize cellHeight = _cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(FSComment *)data{
    _data = data;
    _imgThumb.ownerUser = _data.replyUser;
    id btn= [self viewWithTag:200];
    if (btn) {
        [btn removeFromSuperview];
    }
    if (CGRectIsEmpty(_originalRect)) {
        _originalRect = _lblComment.frame;
    }
    _lblComment.frame = _originalRect;
    if (data.myResource &&
        data.myResource.type == 2) {
        int xOffset = 110;
        _lblComment.text = [NSString stringWithFormat:@"%@: ", _data.replyUser.nickie];
        _lblComment.font = BFONT(13);
        _lblComment.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
        [_lblComment sizeToFit];
        //[_lblComment sizeThatFits:_lblComment.frame.size];
        
        if (_lblComment.frame.size.height > 50) {
            CGRect _rect = _lblComment.frame;
            _rect.size.height = 50;
            _lblComment.frame = _rect;
        }
        
        int _width = _lblComment.frame.size.width;
        _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, _lblComment.frame.origin.y, _width>xOffset?xOffset:_width, _lblComment.frame.size.height);
        
        FSResource *_audioResource = data.myResource;
        _audioButton = [[FSAudioButton alloc] initWithFrame:CGRectMake(_lblComment.frame.origin.x + (_width>xOffset?xOffset:_width), _lblComment.frame.origin.y - 10, 65, 26)];
        _audioButton.tag = 200;
        NSMutableString *newPath = [NSMutableString stringWithString:_audioResource.relativePath];
        [newPath replaceOccurrencesOfString:@"\\" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0,newPath.length)];
        _audioButton.fullPath = [NSString stringWithFormat:@"%@%@.mp3", _audioResource.domain,newPath];
        _audioButton.audioTime = [NSString stringWithFormat:@"%d''", (_audioResource.width>0?_audioResource.width:1)];
        [self addSubview:_audioButton];
    }
    else
    {
        _lblComment.text = [NSString stringWithFormat:@"%@: %@", _data.replyUser.nickie, _data.comment];
        _lblComment.lineBreakMode = NSLineBreakByTruncatingTail;
        _lblComment.font = BFONT(13);
        _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
        _lblComment.numberOfLines = 0;
        CGSize newSize =  [_lblComment sizeThatFits:_lblComment.frame.size];
        _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, 8, 225, newSize.height);
    }
    _cellHeight = _lblComment.frame.origin.y + _lblComment.frame.size.height + 8;
    
    //回复时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    _lblInDate.text = [df stringFromDate:_data.indate];
    _lblInDate.hidden = NO;
    _lblInDate.frame = CGRectMake(_lblInDate.frame.origin.x, _cellHeight + 8, 225, _lblInDate.frame.size.height);
    _lblInDate.font = ME_FONT(13);
    _lblInDate.textColor = [UIColor colorWithRed:153 green:153 blue:153];
    _cellHeight += _lblInDate.frame.size.height + 8;
    
    //回复人名称
    _lblReplyDesc.frame = CGRectMake(_lblReplyDesc.frame.origin.x, _cellHeight + 5, 225, _lblReplyDesc.frame.size.height);
    _lblReplyDesc.hidden = NO;
    if (![data.replyUserName_myComment isEqualToString:@""] && data.replyUserName_myComment) {
        _lblReplyDesc.text = [NSString stringWithFormat:@"回复 %@", data.replyUserName_myComment];
    }
    else{
        _lblReplyDesc.text = [NSString stringWithFormat:@"评论您参与的%@", _data.sourcetype==1?@"商品":@"活动"];
    }
    _lblReplyDesc.font = ME_FONT(13);
    [_lblReplyDesc sizeThatFits:_lblReplyDesc.frame.size];
    _cellHeight += _lblReplyDesc.frame.size.height;
    
    _cellHeight += 8;
    _cellHeight = MAX(PRO_DETAIL_COMMENT_CELL_HEIGHT, _cellHeight);
    
    CGRect _rect = _dotView.frame;
    _rect.origin.y = (_cellHeight - 13)/2;
    _dotView.frame = _rect;
}

-(void)updateFrame
{
    int yOffset = 0;
    int height  = [_lblComment sizeThatFits:_lblComment.frame.size].height;
    height += _lblInDate.frame.size.height + 5;
    height += _lblReplyDesc.frame.size.height + 5;
    yOffset = (_cellHeight - height)/2;
    
    CGRect _rect = _lblComment.frame;
    _rect.origin.y = yOffset;
    _lblComment.frame = _rect;
    
    if (_audioButton) {
        _rect = _audioButton.frame;
        _rect.origin.y = _lblComment.frame.origin.y - 7;
        //_rect.origin.x = _lblComment.frame.origin.x + _lblComment.frame.size.width + 3;
        _audioButton.frame = _rect;
    }
    
    _rect = _lblInDate.frame;
    _rect.origin.y = _lblComment.frame.size.height + _lblComment.frame.origin.y + 5;
    _lblInDate.frame = _rect;
    
    _rect = _lblReplyDesc.frame;
    _rect.origin.y = _lblInDate.frame.origin.y + _lblInDate.frame.size.height + 5;
    _lblReplyDesc.frame = _rect;
}

@end

@implementation FSMyLetterCell

-(void)setData:(FSMyLetter *)data{
    _data = data;
    _imgThumb.ownerUser = data.fromuser;
    int yOffset = 10;
    
    _name.hidden = NO;
    _name.text = data.fromuser.nickie;
    _name.lineBreakMode = NSLineBreakByTruncatingTail;
    _name.font = BFONT(13);
    _name.textColor = [UIColor colorWithRed:102 green:102 blue:102];
    CGSize newSize =  [_name sizeThatFits:_name.frame.size];
    if (newSize.height < 25) {
        newSize.height = 25;
    }
    _name.frame = CGRectMake(_name.frame.origin.x, yOffset, 225, newSize.height);
    _cellHeight = _name.frame.origin.y + _name.frame.size.height;
    
    _lblComment.hidden = NO;
    _lblComment.text = data.msg;
    _lblComment.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblComment.font = BFONT(13);
    _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
    _lblComment.numberOfLines = 0;
    newSize =  [_lblComment sizeThatFits:_lblComment.frame.size];
    if (newSize.height > 100) {
        newSize.height = 100;
    }
    _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, _cellHeight, 225, newSize.height);
    _cellHeight += _lblComment.frame.size.height + yOffset;
    
    //回复时间
    _time.text = [data.createdate toLocalizedString];
    _time.hidden = NO;
    _time.font = ME_FONT(13);
    _time.textColor = [UIColor colorWithRed:153 green:153 blue:153];
    
    if (_cellHeight < 74) {
        _cellHeight = 74;
    }
    
    CGRect _rect = _dotView.frame;
    _rect.origin.y = (_cellHeight - 13)/2;
    _dotView.frame = _rect;
}

@end

@implementation FSMyLetterToCell

-(void)setData:(FSCoreMyLetter *)data{
    _data = data;
    FSCoreUser *temp = nil;
    FSUser *cur = [FSUser localProfile];
    if ([cur.uid intValue] == data.fromuser.uid) {
        temp = data.touser;
    }
    else{
        temp = data.fromuser;
    }
    _imgThumb.ownerUser = [[FSUser alloc] copyUser:temp];
    int yOffset = 10;
    
    _lblComment.hidden = NO;
    _lblComment.text = data.msg;
    _lblComment.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblComment.font = BFONT(13);
    _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
    _lblComment.numberOfLines = 0;
    CGSize newSize =  [_lblComment sizeThatFits:_lblComment.frame.size];
    if (newSize.height < 30) {
        newSize.height = 30;
    }
    _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, yOffset, 225, newSize.height);
    _cellHeight = _lblComment.frame.origin.y + _lblComment.frame.size.height + yOffset;
    
    //回复时间
    _time.text = [data.createdate toLocalizedString];//[NSString stringWithFormat:@"%@", data.createdate];//
    _time.hidden = NO;
    _time.frame = CGRectMake(_time.frame.origin.x, _cellHeight, 225, _time.frame.size.height);
    _time.font = ME_FONT(13);
    _time.textColor = [UIColor colorWithRed:153 green:153 blue:153];
    _cellHeight += _time.frame.size.height + yOffset;
    
    if (_cellHeight < 74) {
        _cellHeight = 74;
    }
}

@end

@implementation FSMyLetterFromCell

-(void)setData:(FSCoreMyLetter *)data{
    _data = data;
    FSCoreUser *temp = nil;
    FSUser *cur = [FSUser localProfile];
    if ([cur.uid intValue] == data.fromuser.uid) {
        temp = data.fromuser;
    }
    else{
        temp = data.touser;
    }
    _imgThumb.ownerUser = [[FSUser alloc] copyUser:temp];;
    int yOffset = 10;
    
    _lblComment.hidden = NO;
    _lblComment.text = data.msg;
    _lblComment.lineBreakMode = NSLineBreakByTruncatingTail;
    _lblComment.font = BFONT(13);
    _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
    _lblComment.numberOfLines = 0;
    CGSize newSize =  [_lblComment sizeThatFits:_lblComment.frame.size];
    if (newSize.height > 25) {
        _lblComment.textAlignment = UITextAlignmentLeft;
    }
    if (newSize.height < 30) {
        newSize.height = 30;
    }
    _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, yOffset, 225, newSize.height);
    _cellHeight = _lblComment.frame.origin.y + _lblComment.frame.size.height + yOffset;
    
    //回复时间
    _time.text = [data.createdate toLocalizedString];
    _time.hidden = NO;
    _time.frame = CGRectMake(_time.frame.origin.x, _cellHeight, 225, _time.frame.size.height);
    _time.font = ME_FONT(13);
    _time.textColor = [UIColor colorWithRed:153 green:153 blue:153];
    _cellHeight += _time.frame.size.height + yOffset;
    
    if (_cellHeight < 74) {
        _cellHeight = 74;
    }
}

@end