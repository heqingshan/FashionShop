//
//  FSContentViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-13.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSContentViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *fileName;

@end
