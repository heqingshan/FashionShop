//
//  FSBrand.h
//  FashionShop
//
//  Created by gong yi on 12/5/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSBrand : FSModelBase

@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic,retain) NSString * descrip;
@property (nonatomic,retain) NSString * logo;
@property (nonatomic,retain) NSString * homeSite;

+(NSArray *) allBrandsLocal;

@end
