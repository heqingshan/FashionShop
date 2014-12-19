//
//  FSPlaceHoldTextView.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

//带有placeholder的UITextView
@interface FSPlaceHoldTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, strong) UILabel *placeHolderLabel;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
