//
//  FSCommonTextShowViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-29.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCommonTextShowViewController.h"
#import "FSPurchaseProdCell.h"

@interface FSCommonTextShowViewController ()

@end

@implementation FSCommonTextShowViewController

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
    self.title = _myTitle;
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#define Title_Content_Cell_Indentifier @"FSTitleContentCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTitleContentCell *cell = (FSTitleContentCell*)[tableView dequeueReusableCellWithIdentifier:Title_Content_Cell_Indentifier];
    if (cell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPurchaseProdCell" owner:self options:nil];
        if (_array.count > 3) {
            cell = (FSTitleContentCell*)_array[3];
        }
        else{
            cell = [[FSTitleContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Title_Content_Cell_Indentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setDataWithTitle:_myTitle content:_purchase.rmapolicy];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSTitleContentCell *cell = (FSTitleContentCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

@end
