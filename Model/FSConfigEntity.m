//
//  FSConfigEntity.m
//  FashionShop
//
//  Created by gong yi on 11/20/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSConfigEntity.h"

@implementation FSConfigEntity

@synthesize supportCities;


- (void)setMappingAttribute:(RKObjectMapping *)map
{
     //   [self setMappingForCommonHeader:map];
        RKObjectMapping * cityMap = [FSCity mapAttributes];
        [map mapKeyPath:@"data.cities" toRelationship:@"supportCities" withMapping:cityMap];

}

@end
