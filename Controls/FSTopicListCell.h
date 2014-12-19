//
//  FSTopicListCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSTopic.h"
#import "UIImageView+WebCache.h"

@interface FSTopicListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *content;

@property (nonatomic, strong) FSTopic *data;

@end
