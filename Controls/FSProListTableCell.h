//
//  FSProListTableCell.h
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProItemEntity.h"

@interface FSProListTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;

@property (strong,nonatomic) FSProItemEntity *data;

@end
