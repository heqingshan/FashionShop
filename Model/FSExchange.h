//
//  FSExchange.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-8.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSExchange : FSModelBase

@property (nonatomic) int id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSDate *createdDate;
@property (nonatomic,strong) NSDate *activeStartDate;
@property (nonatomic,strong) NSDate *activeEndDate;
@property (nonatomic,strong) NSDate *couponStartDate;
@property (nonatomic,strong) NSDate *couponEndDate;
@property (nonatomic,strong) NSString *notice;
@property (nonatomic) int minPoints;
@property (nonatomic) int unitPerPoints;
@property (nonatomic,strong) NSString *usageNotice;
@property (nonatomic,strong) NSString *inScopeNotice;
@property (nonatomic,strong) NSString *exchangeRuleMessage;
@property (nonatomic,strong) NSString *rule;
@property (nonatomic) float amount;

@property (nonatomic,strong) NSMutableArray *inscopenotices;
@property (nonatomic,strong) NSMutableArray *rules;

@end

@interface FSExchangeSuccess : FSModelBase

@property (nonatomic) int points;
@property (nonatomic) float amount;
@property (nonatomic) int storeProId;
@property (nonatomic,strong) NSString *giftCode;
@property (nonatomic,strong) NSString *exclude;
@property (nonatomic,strong) NSString *storeName;
@property (nonatomic,strong) NSDate *validEndDate;
@property (nonatomic,strong) NSDate *validStartDate;
@property (nonatomic,strong) NSDate *createDate;

@end


@interface FSPromotionItem : FSModelBase

@property (nonatomic,strong) NSDate *activeStartDate;
@property (nonatomic,strong) NSDate *activeEndDate;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSMutableArray *inscopenotices;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *notice;
@property (nonatomic,strong) NSString *usageNotice;

@end

@interface FSGiftListItem : FSModelBase

@property (nonatomic) int id;
@property (nonatomic,strong) NSString *giftCode;
@property (nonatomic,strong) NSDate *createDate;
@property (nonatomic,strong) NSString *exclude;
@property (nonatomic) int points;
@property (nonatomic) float amount;
@property (nonatomic) int status;
@property (nonatomic,strong) NSString *storeName;
@property (nonatomic,strong) NSDate *validEndDate;
@property (nonatomic,strong) NSDate *validStartDate;
@property (nonatomic,strong) FSPromotionItem *promotion;

@end
