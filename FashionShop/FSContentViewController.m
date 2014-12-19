//
//  FSContentViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-13.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSContentViewController.h"

@interface FSContentViewController ()

@end

@implementation FSContentViewController
@synthesize webView;
@synthesize fileName;

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
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileName]]];
    webView.backgroundColor = [UIColor clearColor];
    if (IOS7) {
        CGRect _rect = webView.frame;
        _rect.origin.y = NAV_HIGH;
        _rect.size.height = _rect.size.height - NAV_HIGH;
        webView.frame = _rect;
    }
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
}

-(void)onButtonBack:(UIButton*)sender
{
    if (webView.canGoBack) {
        [webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
