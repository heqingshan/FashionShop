//
//  FSCoreResource.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreModelBase.h"

@interface FSCoreResource : FSCoreModelBase

@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *relativePath;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int order;


@end
