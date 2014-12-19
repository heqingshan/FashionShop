//
//  FSLikeDetailCell.m
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSLikeDetailCell.h"
#import "UIImageView+WebCache.h"
#import "FSConfiguration.h"
#import "UITableViewCell+BG.h"

@implementation FSLikeDetailCell
@synthesize data = _data;
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
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        UIView *bg = [[UIView alloc] initWithFrame:self.frame];
        bg.backgroundColor =[UIColor grayColor];
        self.selectedBackgroundView =bg;
    }
    return self;
}

-(void)setData:(FSUser *)data
{
    if (_data == data)
        return;
    _data= data;
    _thumbImg.ownerUser = _data;
    _lblNickie.text = data.nickie;
    _lblNickie.font = ME_FONT(16);
    _lblNickie.textColor = [UIColor colorWithHexString:@"#666666"];
    [_lblNickie sizeToFit];
    _lblFans.text= [NSString stringWithFormat:NSLocalizedString(@"fans:%d", Nil),_data.fansTotal];
    _lblFans.textColor = [UIColor colorWithHexString:@"#666666"];
    _lblFans.font = ME_FONT(14);
    _lblLike.text= [NSString stringWithFormat:NSLocalizedString(@"like:%d", Nil),_data.likeTotal];
    _lblLike.font = ME_FONT(14);
    _lblLike.textColor = [UIColor colorWithHexString:@"#666666"];
    
    _line1.frame = CGRectMake(0, self.frame.size.height - 2, APP_WIDTH, 2);
}

@end
