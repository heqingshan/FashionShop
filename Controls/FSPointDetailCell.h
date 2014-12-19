//
//  FSPointDetailCell.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPoint.h"

@interface FSPointDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblReason;

@property (strong, nonatomic) IBOutlet UIImageView *line1;
@property (strong, nonatomic) IBOutlet UILabel *lblInDate;

@property(nonatomic,strong) FSPoint *data;

@end
