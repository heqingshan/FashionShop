//
//  FSBaseViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-9-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSBaseViewController.h"

@interface FSBaseViewController ()

@end

@implementation FSBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    if (IOS7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = YES;
//        
//        FSAppDelegate *del = (FSAppDelegate*)[UIApplication sharedApplication].delegate;
//        [del setGlobalLayout];
//    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
