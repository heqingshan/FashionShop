//
//  FSStoreDetailCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSStoreDescCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic) IBOutlet UILabel *description;

@property (nonatomic) int cellHeight_Expand;
@property (nonatomic) int cellHeight_Contract;
@property (nonatomic,strong) NSString *descData;

@end

@interface FSStoreProHeadView : UIView
@property (strong, nonatomic) IBOutlet UIButton *moreProductBtn;

@end
