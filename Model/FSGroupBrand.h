//
//  FSGroupBrand.h
//  FashionShop
//
//  Created by HeQingshan on 13-2-8.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSGroupBrand : FSModelBase

@property (nonatomic, retain) NSString * groupName;
@property (nonatomic,retain) NSMutableArray * groupList;

@end

@interface FSGroupBrandList : FSModelBase

@property (nonatomic,retain) NSMutableArray * brandList;

+(NSArray *) allBrandsLocal;

@end
