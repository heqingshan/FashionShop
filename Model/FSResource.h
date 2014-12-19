//
//  FSResource.h
//  FashionShop
//
//  Created by gong yi on 11/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"

@interface FSResource : FSModelBase


@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *relativePath;
@property (nonatomic,assign) int height;
@property (nonatomic,assign) int width;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) int order;

@property (nonatomic,readonly) NSURL *absoluteUrl;
@property (nonatomic,readonly) NSURL *absoluteUrl120;
@property (nonatomic,readonly) NSURL *absoluteUrl320;
@property (nonatomic,readonly) NSURL *absoluteUrlOrigin;

-(NSURL *)absoluteUr:(int)width;
-(NSURL *)absoluteUr:(int)_width height:(int)_height;

@end
