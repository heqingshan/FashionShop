//
//  FSFeedback1ViewController.h
//  FashionShop
//
//  Created by  赵学智 on 13-1-15.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"
#import "FSPlaceHoldTextView.h"




@interface FSFeedbackViewController : FSBaseViewController<UITextFieldDelegate,UITextViewDelegate>

@property (strong, nonatomic) FSUser *currentUser;

@property (strong, nonatomic) IBOutlet FSPlaceHoldTextView *txtContent;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;
@end

