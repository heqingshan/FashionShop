//
//  FSCardInfo.h
//  FashionShop
//
//  Created by HeQingshan on 13-3-11.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSCardInfo : FSModelBase

@property(nonatomic) int id;
@property (nonatomic,strong) NSString *cardNo;//会员卡卡号
@property (nonatomic,strong) NSString *cardLevel;//普卡、金卡、铂金卡
@property (nonatomic,strong) NSNumber *amount;//积点数
@property (nonatomic,strong) NSString *type;//卡类型，字符串形式
@property (nonatomic,strong) NSDate *lastDate;//上次更新时间

@end
