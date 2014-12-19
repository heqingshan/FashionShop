//
//  FSBuyCenterViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSBuyCenterViewController.h"
#import "FSPurchaseRequest.h"
#import "FSPurchase.h"
#import "FSPurchaseProdCell.h"
#import "MyPhoto.h"
#import "MyPhotoSource.h"
#import "NSString+Extention.h"
#import "FSCommonTextShowViewController.h"
#import "FSPropertiesSelectView.h"
#import "JSONKit.h"
#import "FSOrderSuccessViewController.h"
#import "FSInvoiceViewController.h"

@interface FSBuyCenterViewController (){
    FSPurchase *_purchaseData;
    FSPurchase *_purchaseAmount;
    FSPurchaseForUpload *_uploadData;
    id activityField;
    FSMyPickerView *paywayPickerView;
    BOOL _buyInfoLoading;
    BOOL _amountLoading;
}

@end

@implementation FSBuyCenterViewController

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
    self.title = @"订购中心";
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self addRightButton:@"提交订单"];
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    _tbAction.separatorColor = [UIColor clearColor];
    _tbAction.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //加载数据
    [self requestBuyInfo];
    [self requestBuyAmount:1];
    [self registerNotification];
}

-(void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAmountData:) name:@"RequestAmountData" object:nil];
}

-(void)requestAmountData:(NSNotification*)notification
{
    NSNumber *number = (NSNumber*)notification.object;
    [self requestBuyAmount:[number integerValue]];
}

