//
//  FSImageEditViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-20.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSimpleImageEditorView.h"

@protocol FSMeViewControllerDelegate;

@interface FSImageEditViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet AGSimpleImageEditorView *editView;
@property (strong, nonatomic) UIImage *image;
@property (strong,nonatomic) id delegate;

- (IBAction)goBack:(id)sender;
- (IBAction)cropImage:(id)sender;

@end

@interface NSObject (FSMeViewControllerDelegate)
-(void)editImageViewControllerSetImage:(FSImageEditViewController*)viewController;
@end
