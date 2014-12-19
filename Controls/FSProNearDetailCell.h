//
//  FSProNearDetailCell.h
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProItemEntity.h"
#import "RTLabel.h"

@interface FSProNearDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *timeView;
@property (strong, nonatomic) IBOutlet UIImageView *line;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (nonatomic) int cellHeight;

-(void)setTitle:(NSString *)_title subTitle:(NSString *)_subTitle dateString:(NSString*)_dateString;


@end

@interface FSProDateDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UILabel *descView;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *timeView;
@property (strong, nonatomic) IBOutlet UIImageView *addressIcon;
@property (strong, nonatomic) IBOutlet UIImageView *line;
@property (strong, nonatomic) IBOutlet UIImageView *line2;
@property (nonatomic) int cellHeight;

-(void)setTitle:(NSString *)_title desc:(NSString *)_desc address:(NSString*)aAddress dateString:(NSString*)_dateString;


@end
