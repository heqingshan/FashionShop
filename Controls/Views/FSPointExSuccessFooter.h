//
//  FSPointView.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSExchange.h"
#import "FSPurchase.h"

@interface FSCommonSuccessFooter : UIView

@property (strong, nonatomic) IBOutlet UIButton *continueBtn;
@property (strong, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (strong, nonatomic) IBOutlet UILabel *infomationDesc;

-(void)initView:(NSString*)content;

@end
