//
//  FSProCommentHeader.h
//  FashionShop
//
//  Created by gong yi on 12/24/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSProCommentHeader : UIView
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCount;

@property(nonatomic) int count;
@end
