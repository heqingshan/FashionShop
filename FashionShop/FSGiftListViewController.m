//
//  FSMoreViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSGiftListViewController.h"
#import "FSCouponViewController.h"
#import "FSPointGiftListViewController.h"

@interface FSGiftListViewController () {
    NSArray *_titles;
}

@end

@implementation FSGiftListViewController

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
    self.title = NSLocalizedString(@"Gift List", nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _titles = @[NSLocalizedString(@"My Promotion List",nil),
                NSLocalizedString(@"My Point Exchange List",nil)];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"GiftCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_titles objectAtIndex:indexPath.row];
    cell.textLabel.font = BFONT(14);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            FSCouponViewController *couponView = [[FSCouponViewController alloc] initWithNibName:@"FSCouponViewController" bundle:nil];
            couponView.currentUser = _currentUser;
            [self.navigationController pushViewController:couponView animated:true];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"礼券列表页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_COUPON_LIST withParameters:_dic];
        }
            break;
        case 1:
        {
            FSPointGiftListViewController *controller= [[FSPointGiftListViewController alloc] initWithNibName:@"FSPointGiftListViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:true];

            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"礼券列表页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_CASH_COUPON_LIST withParameters:_dic];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
