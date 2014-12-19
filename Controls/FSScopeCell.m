//
//  FSScopeCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-16.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSScopeCell.h"

@implementation FSScopeCell

-(void)setContent:(NSString *)content
{
    _content = content;
    if (!_lblTag)
    {
        _lblTag = [[UILabel alloc] initWithFrame:self.bounds];
        _lblTag.contentMode = UIViewContentModeCenter;
        
    }
    
    [self.contentView addSubview:_lblTag];
    _lblTag.text = _content;
    _lblTag.font = ME_FONT(12);
    _lblTag.adjustsFontSizeToFitWidth = YES;
    _lblTag.minimumFontSize = 12;
    _lblTag.numberOfLines = 0;
    _lblTag.backgroundColor = [UIColor clearColor];
    _lblTag.textColor = [UIColor colorWithHexString:@"#666666"];
    _lblTag.textAlignment = NSTextAlignmentCenter;
}

@end
