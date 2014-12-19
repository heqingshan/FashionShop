//
//  FSOrderDetailViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-30.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSOrderDetailViewController.h"
#import "FSPurchaseRequest.h"
#import "FSOrder.h"
#import "FSOrderListCell.h"
#import "FSOrderRMARequestViewController.h"
#import "FSOrderRMACommitViewController.h"
#import "WxPayOrder.h"

@interface FSOrderDetailViewController ()
{
    FSOrderInfo *orderInfo;
    WxpayOrder *wxPayOrder;
}

@end

@implementation FSOrderDetailViewController
@synthesize orderno;

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
    self.title = @"订单详情";
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}

-(void)requestData
{
    FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_ORDER_DETAIL;
    request.orderno = orderno;
    request.uToken = [FSModelManager sharedModelManager].loginToken;
    [self beginLoading:self.view];
    _tbAction.hidden = YES;
    [request send:[FSOrderInfo class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        [self endLoading:self.view];
        _tbAction.hidden = NO;
        if (respData.isSuccess)
        {
            orderInfo = respData.responseData;
            //显示右上角按钮
            if (orderInfo.statust == 0 && ![DELIVERY_PAY_CODE isEqualToString:orderInfo.paymentcode]) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn addTarget:self action:@selector(requestOnlinePay:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"在线支付" forState:UIControlStateNormal];
                btn.titleLabel.font = ME_FONT(13);
                btn.showsTouchWhenHighlighted = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"btn_big_normal.png"] forState:UIControlStateNormal];
                [btn sizeToFit];
                UIBarButtonItem *baritemSet= [[UIBarButtonItem alloc] initWithCustomView:btn];
                [self.navigationItem setRightBarButtonItem:baritemSet];
            }
            else {
                [self.navigationItem setRightBarButtonItem:nil];
            }
            
            //创建表尾
            _tbAction.tableFooterView = [self createTableFooterView];
            _tbAction.contentOffset = CGPointMake(0, 0);
            [_tbAction reloadData];
            [_tbAction reloadData];
        }
        else
        {
            [self reportError:respData.errorDescrip];
        }
    }];
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView*)createTableFooterView
{
    if (!orderInfo.canvoid && !orderInfo.canrma) {
        return nil;
    }
    int height = 15;
    int xOffset = 49;
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    
    if (orderInfo.statust == 0 && ![DELIVERY_PAY_CODE isEqualToString:orderInfo.paymentcode]) {
        UIButton *btnOnlinePay = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOnlinePay.frame = CGRectMake(xOffset, height, 222, 40);
        [btnOnlinePay setTitle:@"在线支付" forState:UIControlStateNormal];
        [btnOnlinePay setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        [btnOnlinePay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnOnlinePay addTarget:self action:@selector(requestOnlinePay:) forControlEvents:UIControlEventTouchUpInside];
        btnOnlinePay.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:btnOnlinePay];
        height += 55;
    }
    
    if (orderInfo.canrma) {
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClean.frame = CGRectMake(xOffset, height, 222, 40);
        [btnClean setTitle:@"申请退货" forState:UIControlStateNormal];
        [btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        [btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClean addTarget:self action:@selector(requestRMA:) forControlEvents:UIControlEventTouchUpInside];
        btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:btnClean];
        height += 55;
    }
    
    /*
    if (orderInfo.rmas.count > 0) {
        FSOrderRMAItem *item = orderInfo.rmas[0];
        if ([item.statusCode isEqualToString:@"2"]) {   //1: 新创建 2：审核通过，可看邮寄地址 10：退货完成 -10：取消
            UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
            btnClean.frame = CGRectMake(xOffset, height, 222, 40);
            [btnClean setTitle:@"确认退货" forState:UIControlStateNormal];
            [btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
            [btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnClean addTarget:self action:@selector(commitRMA:) forControlEvents:UIControlEventTouchUpInside];
            btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [view addSubview:btnClean];
            height += 55;
        }
    }
     */
    
    if (orderInfo.canvoid) {
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClean.frame = CGRectMake(xOffset, height, 222, 40);
        [btnClean setTitle:@"取消订单" forState:UIControlStateNormal];
        [btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
        [btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnClean addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
        btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [view addSubview:btnClean];
        height += 55;
    }
    height += 10;
    
    view.frame = CGRectMake(0, 0, 320, height);
    return view;
}

-(void)requestOnlinePay:(id)sender
{
    if([ALI_PAY_CODE isEqualToString:orderInfo.paymentcode]){   //支付宝支付
        FSAppDelegate *del = (FSAppDelegate*)[UIApplication sharedApplication].delegate;
        FSOrderProduct *_prod = nil;
        if (orderInfo.products.count > 0) {
            _prod = orderInfo.products[0];
        }
        [del toAlipayWithOrder:orderInfo.orderno name:_prod?_prod.productname:orderInfo.orderno desc:_prod?_prod.productdesc:orderInfo.orderno amount:orderInfo.totalamount];
    }
    else if([WEIXIN_PAY_CODE isEqualToString:orderInfo.paymentcode]) { //微信支付
        WxpayOrder *wxpay = [[WxpayOrder alloc] init];
        wxpay.fromController = self;
        [wxpay sendPay:orderInfo.orderno];
    }
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [_dic setValue:orderInfo.orderno forKey:@"订单号"];
    [_dic setValue:orderInfo.paymentname forKey:@"支付方式"];
    [_dic setValue:@"订单详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:ORDER_PAY withParameters:_dic];
}

-(void)requestRMA:(UIButton*)sender
{
    FSOrderRMARequestViewController *controller = [[FSOrderRMARequestViewController alloc] initWithNibName:@"FSOrderRMARequestViewController" bundle:nil];
    controller.orderinfo = orderInfo;
    [self.navigationController pushViewController:controller animated:YES];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [_dic setValue:@"订单详情页" forKey:@"来源页面"];
    [_dic setValue:[NSString stringWithFormat:@"%@", orderInfo.orderno] forKey:@"订单号"];
    [[FSAnalysis instance] logEvent:CLICK_ORDER_RMA withParameters:_dic];
}

- (IBAction)commitRMA:(UIButton*)sender {
    FSOrderRMACommitViewController *controller = [[FSOrderRMACommitViewController alloc] initWithNibName:@"FSOrderRMACommitViewController" bundle:nil];
    controller.orderRMAItem = orderInfo.rmas[0];
    [self.navigationController pushViewController:controller animated:YES];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [_dic setValue:@"订单详情页" forKey:@"来源页面"];
    [_dic setValue:[NSString stringWithFormat:@"%@", orderInfo.orderno] forKey:@"订单号"];
    [[FSAnalysis instance] logEvent:CLICK_ORDER_RMA_CONFIRM withParameters:_dic];
}

#define Request_Cancel_Tag 200

-(void)cancelOrder:(UIButton*)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您确定要取消该订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = Request_Cancel_Tag;
    [alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!orderInfo) {
        return 0;
    }
    if (section == 1) {
        return orderInfo.products.count + 1;
    }
    else if(section == 3) {
        return orderInfo.rmas.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!orderInfo) {
        return 0;
    }
    if (orderInfo.rmas && orderInfo.rmas.count > 0) {
        return 4;
    }
    return 3;
}

#define OrderInfo_Address_Cell_Indentifier @"FSOrderInfoAddressCell"
#define OrderInfo_Message_Cell_Indentifier @"FSOrderInfoMessageCell"
#define OrderInfo_Amount_Cell_Indentifier @"FSOrderInfoAmount"
#define OrderInfo_Product_Cell_Indentifier @"FSOrderInfoProductCell"
#define Order_RMA_List_Cell_Indentifier @"FSOrderRMAListCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FSOrderInfoMessageCell *cell = (FSOrderInfoMessageCell*)[tableView dequeueReusableCellWithIdentifier:OrderInfo_Message_Cell_Indentifier];
        if (cell == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
            if (_array.count > 2) {
                cell = (FSOrderInfoMessageCell*)_array[2];
            }
            else{
                cell = [[FSOrderInfoMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderInfo_Message_Cell_Indentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setNeedsDisplay];
        }
        [cell setData:orderInfo];
        
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row < orderInfo.products.count) {
            FSOrderInfoProductCell *cell = (FSOrderInfoProductCell*)[tableView dequeueReusableCellWithIdentifier:OrderInfo_Product_Cell_Indentifier];
            if (cell == nil) {
                NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
                if (_array.count > 4) {
                    cell = (FSOrderInfoProductCell*)_array[4];
                }
                else{
                    cell = [[FSOrderInfoProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderInfo_Product_Cell_Indentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setData:orderInfo.products[indexPath.row]];
            
            return cell;
        }
        else {
            FSOrderInfoAmount *cell = (FSOrderInfoAmount*)[tableView dequeueReusableCellWithIdentifier:OrderInfo_Amount_Cell_Indentifier];
            if (cell == nil) {
                NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
                if (_array.count > 3) {
                    cell = (FSOrderInfoAmount*)_array[3];
                }
                else{
                    cell = [[FSOrderInfoAmount alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderInfo_Amount_Cell_Indentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setData:orderInfo];
            
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        FSOrderInfoAddressCell *cell = (FSOrderInfoAddressCell*)[tableView dequeueReusableCellWithIdentifier:OrderInfo_Address_Cell_Indentifier];
        if (cell == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSOrderListCell" owner:self options:nil];
            if (_array.count > 1) {
                cell = (FSOrderInfoAddressCell*)_array[1];
            }
            else{
                cell = [[FSOrderInfoAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderInfo_Address_Cell_Indentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:orderInfo];
        
        return cell;
    }
    else if (indexPath.section == 3) {
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
        [cell setData:orderInfo.rmas[indexPath.row]];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"订单信息";
            break;
        case 1:
            return @"商品清单";
            break;
        case 2:
            return @"收货信息";
            break;
        case 3:
            return @"退货信息";
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FSOrderInfoAddressCell *cell = (FSOrderInfoAddressCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.section == 1) {
        FSOrderInfoMessageCell *cell = (FSOrderInfoMessageCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            FSOrderInfoProductCell *cell = (FSOrderInfoProductCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }
        else if (indexPath.row == 1) {
            FSOrderInfoAmount *cell = (FSOrderInfoAmount*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
            return cell.cellHeight;
        }
    }
    else if(indexPath.section == 3) {
        FSOrderRMAListCell *cell = (FSOrderRMAListCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 40;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == Request_Cancel_Tag && buttonIndex == 1) {
        FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_ORDER_CANCEL;
        request.orderno = orderno;
        request.uToken = [[FSModelManager sharedModelManager] loginToken];
        [self beginLoading:self.view];
        [request send:[FSOrderInfo class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
            [self endLoading:self.view];
            if (respData.isSuccess)
            {
                orderInfo = respData.responseData;
                [self reportError:respData.message];
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0f];
            }
            else
            {
                [self reportError:respData.errorDescrip];
            }
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
            [_dic setValue:@"订单详情页" forKey:@"来源页面"];
            [_dic setValue:[NSString stringWithFormat:@"%@", orderInfo.orderno] forKey:@"订单号"];
            [_dic setValue:(respData.isSuccess?@"取消成功":@"取消失败") forKey:@"取消状态"];
            [[FSAnalysis instance] logEvent:ORDER_CANCEL withParameters:_dic];
        }];
    }
}

#pragma mark - FSOrderRMARequestViewControllerDelegate

-(void)refreshViewController:(UIViewController*)controller needRefresh:(BOOL)flag
{
    if (flag) {
        [self requestData];
    }
}

@end
