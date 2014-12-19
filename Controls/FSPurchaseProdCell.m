//
//  FSPurchaseProdCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPurchaseProdCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+Extention.h"

@implementation FSPurchaseProdCell
@synthesize data,uploadData;

-(void)setData:(FSPurchase *)aData upLoadData:(FSPurchaseForUpload *)aUpData
{
    if (!aData) {
        return;
    }
    data = aData;
    uploadData = aUpData;
    int yGap = 10;
    _cellHeight = 10;
    
    BOOL flag =  NO;
    if (data.originprice && data.originprice > 0.000001) {
        flag = YES;
    }
    
    float pHeight = 80;
    //productImage
    if (aData.selectColorIndex < aData.saleColors.count) {
        FSPurchaseSaleColorsItem *item = aData.saleColors[aData.selectColorIndex];
        [_productImage setImageWithURL:[item.resource absoluteUrl120] placeholderImage:[UIImage imageNamed:@"default_icon120.png"]];
        _productImage.layer.borderWidth = 1;
        _productImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        float pWidth = _productImage.frame.size.width;
        pHeight = item.resource.height * pWidth / item.resource.width;
        if (isnan(pHeight)) {
            pHeight = 80;
        }
    }
    if (pHeight > 120) {
        pHeight = 120;
    }
    CGRect rect = _productImage.frame;
    rect.size.height = pHeight;
    _productImage.frame = rect;
    
    rect = _productName.frame;
    UIFont *font = [UIFont systemFontOfSize:14];
    
    //productName
    if (![NSString isNilOrEmpty:data.name]) {
        _productName.text = data.name;
        _productName.numberOfLines = 0;
        _productName.lineBreakMode = NSLineBreakByCharWrapping;
        _productName.textColor = [UIColor colorWithHexString:@"181818"];
        int height = [data.name sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
        rect.origin.y = _cellHeight;
        rect.size.height = height;
        _productName.frame = rect;
        _cellHeight += rect.size.height;
        _productName.hidden = NO;
    }
    else
        _productName.hidden = YES;
    
    //product brand
    if (![NSString isNilOrEmpty:data.brandName]) {
        rect = _productDesc.frame;
        _productDesc.text = data.brandName;
        _productDesc.numberOfLines = 0;
        _productDesc.lineBreakMode = NSLineBreakByTruncatingTail;
        _productDesc.textColor = [UIColor colorWithHexString:@"181818"];
        int height = [data.description sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
        if (height > 40) {
            height = 40;
        }
        rect.origin.y = _cellHeight;
        rect.size.height = height + 10;
        _productDesc.frame = rect;
        _cellHeight += rect.size.height;
        _productDesc.hidden = NO;
    }
    else {
        _productDesc.hidden = YES;
    }
    
    //prodPrice
    rect = _prodPrice.frame;
    _prodPrice.text = [NSString stringWithFormat:@"销售价：￥%.2f元", data.price];
    _prodPrice.textColor = [UIColor colorWithHexString:@"e5004f"];
    int height = [_prodPrice.text sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
    rect.origin.y = _cellHeight;
    rect.size.height = height;
    _prodPrice.frame = rect;
    _cellHeight += height + yGap;
    
    //prodOriginalPrice
    if (flag) {
        rect = _prodOriginalPrice.frame;
        _prodOriginalPrice.text = [NSString stringWithFormat:@"吊牌价：￥%.2f元", data.originprice];
        _prodOriginalPrice.textColor = [UIColor colorWithHexString:@"181818"];
        height = [_prodOriginalPrice.text sizeWithFont:font constrainedToSize:CGSizeMake(rect.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
        rect.origin.y = _cellHeight;
        rect.size.height = height;
        _prodOriginalPrice.frame = rect;
        _cellHeight += height + yGap;
    }
    else{
        _prodOriginalPrice.hidden = YES;
    }
    _cellHeight += 10;
    
    if (_cellHeight < pHeight + 20) {
        _cellHeight = pHeight + 20;
    }
    
    [self initProperties];
    
    //lines
    rect = _lines.frame;
    if (rect.origin.y < 0) {
        rect.origin.y = _cellHeight - 2;
    }
    _lines.frame = rect;
}

#define Properties_Color_Tag 900
#define Properties_Size_Tag 901
#define Properties_Count_Tag 902

-(void)initProperties
{
    if (data.saleColors.count == 0) {
        return;
    }
    FSPurchaseProductItem *pItem = uploadData.products[0];
    //添加颜色属性
    NSMutableArray *__array = [NSMutableArray array];
    for (int i = 0; i < data.saleColors.count; i++) {
        FSPurchaseSaleColorsItem *item = data.saleColors[i];
        FSKeyValueItem *sub = [[FSKeyValueItem alloc] init];
        sub.key = item.colorId;
        sub.value = item.colorName;
        [__array addObject:sub];
    }
    if ([self viewWithTag:Properties_Color_Tag]) {
        id item = [self viewWithTag:Properties_Color_Tag];
        [item removeFromSuperview];
    }
    FSPropertiesSelectView *view = [[FSPropertiesSelectView alloc] init];
    view.title = @"颜色";
    FSKeyValueItem *item = __array[data.selectColorIndex];
    view.selectedKey = item.key;
    view.showData = __array;
    view.delegate = self;
    view.tag = Properties_Color_Tag;
    
    [pItem.properties setValue:[NSNumber numberWithInt:item.key] forKey:@"colorvalueid"];
    [pItem.properties setValue:item.value forKey:@"colorvaluename"];
    
    int xOffset = 10;
    CGRect _rect = view.frame;
    _rect.origin.y = _cellHeight;
    _rect.origin.x = xOffset;
    view.frame = _rect;
    [self addSubview:view];
    xOffset += view.frame.size.width + 25;
    
    //添加尺码属性
    __array = [NSMutableArray array];
    NSArray *sizeArray = [data.saleColors[data.selectColorIndex] sizes];
    for (int i = 0; i < sizeArray.count; i++) {
        FSPurchaseSaleSizeItem *item = sizeArray[i];
        if (item.is4sale) {
            FSKeyValueItem *sub = [[FSKeyValueItem alloc] init];
            sub.key = item.sizeId;
            sub.value = item.sizeName;
            [__array addObject:sub];
        }
    }
    if ([self viewWithTag:Properties_Size_Tag]) {
        id item = [self viewWithTag:Properties_Size_Tag];
        [item removeFromSuperview];
    }
    view = [[FSPropertiesSelectView alloc] init];
    view.title = @"尺寸";
    if (data.selectSizeIndex >= 0 && data.selectSizeIndex < __array.count) {
        item = __array[data.selectSizeIndex];
        view.selectedKey = item.key;
        
        [pItem.properties setValue:[NSNumber numberWithInt:item.key] forKey:@"sizevalueid"];
        [pItem.properties setValue:item.value forKey:@"sizevaluename"];
    }
    else {
        view.selectedKey = -1;
        
        [pItem.properties setValue:nil forKey:@"sizevalueid"];
        [pItem.properties setValue:nil forKey:@"sizevaluename"];
    }
    view.showData = __array;
    view.delegate = self;
    view.tag = Properties_Size_Tag;
    
    if (xOffset + view.frame.size.width > 310) {
        _cellHeight += 45;
        xOffset = 10;
        CGRect _rect = view.frame;
        _rect.origin.y = _cellHeight;
        _rect.origin.x = xOffset;
        view.frame = _rect;
        [self addSubview:view];
    }
    else{
        CGRect _rect = view.frame;
        _rect.origin.y = _cellHeight;
        _rect.origin.x = xOffset;
        view.frame = _rect;
        [self addSubview:view];
        xOffset += view.frame.size.width + 25;
    }
    _cellHeight += 45;
    
    //添加数量选择
    __array = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        FSKeyValueItem *sub = [[FSKeyValueItem alloc] init];
        sub.key = i+1;
        sub.value = [NSString stringWithFormat:@"%d", i+1];
        [__array addObject:sub];
    }
    if ([self viewWithTag:Properties_Count_Tag]) {
        id item = [self viewWithTag:Properties_Count_Tag];
        [item removeFromSuperview];
    }
    view = [[FSPropertiesSelectView alloc] init];
    view.title = @"数量";
    item = __array[data.selectCountIndex];
    view.selectedKey = item.key;
    view.showData = __array;
    view.delegate = self;
    view.tag = Properties_Count_Tag;
    
    xOffset = 10;
    _rect = view.frame;
    _rect.origin.y = _cellHeight;
    _rect.origin.x = xOffset;
    view.frame = _rect;
    [self addSubview:view];
    
    _cellHeight += 45;
}

-(void)updataSizeControlData
{
    //更新图片
    int pHeight = 80;
    if (data.selectColorIndex < data.saleColors.count) {
        FSPurchaseSaleColorsItem *item = data.saleColors[data.selectColorIndex];
        [_productImage setImageWithURL:[item.resource absoluteUrl120] placeholderImage:[UIImage imageNamed:@"default_icon120.png"]];
        _productImage.layer.borderWidth = 1;
        _productImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        float pWidth = _productImage.frame.size.width;
        pHeight = item.resource.height * pWidth / item.resource.width;
        if (isnan(pHeight)) {
            pHeight = 80;
        }
    }
    if (pHeight > 120) {
        pHeight = 120;
    }
    if (pHeight <= 0) {
        pHeight = 80;
    }
    CGRect rect = _productImage.frame;
    rect.size.height = pHeight;
    _productImage.frame = rect;
    
    //更新尺码数据
    NSMutableArray *__array = [NSMutableArray array];
    NSArray *sizeArray = [data.saleColors[data.selectColorIndex] sizes];
    for (int i = 0; i < sizeArray.count; i++) {
        FSPurchaseSaleSizeItem *item = sizeArray[i];
        if (item.is4sale) {
            FSKeyValueItem *sub = [[FSKeyValueItem alloc] init];
            sub.key = item.sizeId;
            sub.value = item.sizeName;
            [__array addObject:sub];
        }
    }
    if ([self viewWithTag:Properties_Size_Tag]) {
        FSPropertiesSelectView* view = (FSPropertiesSelectView*)[self viewWithTag:Properties_Size_Tag];
        data.selectSizeIndex = -1;
        view.selectedKey = -1;
        CGRect rect = view.frame;
        view.showData = __array;
        view.frame = rect;
        
        //复位
        FSPurchaseProductItem *item = uploadData.products[0];
        [item.properties setValue:nil forKey:@"sizevalueid"];
        [item.properties setValue:nil forKey:@"sizevaluename"];
    }
}

-(void)didClickOkButton:(FSPropertiesSelectView*)controller
{
    if (uploadData.products.count == 0) {
        return;
    }
    FSPurchaseProductItem *item = uploadData.products[0];
    if (!item.properties) {
        item.properties = [NSMutableDictionary dictionary];
    }
    if (controller.tag == Properties_Color_Tag) {
        //选中颜色Ok按钮
        FSKeyValueItem *keyItem = controller.showData[controller.selectedIndex];
        [item.properties setValue:[NSNumber numberWithInt:keyItem.key] forKey:@"colorvalueid"];
        [item.properties setValue:keyItem.value forKey:@"colorvaluename"];
        data.selectColorIndex = controller.selectedIndex;
        
        //更新尺码内容
        [self updataSizeControlData];
    }
    else if(controller.tag == Properties_Size_Tag) {
        //选中尺码Ok按钮
        FSKeyValueItem *keyItem = controller.showData[controller.selectedIndex];
        [item.properties setValue:[NSNumber numberWithInt:keyItem.key] forKey:@"sizevalueid"];
        [item.properties setValue:keyItem.value forKey:@"sizevaluename"];
        data.selectSizeIndex = controller.selectedIndex;
    }
    else if(controller.tag == Properties_Count_Tag) {
        //选中数量Ok按钮
        FSKeyValueItem *keyItem = controller.showData[controller.selectedIndex];
        item.quantity = [keyItem.value intValue];
        data.selectCountIndex = controller.selectedIndex;
        
        //更新请求商品数量统计
        if (_delegate && [_delegate respondsToSelector:@selector(updateAmountInfo:count:)]) {
            [_delegate updateAmountInfo:self count:item.quantity];
        }
    }
}

@end

@implementation FSPurchaseCommonCell

-(void)setControlWithData:(FSPurchaseForUpload*)data index:(int)aIndex
{
    if (!data) {
        return;
    }
    _cellHeight = 40;
    switch (aIndex) {
        case 0://送货方式
        {
            _title.text = @"送货地址 : ";
            if (!data.address) {
                _contentLb.text = @"请选择送货地址";
                _contentLb.textColor = [UIColor lightGrayColor];
                CGRect rect = _contentLb.frame;
                rect.size.height = 40;
                _contentLb.frame = rect;
            }
            else{
                _contentLb.text = [NSString stringWithFormat:@"%@\n%@", data.address.shippingperson,data.address.displayaddress];
                int height = [_contentLb.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(_contentLb.frame.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
                CGRect rect = _contentLb.frame;
                rect.origin.y = 10;
                rect.size.height = height;
                _contentLb.frame = rect;
                _cellHeight = height + 20;
                _contentLb.textColor = [UIColor colorWithHexString:@"181818"];
            }
            _contentLb.numberOfLines = 0;
            _contentLb.lineBreakMode = NSLineBreakByCharWrapping;
            _contentField.hidden = YES;
            _contentLb.hidden = NO;
        }
            break;
        case 1://支付方式
        {
            _title.text = @"支付方式 : ";
            if (!data.payment) {
                _contentLb.text = @"请选择支付方式";
                _contentLb.textColor = [UIColor lightGrayColor];
                CGRect rect = _contentLb.frame;
                rect.size.height = 40;
                _contentLb.frame = rect;
            }
            else{
                _contentLb.text = data.payment.name;
                _contentLb.textColor = [UIColor colorWithHexString:@"181818"];
            }
            CGRect rect = _contentLb.frame;
            rect.size.height = 40;
            _contentLb.frame = rect;
            
            _contentField.hidden = YES;
            _contentLb.hidden = NO;
        }
            break;
        case 2://发票
        {
            /*
            _title.text = @"发票抬头 : ";
            if (![NSString isNilOrEmpty:data.invoicetitle]) {
                _contentField.text = data.invoicetitle;
            }
            _contentField.placeholder = @"点击填写发票抬头";
            _contentField.hidden = NO;
            _contentLb.hidden = YES;
             */
            
            _title.text = @"发票 : ";
            if ([NSString isNilOrEmpty:data.invoicetitle] && [NSString isNilOrEmpty:data.invoicedetail]) {
                _contentLb.text = @"点击填写发票信息";
                _contentLb.textColor = [UIColor lightGrayColor];
            }
            else{
                _contentLb.text = [NSString stringWithFormat:@"抬头:%@  备注:%@",(!data.isCompany?@"个人":data.invoicetitle), data.invoicedetail];
                _contentLb.textColor = [UIColor colorWithHexString:@"181818"];
                int height = [_contentLb.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(_contentLb.frame.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping].height;
                CGRect rect = _contentLb.frame;
                rect.origin.y = 10;
                rect.size.height = height;
                _contentLb.frame = rect;
                _cellHeight = height + 20;
            }
            _contentLb.numberOfLines = 0;
            _contentLb.lineBreakMode = NSLineBreakByCharWrapping;
            _contentField.hidden = YES;
            _contentLb.hidden = NO;
        }
            break;
        case 3://手机号码
        {
            _title.text = @"手机号码 : ";
            if (![NSString isNilOrEmpty:data.telephone]) {
                _contentField.text = data.telephone;
            }
            _contentField.placeholder = @"点击填写手机号码";
            _contentField.hidden = NO;
            _contentLb.hidden = YES;
        }
            break;
        case 4://订单备注
        {
            _title.text = @"订单备注 : ";
            if (![NSString isNilOrEmpty:data.memo]) {
                _contentField.text = data.memo;
            }
            _contentField.placeholder = @"点击填写订单备注信息";
            _contentField.hidden = NO;
            _contentLb.hidden = YES;
        }
            break;
        default:
            break;
    }
    
    //lines
    CGRect rect = _lines.frame;
    rect.origin.y = _cellHeight - 2;
    _lines.frame = rect;
    
    rect = _title.frame;
    rect.origin.y = _contentLb.frame.origin.y;
    rect.size.height = _contentLb.frame.size.height;
    _title.frame = rect;
}

@end

@implementation FSPurchaseAmountCell

-(void)setData:(FSPurchase*)data
{
    _data = data;
    _cellHeight = 5;
    
    [self initComponents:_totalQuantity another:_quantityLb content:[NSString stringWithFormat:@"%d件", data.totalquantity]];
    [self initComponents:_totalPoints another:_pointLb content:(data.totalpoints <= 0?nil:[NSString stringWithFormat:@"%d", data.totalpoints])];
    [self initComponents:_extendPrice another:_priceLb content:[NSString stringWithFormat:@"￥%.2f", data.extendprice]];
    [self initComponents:_totalFee another:_feeLb content:[NSString stringWithFormat:@"￥%.2f", data.totalfee]];
    [self initComponents:_totalAmount another:_amountLb content:[NSString stringWithFormat:@"￥%.2f", data.totalamount]];
    
    _cellHeight += 5;
    
    _bgImage.image = [[UIImage imageNamed:@"buy_amount_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    CGRect _rect = self.bounds;
    _rect.size.height = _cellHeight;
    _rect.size.width = 320;
    _bgImage.frame = _rect;
}

-(void)initComponents:(UILabel*)first another:(UILabel*)sec content:(NSString*)aContent
{
    if (!aContent) {
        first.hidden = YES;
        sec.hidden = YES;
        return;
    }
    first.hidden = NO;
    sec.hidden = NO;
    
    first.text = aContent;
    CGRect _rect = first.frame;
    _rect.origin.y = _cellHeight;
    first.frame = _rect;
    
    _rect = sec.frame;
    _rect.origin.y = _cellHeight;
    sec.frame = _rect;
    
    _cellHeight += _rect.size.height + 5;
}

-(void)changeFrame:(UILabel*)component
{
    component.hidden = NO;
    CGRect _rect = component.frame;
    _rect.origin.y -= 27;
    component.frame = _rect;
}

@end

@implementation FSTitleContentCell

-(void)setDataWithTitle:(NSString *)aTtitle content:(NSString*)aContent
{
    int yCap = 12;
    _cellHeight = yCap;
    
    //title
    NSString *str = [NSString stringWithFormat:@"<font face='%@' size=14 color='#666666'>%@</font>", Font_Name_Normal, aTtitle];
    [_title setText:str];
    CGRect _rect = _title.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = _title.optimumSize.height;
    _title.frame = _rect;
    _cellHeight += _rect.size.height + yCap - 6;
    
    str = [NSString stringWithFormat:@"<font face='%@' size=14 color='#666666'>%@</font>", Font_Name_Normal, aContent];
    [_content setText:str];
    _rect = _content.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = _content.optimumSize.height;
    _content.frame = _rect;
    _cellHeight += _rect.size.height + yCap;
}

@end

@implementation FSOrderSuccessCell

-(void)setData:(FSOrderInfo *)data
{
    _orderNumber.text = data.orderno;
    _orderNumber.hidden = NO;
    _orderAmount.text = [NSString stringWithFormat:@"￥%.2f", data.totalamount];
    _orderAmount.hidden = NO;
    [_buyButton setTitle:@"在 线 支 付" forState:UIControlStateNormal];
//    if (IOS7) {
//        [_buyButton setCenter:CGPointMake(SCREEN_WIDTH/2, _buyButton.center.y)];
//    }
}

@end
