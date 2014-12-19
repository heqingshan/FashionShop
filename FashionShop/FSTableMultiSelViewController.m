//
//  FSTableMultiSelViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-3.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSTableMultiSelViewController.h"
#import "FSPurchase.h"

@interface FSTableMultiSelViewController ()
{
    NSMutableArray *_data;
    NSMutableArray *_checkState;
    PostTableDataSource _delegate;
    PostProgressStep _currentStep;
    id _target;
}

@end

@implementation FSTableMultiSelViewController

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
    [self addRightButton:@"保存"];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
}

- (IBAction)onButtonBack:(id)sender {
    for (int i = 0; i < _checkState.count; i++) {
        ((FSPurchaseSaleColorsItem*)_data[i]).isChecked = [_checkState[i] boolValue];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

-(void)addRightButton:(NSString*)title
{
    UIImage *btnNormal = [[UIImage imageNamed:@"btn_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setTitle:title forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    sheepButton.titleLabel.font = ME_FONT(13);
    sheepButton.showsTouchWhenHighlighted = YES;
    [sheepButton setBackgroundImage:btnNormal forState:UIControlStateNormal];
    [sheepButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)save:(UIButton*)sender
{
    if ([_target respondsToSelector:@selector(proPostStep:didCompleteWithObject:)])
        [ _target proPostStep:_currentStep didCompleteWithObject:_data];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setDataSource:(PostTableDataSource)source step:(PostProgressStep)current selectedCallbackTarget:(id)target
{
    _delegate = source;
    _currentStep = current;
    _target = target;
    [self prepareData];
}

-(void) prepareData
{
    if (_delegate) {
        _data = _delegate();
        if (!_checkState) {
            _checkState = [NSMutableArray arrayWithCapacity:_data.count];
        }
        else{
            [_checkState removeAllObjects];
        }
        for (int i = 0; i < _data.count; i++) {
            FSPurchaseSaleColorsItem *item = _data[i];
            [_checkState addObject:[NSNumber numberWithBool:item.isChecked]];
        }
    }
}

#pragma UITableViewSource delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data?_data.count:0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *detailCell =  [tableView dequeueReusableCellWithIdentifier:@"defaultcell"];
    if (!detailCell)
    {
        detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"];
        detailCell.textLabel.font = ME_FONT(14);
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    FSPurchaseSaleColorsItem *item = _data[indexPath.row];
    detailCell.textLabel.text = item.colorName;
    if (item.isChecked) {
        detailCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        detailCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return detailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSPurchaseSaleColorsItem *item = _data[indexPath.row];
    item.isChecked = !item.isChecked;
    [_tbAction reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
