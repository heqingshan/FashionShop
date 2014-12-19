//
//  FSCommon.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-10.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSCommon : FSModelBase

@property (nonatomic,strong) NSNumber* rangefrom;
@property (nonatomic,strong) NSNumber* rangeto;
@property (nonatomic,strong) NSNumber* ratio;

//积点兑换使用
@property (nonatomic, assign) NSInteger storeid;
@property (nonatomic, strong) NSString * storename;
@property (nonatomic,strong) NSString *excludes;//活动范围

//更新接口
@property (nonatomic, strong) NSString *downLoadURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic) int type;
@property (nonatomic, strong) NSString *startimage_iphone5;
@property (nonatomic, strong) NSString *startimage;
@property (nonatomic) int code;

@end

@interface FSEnMessageItem : FSModelBase

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *message;

@end

@interface FSEnRMAReasonItem : FSModelBase

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *reason;

@end

@interface FSCommonItem : FSModelBase

@property(nonatomic) int id;
@property(nonatomic,strong) NSString *name;

@end
