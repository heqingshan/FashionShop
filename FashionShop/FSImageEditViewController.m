//
//  FSImageEditViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-20.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSImageEditViewController.h"

@interface FSImageEditViewController ()

@end

@implementation FSImageEditViewController

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
    // Do any additional setup after loading the view from its nib.
    _editView.image = _image;
    _editView.ratio = 1;
    _editView.ratioViewBorderColor = [UIColor darkGrayColor];
    _editView.ratioViewBorderWidth = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEditView:nil];
    [super viewDidUnload];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cropImage:(id)sender {
    if ([_delegate respondsToSelector:@selector(editImageViewControllerSetImage:)]) {
        [_delegate editImageViewControllerSetImage:self];
    }
}
@end
