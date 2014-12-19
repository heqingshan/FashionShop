//
//  FSTopic.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-31.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSResource.h"

@interface FSTopic : FSModelBase

@property (nonatomic,strong) NSDate *createdDate;
@property (nonatomic,strong) NSDate *updatedDate;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *name;
@property (nonatomic) BOOL isFavorited;
@property (nonatomic) int topicId;
@property (nonatomic,strong) NSString* targetId;
@property (nonatomic) NSNumber* targetType;
@property (nonatomic,strong) NSMutableArray *resources;

@end