-(void)addRightButton:(NSString*)title
{
    UIImage *btnNormal = [[UIImage imageNamed:@"btn_big_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setTitle:title forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(submitProOrder:) forControlEvents:UIControlEventTouchUpInside];
    sheepButton.titleLabel.font = ME_FONT(13);
    sheepButton.showsTouchWhenHighlighted = YES;
    [sheepButton setBackgroundImage:btnNormal forState:UIControlStateNormal];
    [sheepButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)requestBuyInfo
{
    FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_PROD_BUY_INFO;
    //_productID = 487927;//487924;//977;
    request.id = [NSNumber numberWithInt:_productID];
    request.uToken = [[FSModelManager sharedModelManager] loginToken];
    if (!_amountLoading) {
        [self beginLoading:self.view];
    }
    _buyInfoLoading = YES;
    _tbAction.hidden = YES;
    [request send:[FSPurchase class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        if (!_amountLoading) {
            [self endLoading:self.view];
        }
        _buyInfoLoading = NO;
        if (respData.isSuccess)
        {
            _purchaseData = respData.responseData;
            _purchaseData.selectColorIndex = 0;
            _purchaseData.selectSizeIndex = -1;
            _purchaseData.selectCountIndex = 0;
            if (!_purchaseData) {
                [self reportError:@"数据更新中。。。"];
                [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:1.0];
            }
            else{
                [self initUploadData];
                [self initControl];
            }
        }
        else
        {
            [self reportError:respData.errorDescrip];
        }
    }];
}

-(void)requestBuyAmount:(int)amount
{
    FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_PROD_BUY_AMOUNT;
    request.id = [NSNumber numberWithInt:_productID];
    request.quantity = [NSNumber numberWithInt:amount];
    request.uToken = [[FSModelManager sharedModelManager] loginToken];
    if (!_buyInfoLoading) {
        [self beginLoading:self.view];
    }
    _amountLoading = YES;
    [request send:[FSPurchase class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        if (!_buyInfoLoading) {
            [self endLoading:self.view];
        }
        _amountLoading = NO;
        if (respData.isSuccess)
        {
            _purchaseAmount = respData.responseData;
            [_tbAction reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
        else
        {
            [self reportError:respData.errorDescrip];
        }
    }];
}

-(void)initControl
{
    _tbAction.tableFooterView = [self createTableFooterView];
    _tbAction.hidden = NO;
    [_tbAction reloadData];
}

-(void)initUploadData
{
    _uploadData = [[FSPurchaseForUpload alloc] init];
    //此处只会有一件商品，所以直接可赋值
    //先初始化商品数组
    FSPurchaseProductItem *__product = [[FSPurchaseProductItem alloc] init];
    __product.productid = _productID;
    __product.quantity = 1;
    _uploadData.isCompany = YES;
    
    //添加数量
    if (!__product.properties) {
        __product.properties = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    _uploadData.products = [[NSMutableArray alloc] initWithObjects:__product, nil];
    
    //如果服务器只传递一个支付方式，则默认选中
    if (_purchaseData.supportpayments.count == 1) {
        _uploadData.payment = _purchaseData.supportpayments[0];
    }
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [theApp cleanAllPickerView];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [theApp hiddenPickerView];
}

-(UIView*)createTableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    view.backgroundColor = [UIColor clearColor];
    
    int xOffset = 49;
    int yOffset = 20;
    
    UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClean.frame = CGRectMake(xOffset, yOffset, 222, 40);
    [btnClean setTitle:NSLocalizedString(@"Submit Pre Order", nil) forState:UIControlStateNormal];
    [btnClean setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [btnClean setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClean addTarget:self action:@selector(submitProOrder:) forControlEvents:UIControlEventTouchUpInside];
    btnClean.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [view addSubview:btnClean];
    yOffset += 40 + 10;
    
    NSString *value = [theApp messageForKey:EM_O_C_HELP];
    if (value) {
        RTLabel *desc = [[RTLabel alloc] initWithFrame:CGRectMake(15, yOffset, 290, 20)];
        NSString *str = [NSString stringWithFormat:@"<font face='%@' size=13 color='#666666'>%@</font>", Font_Name_Normal, value];
        [desc setText:str];
        CGRect _rect = desc.frame;
        _rect.origin.y = yOffset;
        _rect.size.height = desc.optimumSize.height;
        desc.frame = _rect;
        yOffset += _rect.size.height + 15;
        [view addSubview:desc];
    }
    
    CGRect _rect = view.frame;
    _rect.size.height = yOffset;
    view.frame = _rect;

    return view;
}

-(UIView*)createSectionHeader:(NSString*)aTitle
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    view.backgroundColor = [UIColor clearColor];
    view.image = [UIImage imageNamed:@"list_title_bg.png"];
    
    UILabel *text = [[UILabel alloc] initWithFrame:view.bounds];
    text.text = [NSString stringWithFormat:@"  %@",aTitle];
    text.textColor = [UIColor colorWithHexString:@"6f5e6c"];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:text];
    return view;
}

-(void)submitProOrder:(UIButton*)sender
{
    NSString *error = nil;
    if ([self check:&error]) {
        //订单预览
        NSMutableString *msg = [NSMutableString stringWithString:@""];
        FSPurchaseProductItem *__p = _uploadData.products[0];
        [msg appendFormat:@"商品名称 : %@\n", _purchaseData.name];
        [msg appendFormat:@"商品单价 : ￥%.2f\n", _purchaseData.price];
        [msg appendFormat:@"颜色：%@\n", [__p.properties objectForKey:@"colorvaluename"]];
        [msg appendFormat:@"尺码：%@\n", [__p.properties objectForKey:@"sizevaluename"]];
        [msg appendFormat:@"购买数量 : %d\n", __p.quantity];
        [msg appendFormat:@"送货地址 : %@\n", _uploadData.address.displayaddress];
        [msg appendFormat:@"支付方式 : %@\n", _uploadData.payment.name];
        BOOL flag = [NSString isNilOrEmpty:_uploadData.invoicedetail];
        [msg appendFormat:@"是否需要发票 : %@\n", flag?@"否":@"是"];
        if (!flag) {
            [msg appendFormat:@"发票抬头 : %@\n", (_uploadData.isCompany?_uploadData.invoicetitle:@"个人")];
            [msg appendFormat:@"发票备注 : %@\n", _uploadData.invoicedetail];
        }
        if (![NSString isNilOrEmpty:_uploadData.memo]) {
            [msg appendFormat:@"订单备注 : %@\n", _uploadData.memo];
        }
        [msg appendFormat:@"手机号码 : %@\n", _uploadData.telephone];
        [msg appendFormat:@"金额总计 : ￥%.2f\n", _purchaseAmount.extendprice];
        [msg appendFormat:@"运费 : ￥%.2f\n", _purchaseAmount.totalfee];
        [msg appendFormat:@"共需支付 : ￥%.2f\n", _purchaseAmount.totalamount];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        alert.tag = 101;
        //左对齐
        for(UIView *subview in alert.subviews)
        {
            if([[subview class] isSubclassOfClass:[UILabel class]])
            {
                UILabel *label = (UILabel*)subview;
                if([label.text isEqualToString:msg])
                    label.textAlignment = UITextAlignmentLeft;
            }
        }
        [alert show];
    }
    else{
        [self reportError:error];
    }
}

-(BOOL)check:(NSString **)error
{
    if (_uploadData.products.count <= 0) {
        *error = @"当前商品信息有误：商品数量为0";
        return NO;
    }
    FSPurchaseProductItem *__product = _uploadData.products[0];
    if (![__product.properties objectForKey:@"colorvalueid"]) {
        *error = @"请选择颜色";
        return NO;
    }
    NSNumber *nNum = [__product.properties objectForKey:@"sizevalueid"];
    if (!nNum || [nNum intValue] < 0) {
        *error = @"请选择尺码";
        return NO;
    }
    if (!_uploadData.address) {
        *error = @"请选择送货地址";
        return NO;
    }
    if (!_uploadData.payment) {
        *error = @"请选择支付方式";
        return NO;
    }
    if ([NSString isNilOrEmpty:_uploadData.telephone]) {
        *error = @"请留下您的联系方式";
        return NO;
    }
    return YES;
}

-(NSString*)getOrderData
{
    if (_uploadData.products.count <= 0) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *__ps = [NSMutableArray array];
    
    for (FSPurchaseProductItem *__p in _uploadData.products) {
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        [dic1 setValue:[NSNumber numberWithInt:__p.productid] forKey:@"productid"];
        [dic1 setValue:_purchaseData.name forKey:@"desc"];
        [dic1 setValue:[NSNumber numberWithInt:__p.quantity] forKey:@"quantity"];
        
        [dic1 setValue:__p.properties forKey:@"properties"];
        
        [__ps addObject:dic1];
    }
    [dic setValue:__ps forKey:@"products"];
    
    BOOL flag = [NSString isNilOrEmpty:_uploadData.invoicedetail];
    [dic setValue:[NSNumber numberWithBool:!flag] forKey:@"needinvoice"];
    [dic setValue:(_uploadData.isCompany?_uploadData.invoicetitle:@"个人") forKey:@"invoicetitle"];
    [dic setValue:_uploadData.invoicedetail forKey:@"invoicedetail"];
    [dic setValue:_uploadData.memo forKey:@"memo"];
    
    NSMutableDictionary *addressDic = [NSMutableDictionary dictionary];
    [addressDic setValue:_uploadData.address.shippingperson forKey:@"shippingcontactperson"];
    [addressDic setValue:_uploadData.address.shippingphone forKey:@"shippingcontactphone"];
    [addressDic setValue:_uploadData.address.shippingzipcode forKey:@"shippingzipcode"];
    [addressDic setValue:_uploadData.address.displayaddress forKey:@"shippingaddress"];
    [dic setValue:addressDic forKey:@"shippingaddress"];
    
    NSMutableDictionary *paymentDic = [NSMutableDictionary dictionary];
    [paymentDic setValue:_uploadData.payment.code forKey:@"paymentcode"];
    [paymentDic setValue:_uploadData.payment.name forKey:@"paymentname"];
    [dic setValue:paymentDic forKey:@"payment"];
    
    return [dic JSONString];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_purchaseData.sizeImage) {
            return 3;
        }
        return 2;
    }
    else if(section == 1) {
        return 5;
    }
    else{
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#define Purchase_Product_Info_Indentifier @"FSPurchaseProdCell"
#define Purchase_Common_Info_Indentifier @"FSPurchaseCommonCell"
#define Purchase_Amount_Info_Indentifier @"FSPurchaseAmountCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            FSPurchaseProdCell *cell = (FSPurchaseProdCell*)[tableView dequeueReusableCellWithIdentifier:Purchase_Product_Info_Indentifier];
            if (cell == nil) {
                NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPurchaseProdCell" owner:self options:nil];
                if (_array.count > 0) {
                    cell = (FSPurchaseProdCell*)_array[0];
                }
                else{
                    cell = [[FSPurchaseProdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Purchase_Product_Info_Indentifier];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            [cell setData:_purchaseData upLoadData:_uploadData];
            
            return cell;
        }
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell02"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 38, 300, 2)];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        line.image = [UIImage imageNamed:@"line_s.png"];
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        int index = 1;
        if (_purchaseData.sizeImage) {
            cell.textLabel.text = @"查看尺码对照表";
            index = 2;
        }
        if (indexPath.row == index) {
            cell.textLabel.text = @"退货政策";
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        FSPurchaseCommonCell *cell = (FSPurchaseCommonCell*)[tableView dequeueReusableCellWithIdentifier:Purchase_Common_Info_Indentifier];
        if (cell == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPurchaseProdCell" owner:self options:nil];
            if (_array.count > 1) {
                cell = (FSPurchaseCommonCell*)_array[1];
            }
            else{
                cell = [[FSPurchaseCommonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Purchase_Common_Info_Indentifier];
            }
            cell.contentField.delegate = self;
        }
        if (indexPath.row <= 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setControlWithData:_uploadData index:indexPath.row];
        
        return cell;
    }
    
    else if(indexPath.section == 2) {
        FSPurchaseAmountCell *cell = (FSPurchaseAmountCell*)[tableView dequeueReusableCellWithIdentifier:Purchase_Amount_Info_Indentifier];
        if (cell == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSPurchaseProdCell" owner:self options:nil];
            if (_array.count > 2) {
                cell = (FSPurchaseAmountCell*)_array[2];
            }
            else{
                cell = [[FSPurchaseAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Purchase_Amount_Info_Indentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setData:_purchaseAmount];
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [activityField resignFirstResponder];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return;
        }
        if (_purchaseData.sizeImage) {
            if (indexPath.row == 1) {
                //尺码对照表
                NSMutableArray *photoArray=[NSMutableArray arrayWithCapacity:1];
                MyPhoto *photo = [[MyPhoto alloc] initWithImageURL:[_purchaseData.sizeImage absoluteUrl320] name:nil];
                [photoArray addObject:photo];
                MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photoArray];
                EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
                int width = 100;
                photoController.beginRect = CGRectMake((APP_WIDTH-width)/2, (APP_HIGH-width)/2, width, width);
                photoController.source = self;
                //[self presentModalViewController:photoController animated:YES];
                [self presentViewController:photoController animated:YES completion:nil];
                return;
            }
        }
        //信誉保证
        FSCommonTextShowViewController *controller = [[FSCommonTextShowViewController alloc] initWithNibName:@"FSCommonTextShowViewController" bundle:nil];
        controller.myTitle = @"退货政策";
        controller.purchase = _purchaseData;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //选择地址
            FSAddressManagerViewController *addressView = [[FSAddressManagerViewController alloc] initWithNibName:@"FSAddressManagerViewController" bundle:nil];
            addressView.pageFrom = 2;
            addressView.selAddressId = _uploadData.address.id;
            addressView.delegate = self;
            [self.navigationController pushViewController:addressView animated:true];
        }
        else if(indexPath.row == 1) {
            //支付方式
            if (!paywayPickerView) {
                paywayPickerView = [[FSMyPickerView alloc] init];
                paywayPickerView.delegate = self;
                paywayPickerView.datasource = self;
            }
            //初始化选中项
            for (int i = 0; i < _purchaseData.supportpayments.count; i++) {
                FSPurchaseSPaymentItem *item = _purchaseData.supportpayments[i];
                if ([item.code isEqualToString:_uploadData.payment.code]) {
                    [paywayPickerView.picker selectRow:i inComponent:0 animated:NO];
                    break;
                }
            }
            [paywayPickerView showPickerView:^{
                [activityField resignFirstResponder];
            }];
        }
        else if(indexPath.row == 2) {
            FSInvoiceViewController *invoiceView = [[FSInvoiceViewController alloc] initWithNibName:@"FSInvoiceViewController" bundle:nil];
            invoiceView.data = _purchaseData;
            invoiceView.uploadData = _uploadData;
            invoiceView.delegate = self;
            [self.navigationController pushViewController:invoiceView animated:true];
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        FSPurchaseProdCell *cell = (FSPurchaseProdCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.section == 1) {
        FSPurchaseCommonCell *cell = (FSPurchaseCommonCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else if (indexPath.section == 2) {
        FSPurchaseAmountCell *cell = (FSPurchaseAmountCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = section==0?@"商品信息":(section==1?@"订单信息":@"订单小计");
    return [self createSectionHeader:title];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101 && buttonIndex == 1) {
        FSPurchaseRequest *request = [[FSPurchaseRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_PROD_ORDER;
        request.order = [self getOrderData];
        request.uToken = [FSModelManager sharedModelManager].loginToken;
        [self beginLoading:self.view];
        self.view.userInteractionEnabled = NO;
        [request send:[FSOrderInfo class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
            [self endLoading:self.view];
            self.view.userInteractionEnabled = YES;
            if (respData.isSuccess)
            {
                [self reportError:respData.message];
                //跳转成功界面
                FSOrderInfo *sucData = (FSOrderInfo*)respData.responseData;
                [self performSelector:@selector(gotoSuccessPage:) withObject:sucData afterDelay:1.0];
            }
            else
            {
                [self reportError:respData.errorDescrip];
            }
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:5];
            [_dic setValue:_purchaseData.name forKey:@"商品名称"];
            [_dic setValue:[NSString stringWithFormat:@"%.2f", _purchaseData.price] forKey:@"商品单价"];
            [_dic setValue:_uploadData.address.displayaddress forKey:@"送货地址"];
            [_dic setValue:_uploadData.payment.name forKey:@"支付方式"];
            [_dic setValue:[NSString stringWithFormat:@"%.2f", _purchaseData.totalamount] forKey:@"共需支付"];
            [[FSAnalysis instance] logEvent:PRODUCT_BUY withParameters:_dic];
        }];
    }
}

-(void)gotoSuccessPage:(FSOrderInfo*)info
{
    FSOrderSuccessViewController *controller = [[FSOrderSuccessViewController alloc] initWithNibName:@"FSOrderSuccessViewController" bundle:nil];
    controller.data = info;
    controller.title = @"订单创建成功";
    controller.payWay = _uploadData.payment;
    [self.navigationController pushViewController:controller animated:YES];
    
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [_dic setValue:info.orderno forKey:@"订单编号"];
    [[FSAnalysis instance] logEvent:BUY_SUCCESS_PAGE withParameters:_dic];
}

#pragma mark - FSImageSlide datasource

-(int)numberOfImagesInSlides:(EGOPhotoViewController *)view
{
    return 1;
}

-(NSURL *)imageSlide:(EGOPhotoViewController *)view imageNameForIndex:(int)index
{
    return [_purchaseData.sizeImage absoluteUrlOrigin];
}

#pragma mark - FSAddressManagerViewControllerDelegate

-(void)addressManagerViewControllerSetSelected:(FSAddressManagerViewController*)viewController
{
    _uploadData.address = viewController.selectedAddress;
    _uploadData.telephone = _uploadData.address.shippingphone;
    [_tbAction reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - FSInvoiceViewControllerDelegate

-(void)completeInvoiceInput:(FSInvoiceViewController*)viewController
{
    _uploadData.invoicetitle = viewController.companyName.text;
    _uploadData.invoicedetail = viewController.invoiceDetail.text;
    [_tbAction reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activityField = textField;
    [paywayPickerView hidenPickerView:YES action:nil];
    FSPurchaseCommonCell *cell = (FSPurchaseCommonCell*)textField.superview.superview;
    [_tbAction scrollToRowAtIndexPath:[_tbAction indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [NSString logControl:_tbAction];
    FSPurchaseCommonCell *cell;
//    if (!IOS7) {
//        cell = (FSPurchaseCommonCell*)textField.superview.superview;
//    }
//    else
    {
        cell = (FSPurchaseCommonCell*)textField.superview.superview.superview;
    }
    NSIndexPath *path = [_tbAction indexPathForCell:cell];
    if (path.row == 2) {
        _uploadData.invoicetitle = textField.text;
    }
    else if (path.row == 4) {
        _uploadData.memo = textField.text;
    }
    else if (path.row == 3) {
        _uploadData.telephone = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    FSPurchaseCommonCell *cell = (FSPurchaseCommonCell*)textField.superview.superview;
    NSIndexPath *path = [_tbAction indexPathForCell:cell];
    if (path.row == 2) {
        _uploadData.invoicetitle = textField.text;
    }
    else if (path.row == 3) {
        _uploadData.memo = textField.text;
    }
    else if (path.row == 4) {
        _uploadData.telephone = textField.text;
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - FSMyPickerViewDatasource

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView
{
    if (pickerView == paywayPickerView) {
        return 1;
    }
    return 0;
}

- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == paywayPickerView) {
        return _purchaseData.supportpayments.count;
    }
    return 0;
}

#pragma mark - FSMyPickerViewDelegate

- (void)didClickOkButton:(FSMyPickerView *)aMyPickerView
{
    if (aMyPickerView == paywayPickerView) {
        int index = [aMyPickerView.picker selectedRowInComponent:0];
        if (index < _purchaseData.supportpayments.count) {
            FSPurchaseSPaymentItem *aItem = _purchaseData.supportpayments[index];
            _uploadData.payment = aItem;
            [_tbAction reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (NSString *)myPickerView:(FSMyPickerView *)aMyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    FSPurchaseSPaymentItem *item = _purchaseData.supportpayments[row];
    return item.name;
}

#pragma mark - FSPurchaseProdCellDelegate
-(void)updateAmountInfo:(FSPurchaseProdCell*)cell count:(int)num
{
    [self requestBuyAmount:num];
}

@end
