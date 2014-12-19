//
//  FSPurchaseProdCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-6-28.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPurchase.h"
#import "RTLabel.h"
#import "FSOrder.h"
#import "FSPropertiesSelectView.h"

@class FSPurchaseProdCell;
@protocol FSPurchaseProdCellDelegate<NSObject>
-(void)updateAmountInfo:(FSPurchaseProdCell*)cell count:(int)num;
@end

@interface FSPurchaseProdCell : UITableViewCell<FSPropertiesSelectViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productDesc;
@property (strong, nonatomic) IBOutlet UILabel *prodPrice;
@property (strong, nonatomic) IBOutlet UILabel *prodOriginalPrice;
@property (strong, nonatomic) IBOutlet UIImageView *lines;

@property (nonatomic) int cellHeight;
@property (nonatomic,strong) FSPurchase *data;
@property (nonatomic,strong) FSPurchaseForUpload *uploadData;

@property (nonatomic) id<FSPurchaseProdCellDelegate> delegate;

-(void)setData:(FSPurchase *)aData upLoadData:(FSPurchaseForUpload *)aUpData;

@end

@interface FSPurchaseCommonCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *contentLb;
@property (strong, nonatomic) IBOutlet UITextField *contentField;
@property (strong, nonatomic) IBOutlet UIImageView *lines;

@property (nonatomic) int cellHeight;

-(void)setControlWithData:(FSPurchaseForUpload*)data index:(int)aIndex;

@end

@interface FSPurchaseAmountCell : UITableViewCell
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

@property (nonatomic) int cellHeight;
@property (nonatomic,strong) FSPurchase *data;

@end

//标题、名称通用显示
@interface FSTitleContentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet RTLabel *title;
@property (strong, nonatomic) IBOutlet RTLabel *content;

@property (nonatomic) int cellHeight;

-(void)setDataWithTitle:(NSString *)aTtitle content:(NSString*)aContent;

@end

@interface FSOrderSuccessCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *orderAmount;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;

@property (nonatomic) int cellHeight;
@property (nonatomic,strong) FSOrderInfo *data;

@end
