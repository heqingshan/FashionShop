//
//  FSTag.h
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSTag : FSModelBase
@property(nonatomic) int id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic) int sortorder;
@property(nonatomic,strong) NSString *description;

-(void)logTags;

//+(NSArray *)localTags;

@end
