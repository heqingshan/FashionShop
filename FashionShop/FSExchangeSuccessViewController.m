//
//  FSExchangeSuccessViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSExchangeSuccessViewController.h"
#import "FSPointExDescCell.h"
#import "FSPointExSuccessFooter.h"
#import "FSGiftListViewController.h"
#import "FSPointGiftListViewController.h"
#import "FSPointGiftDetailViewController.h"

@interface FSExchangeSuccessViewController ()

@end

@implementation FSExchangeSuccessViewController

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
    self.title = @"领兑成功";
    self.navigationItem.hidesBackButton = YES;
    [self loadFooter];
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
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

-(void)loadFooter
{
    NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPointExSuccessFooter" owner:self options:nil];
    if (_array.count > 0) {
        FSCommonSuccessFooter *footer = (FSCommonSuccessFooter*)_array[0];
        [footer.continueBtn setTitle:@"继续兑换" forState:UIControlStateNormal];
        [footer.continueBtn addTarget:self action:@selector(clickToContinue:) forControlEvents:UIControlEventTouchUpInside];
        [footer.backHomeBtn setTitle:@"代金券详情" forState:UIControlStateNormal];
        [footer.backHomeBtn addTarget:self action:@selector(clickToBackHome:) forControlEvents:UIControlEventTouchUpInside];
        [footer initView:_data.exclude];
        _tbAction.tableFooterView = footer;
    }
}

-(void)setData:(FSExchangeSuccess *)data
{
    _data = data;
}

-(void)clickToContinue:(UIButton*)sender
{
    NSArray *_array = (NSArray*)self.navigationController.viewControllers;
    _array = [_array subarrayWithRange:NSMakeRange(0, _array.count-3)];
    [self.navigationController setViewControllers:_array animated:YES];
    
    [[FSAnalysis instance] logEvent:EXCHANGE_SUCCESS_CONTINUE withParameters:nil];
}

-(void)clickToBackHome:(UIButton*)sender
{
    UITabBarController *root = (UITabBarController*)theApp.window.rootViewController;
    root.selectedIndex = 3;
    UINavigationController *nav = (UINavigationController*)root.viewControllers[3];
    [nav popToRootViewControllerAnimated:NO];
    NSMutableArray *_mutArray = [NSMutableArray arrayWithObject:nav.topViewController];
    FSGiftListViewController *couponView = [[FSGiftListViewController alloc] initWithNibName:@"FSGiftListViewController" bundle:nil];
    couponView.currentUser = [FSUser localProfile];
    [_mutArray addObject:couponView];
    FSPointGiftListViewController *controller= [[FSPointGiftListViewController alloc] initWithNibName:@"FSPointGiftListViewController" bundle:nil];
    [_mutArray addObject:controller];
    FSPointGiftDetailViewController *detail = [[FSPointGiftDetailViewController alloc] initWithNibName:@"FSPointGiftDetailViewController" bundle:nil];
    detail.requestID = _data.storeProId;
    [_mutArray addObject:detail];
    
    [nav setViewControllers:_mutArray animated:YES];
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

#define Point_Ex_Success_Cell_Indentifier @"FSPointExSuccessCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSPointExSuccessCell *cell = (FSPointExSuccessCell*)[tableView dequeueReusableCellWithIdentifier:Point_Ex_Success_Cell_Indentifier];
    if (cell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPointExDescCell" owner:self options:nil];
        if (_array.count > 0) {
            cell = (FSPointExSuccessCell*)_array[4];
        }
        else{
            cell = [[FSPointExSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Point_Ex_Success_Cell_Indentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setData:_data];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
    FSPointExSuccessCell *cell = (FSPointExSuccessCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

@end
