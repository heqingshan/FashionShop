//
//  FSTopicRequest.h
//  FashionShop
//
//  Created by HeQingshan on 13-1-31.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSEntityRequestBase.h"

#define RK_REQUEST_TOPIC_LIST @"/specialtopic/list"

@interface FSTopicRequest : FSEntityRequestBase

@property(nonatomic,assign) int nextPage;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) FSProSortType filterType;
@property(nonatomic,strong) NSDate * previousLatestDate;

@end
