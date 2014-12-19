//
//  FSCouponProDetailCell.h
//  FashionShop
//
//  Created by gong yi on 12/31/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCoupon.h"

@interface FSCouponProDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
@property (strong, nonatomic) IBOutlet UILabel *lblStore;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (nonatomic) int cellHeight;

@property (strong,nonatomic) FSCoupon *data;

@end
