//
//  FSBothItems.h
//  FashionShop
//
//  Created by gong yi on 11/24/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSBothItems : FSModelBase


@property(nonatomic,assign) int currentPageIndex;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) int totalCount;
@property(nonatomic,assign) int totalPageCount;

@property(nonatomic,strong) NSMutableArray *proItems;
@property(nonatomic,strong) NSMutableArray *prodItems;
@end
