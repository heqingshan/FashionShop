//
//  FSStore.h
//  FashionShop
//
//  Created by gong yi on 12/5/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSResource.h"

@interface FSStore : FSModelBase
@property (nonatomic, assign) NSInteger  id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic,strong) NSString * descrip;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * longit;
@property (nonatomic, strong) NSString * lantit;
@property (nonatomic, strong) NSString * address;
@property(nonatomic,assign) double distance;
@property (nonatomic,strong) NSMutableArray *resource;
@property (nonatomic,strong) FSResource *logoBg;
@property (nonatomic, strong) NSURL *storeLogoBg;

@end
