//
//  FSStore.h
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCoreModelBase.h"
#import <CoreData/CoreData.h>

@interface FSCoreStore:FSCoreModelBase

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic) double distance;
@property (nonatomic) int32_t id;
@property (nonatomic) float lantit;
@property (nonatomic) float longit;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;

+ (NSArray *) allStoresLocal;
-(void)show;

@end
