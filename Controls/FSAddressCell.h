//
//  FSAddressCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-25.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSAddress.h"

@interface FSAddressListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *tel;
@property (strong, nonatomic) IBOutlet UILabel *addressDesc;

@property (strong,nonatomic) FSAddress *data;

@end
