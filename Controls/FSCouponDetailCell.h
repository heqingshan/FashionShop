//
//  FSCouponDetailCell.h
//  FashionShop
//
//  Created by gong yi on 11/28/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCoupon.h"

@interface FSCouponDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgPro;
@property (strong, nonatomic) IBOutlet UILabel *lblCode;
@property (strong, nonatomic) IBOutlet UILabel *lblStore;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;

@property (strong,nonatomic) FSCoupon *data;

@end
