//
//  FSPagedModel.h
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSPagedModel : FSModelBase

@property(nonatomic,assign) int currentPageIndex;
@property(nonatomic,assign) int pageSize;
@property(nonatomic,assign) int totalCount;
@property(nonatomic,assign) int totalPageCount;
@property(nonatomic,assign) BOOL isPaged;

@property(nonatomic,strong) NSMutableArray *items;

+(NSString *)pagedKeyPath;

+(Class) pagedModel;

@end
