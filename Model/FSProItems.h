//
//  FSProItems.h
//  FashionShop
//
//  Created by gong yi on 11/22/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSProItems : FSModelBase


@property(nonatomic,assign) int currentPageIndex;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) int totalCount;
@property(nonatomic,assign) int totalPageCount;

@property(nonatomic,strong) NSMutableArray *items;

@end
