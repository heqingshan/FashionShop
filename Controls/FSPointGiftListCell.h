//
//  FSPointGiftListCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSExchange.h"

@interface FSPointGiftListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UILabel *valideTime;
@property (strong, nonatomic) IBOutlet UILabel *amountView;
@property (strong, nonatomic) IBOutlet UILabel *giftNumber;
@property (nonatomic) int cellHeight;

@property (nonatomic, strong) FSGiftListItem* data;

@end

@interface FSPointGiftInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *validate;
@property (strong, nonatomic) IBOutlet UILabel *useStore;
@property (strong, nonatomic) IBOutlet UILabel *pointCount;
@property (strong, nonatomic) IBOutlet UILabel *cashCount;
@property (strong, nonatomic) IBOutlet UILabel *giftCode;
@property (strong, nonatomic) IBOutlet UILabel *attention;

@property (nonatomic, strong) FSGiftListItem* data;

@end
