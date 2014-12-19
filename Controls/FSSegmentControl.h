//
//  FSSegmentControl.h
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSSegmentControl : UISegmentedControl

@property(nonatomic) CGFloat arrowSize;

-(void)setSegBGColor:(UIColor*)aColor;
-(void)setTitleColor:(UIColor*)aColor selectedColor:(UIColor*)aSelColor;

@end
