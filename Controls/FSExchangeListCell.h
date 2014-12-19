//
//  FSExchangeListCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSExchange.h"

@interface FSExchangeListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *activityTime;

@property (nonatomic, strong) FSExchange* data;

@end
