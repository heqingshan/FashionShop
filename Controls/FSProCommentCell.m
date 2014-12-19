//
//  FSProCommentCell.m
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProCommentCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Locale.h"
#import "NSString+Extention.h"
#import "FSConfiguration.h"

#define PRO_DETAIL_COMMENT_CELL_HEIGHT 74

@interface FSProCommentCell() {
    CGRect _originalRect;
}

@end

@implementation FSProCommentCell
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
    _imgThumb.ownerUser = _data.inUser;
    id btn= [self viewWithTag:300];
    if (btn) {
        [btn removeFromSuperview];
    }
    if (CGRectIsEmpty(_originalRect)) {
        _originalRect = _lblComment.frame;
    }
    _lblComment.frame = _originalRect;
    if (data.resources &&
        data.resources.count > 0 &&
        ((FSResource*)data.resources[0]).type == 2) {
        int xOffset = 110;
        _lblComment.text = [NSString stringWithFormat:@"%@: ", _data.inUser.nickie];
        _lblComment.font = BFONT(12);
        _lblComment.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
        [_lblComment sizeToFit];
        
        if (_lblComment.frame.size.height > 50) {
            CGRect _rect = _lblComment.frame;
            _rect.size.height = 50;
            _lblComment.frame = _rect;
        }
        
        int _width = _lblComment.frame.size.width;
        _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, _lblComment.frame.origin.y, _width>xOffset?xOffset:_width, _lblComment.frame.size.height);
        
        FSResource *_audioResource = data.resources[0];
        _audioButton = [[FSAudioButton alloc] initWithFrame:CGRectMake(_lblComment.frame.origin.x + (_width>xOffset?xOffset:_width), _lblComment.frame.origin.y - 10, 65, 26)];
        _audioButton.tag = 300;
        NSMutableString *newPath = [NSMutableString stringWithString:_audioResource.relativePath];
        [newPath replaceOccurrencesOfString:@"\\" withString:@"/" options:NSCaseInsensitiveSearch range:NSMakeRange(0,newPath.length)];
        _audioButton.fullPath = [NSString stringWithFormat:@"%@%@.mp3", _audioResource.domain,newPath];
        _audioButton.audioTime = [NSString stringWithFormat:@"%d''", (_audioResource.width>0?_audioResource.width:1)];
        [self addSubview:_audioButton];
    }
    else
    {
        _lblComment.text = [NSString stringWithFormat:@"%@: %@", _data.inUser.nickie, _data.comment];
        _lblComment.lineBreakMode = NSLineBreakByTruncatingTail;
        _lblComment.font = BFONT(13);
        _lblComment.textColor = [UIColor colorWithRed:102 green:102 blue:102];
        _lblComment.numberOfLines = 0;
        CGSize newSize =  [_lblComment sizeThatFits:_lblComment.frame.size];
        _lblComment.frame = CGRectMake(_lblComment.frame.origin.x, _lblComment.frame.origin.y, newSize.width, newSize.height);
    }
    _cellHeight = _lblComment.frame.origin.y + _lblComment.frame.size.height + 5;
    
    if (![data.replyUserName isEqualToString:@""] && data.replyUserName) {
        _lblReplyDesc.frame = CGRectMake(_lblReplyDesc.frame.origin.x, _lblComment.frame.origin.y + _lblComment.frame.size.height + 5, _lblReplyDesc.frame.size.width, _lblReplyDesc.frame.size.height);
        _lblReplyDesc.hidden = NO;
        _lblReplyDesc.text = [NSString stringWithFormat:@"回复 %@", data.replyUserName];
        _lblReplyDesc.font = ME_FONT(10);
        _lblReplyDesc.textColor = [UIColor colorWithHexString:@"#999999"];
        [_lblReplyDesc sizeThatFits:_lblReplyDesc.frame.size];
        
        _cellHeight += _lblReplyDesc.frame.size.height;
    }
    else{
        _lblReplyDesc.hidden = YES;
    }
    
    _cellHeight += _lblComment.frame.origin.y;
    _cellHeight = MAX(PRO_DETAIL_COMMENT_CELL_HEIGHT, _cellHeight);
  
    _lblInDate.text = [_data.indate toLocalizedString];
    _lblInDate.font = ME_FONT(10);
    _lblInDate.textColor = [UIColor colorWithRed:153 green:153 blue:153];
}

-(void)updateFrame
{
    CGRect _rect = _lblComment.frame;
    _rect.size.width = 192;
    _lblComment.frame = _rect;
    int yOffset = 0;
    int height  = [_lblComment sizeThatFits:_lblComment.frame.size].height;
    BOOL flag = ![_data.replyUserName isEqualToString:@""] && _data.replyUserName;
    if (flag) {
        height += _lblReplyDesc.frame.size.height + 5;
    }
    yOffset = (_cellHeight - height)/2;
    
    _rect = _lblComment.frame;
    _rect.origin.y = yOffset;
    _lblComment.frame = _rect;
    
    if (_audioButton) {
        _rect = _audioButton.frame;
        _rect.origin.y = _lblComment.frame.origin.y - 7;
        _audioButton.frame = _rect;
    }
    
    if (flag) {
        _rect = _lblReplyDesc.frame;
        _rect.origin.y = _lblComment.frame.origin.y + _lblComment.frame.size.height + 5;
        _lblReplyDesc.frame = _rect;
    }
}

@end
