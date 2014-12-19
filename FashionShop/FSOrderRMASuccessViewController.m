//
//  FSOrderRMASuccessViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderRMASuccessViewController.h"
#import "FSOrderListCell.h"
#import "RTLabel.h"

@interface FSOrderRMASuccessViewController ()

@end

@implementation FSOrderRMASuccessViewController

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
    
    _tbAction.tableFooterView = [self createTableFooter];
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
}

- (IBAction)onButtonBack:(id)sender {
    NSArray *_array = (NSArray*)self.navigationController.viewControllers;
    _array = [_array subarrayWithRange:NSMakeRange(0, _array.count-2)];
    [self.navigationController setViewControllers:_array animated:YES];
}

-(UIView*)createTableFooter
{   
    UIView *view = [[UIView alloc] init];
    int yOffset = 10;
    NSString *msg = [theApp messageForKey:EM_O_R_SUCC];
    NSString *str = [NSString stringWithFormat:@"<font face='%@' size=16 color='#181818'>注意事项: \n</font><font face='%@' size=14 color='#181818'>%@</font>", Font_Name_Bold, Font_Name_Normal, msg];
    RTLabel *desc = [[RTLabel alloc] initWithFrame:CGRectMake(10, yOffset, 300, 0)];
    desc.backgroundColor = [UIColor clearColor];
    [desc setText:str];
    CGRect _rect = desc.frame;
    _rect.size.height = desc.optimumSize.height;
    desc.frame = _rect;
    yOffset += _rect.size.height + 15;
    [view addSubview:desc];
    
    UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClean.frame = CGRectMake(49, yOffset, 222, 40);
    [btnClean setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClean addTarget:self action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
    btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:btnClean];
    yOffset += 40 + 20;
    
    _rect = view.frame;
    _rect.size.height = yOffset;
    view.frame = _rect;
    
    return view;
}

-(void)backToHome:(UIButton*)sender
{
    NSArray *_array = (NSArray*)self.navigationController.viewControllers;
    _array = [_array subarrayWithRange:NSMakeRange(0, _array.count-3)];
    [self.navigationController setViewControllers:_array animated:YES];
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
    [cell setData:_data];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSOrderRMAListCell *cell = (FSOrderRMAListCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

@end
