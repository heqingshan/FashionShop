//
//  FSOrderListCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-22.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSOrder.h"

@interface FSOrderListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgPro;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *crateDate;

@property (strong,nonatomic) FSOrderInfo *data;

@end

@interface FSOrderInfoAddressCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *telephone;

@property (strong,nonatomic) FSOrderInfo *data;
@property (nonatomic) int cellHeight;

@end

@interface FSOrderInfoMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *orderno;
@property (strong, nonatomic) IBOutlet UILabel *orderstatus;
@property (strong, nonatomic) IBOutlet UILabel *sendway;
@property (strong, nonatomic) IBOutlet UILabel *payway;
@property (strong, nonatomic) IBOutlet UILabel *createtime;
@property (strong, nonatomic) IBOutlet UILabel *needinvoice;
@property (strong, nonatomic) IBOutlet UILabel *invoicetitle;
@property (strong, nonatomic) IBOutlet UILabel *invoicedetail;
@property (strong, nonatomic) IBOutlet UILabel *ordermemo;

@property (strong,nonatomic) FSOrderInfo *data;
@property (nonatomic) int cellHeight;

@end

@interface FSOrderInfoAmount : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) IBOutlet UILabel *quantityLb;
@property (strong, nonatomic) IBOutlet UILabel *pointLb;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UILabel *feeLb;
@property (strong, nonatomic) IBOutlet UILabel *amountLb;

@property (strong, nonatomic) IBOutlet UILabel *totalQuantity;
@property (strong, nonatomic) IBOutlet UILabel *totalPoints;
@property (strong, nonatomic) IBOutlet UILabel *extendPrice;
@property (strong, nonatomic) IBOutlet UILabel *totalFee;
@property (strong, nonatomic) IBOutlet UILabel *totalAmount;

@property (strong,nonatomic) FSOrderInfo *data;
@property (nonatomic) int cellHeight;

@end

@interface FSOrderInfoProductCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productProperties;
@property (strong, nonatomic) IBOutlet UILabel *prodPriceAndCount;

@property (strong,nonatomic) FSOrderProduct *data;
@property (nonatomic) int cellHeight;

@end

@interface FSOrderRMAListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *rmano;
@property (strong, nonatomic) IBOutlet UILabel *rmaReason;
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UILabel *bankCard;
@property (strong, nonatomic) IBOutlet UILabel *bankAccount;
@property (strong, nonatomic) IBOutlet UILabel *rmaType;
@property (strong, nonatomic) IBOutlet UILabel *chargePostFee;
@property (strong, nonatomic) IBOutlet UILabel *chargegiftFee;
@property (strong, nonatomic) IBOutlet UILabel *rebatePostFee;
@property (strong, nonatomic) IBOutlet UILabel *rmaAmount;
@property (strong, nonatomic) IBOutlet UILabel *actualAmount;
@property (strong, nonatomic) IBOutlet UILabel *rejectReason;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *mailAddress;


@property (nonatomic,strong) FSOrderRMAItem* data;
@property (nonatomic) int cellHeight;

@end
