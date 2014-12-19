//
//  FSLikeDetailCell.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"
#import "FSThumView.h"

@interface FSLikeDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet FSThumView *thumbImg;
@property (strong, nonatomic) IBOutlet UILabel *lblNickie;
@property (strong, nonatomic) IBOutlet UILabel *lblLike;
@property (strong, nonatomic) IBOutlet UILabel *lblFans;
@property (strong, nonatomic) IBOutlet UIImageView *line1;

@property (strong,nonatomic) FSUser *data;

@end
