//
//  FSCity.h
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"

@interface FSCity : NSObject

@property(nonatomic,assign) int id;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) float longit;
@property(nonatomic,assign) float lantit;

+ (RKObjectMapping *)mapAttributes;

@end
