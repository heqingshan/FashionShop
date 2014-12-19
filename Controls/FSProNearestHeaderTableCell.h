//
//  FSProNearestHeaderTableCell.h
//  FashionShop
//
//  Created by gong yi on 11/18/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FSProNearestHeaderTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDistance;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong,nonatomic) NSString *data;
@end
