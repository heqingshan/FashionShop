//
//  FSTopicListCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-1-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSTopicListCell.h"

@implementation FSTopicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(FSTopic *)data
{
    _data = data;
    _content.contentMode = UIViewContentModeScaleAspectFill;
    _content.clipsToBounds = YES;
    
    if (_data.resources && _data.resources.count>0)
    {
        NSURL *url = [(FSResource *)_data.resources[0] absoluteUr:315];
        if (url)
        {
            [_content setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_icon320.png"]];
        }
    }
}

@end
