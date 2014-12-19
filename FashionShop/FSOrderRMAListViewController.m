//
//  FSOrderRMAListViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-1.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderRMAListViewController.h"
#import "FSOrderListCell.h"

@interface FSOrderRMAListViewController ()

@end

@implementation FSOrderRMAListViewController

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
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
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
    return _data.rmas.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#define Order_RMA_List_Cell_Indentifier @"FSOrderRMAListCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSOrderRMAListCell *cell = (FSOrderRMAListCell*)[tableView dequeueReusableCellWithIdentifier:Order_RMA_List_Cell_Indentifier];
    if (cell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
        if (_array.count > 5) {
            cell = (FSOrderRMAListCell*)_array[5];
        }
        else{
            cell = [[FSOrderRMAListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Order_RMA_List_Cell_Indentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:_data.rmas[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSOrderRMAListCell *cell = (FSOrderRMAListCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

@end
