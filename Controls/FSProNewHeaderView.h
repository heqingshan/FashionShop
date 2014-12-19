//
//  FSProNewHeaderView.h
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProNewHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *imgWhen;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;


@property (strong, nonatomic) IBOutlet UILabel *lblStartDate;


@property (nonatomic,strong) NSDate *data;

@end

@interface FSProNewHeaderView_1 : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic,strong) NSDate *data;

@end
