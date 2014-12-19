//
//  FSResource.m
//  FashionShop
//
//  Created by gong yi on 11/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSResource.h"

@implementation FSResource

@synthesize domain;
@synthesize relativePath;
@synthesize height;
@synthesize width;
@synthesize type;
@synthesize order;
@synthesize absoluteUrl,absoluteUrl120,absoluteUrl320,absoluteUrlOrigin;


+ (RKObjectMapping *)getRelationDataMap
{
    RKObjectMapping *relationMap = [RKObjectMapping mappingForClass:[self class]];
    [relationMap mapKeyPathsToAttributes:@"domain",@"domain",@"name",@"relativePath",@"height",@"height",@"width",@"width",@"order",@"order",@"type",@"type",nil];
    return relationMap;
}


-(NSURL *)absoluteUrl
{
    return self.absoluteUrl120;
}
-(NSURL *)absoluteUrlOrigin
{
    if (relativePath && domain)
    {
        NSString *relative = [NSString stringWithFormat:@"%@_original.jpeg",relativePath];
        
        return [NSURL URLWithString:relative relativeToURL:[NSURL URLWithString:self.domain]];
    }
    else
        return nil;
}

-(NSURL *)absoluteUrl120
{
    return [self absoluteUr:120];
}

-(NSURL *)absoluteUrl320
{
    return [self absoluteUr:320];
}

-(NSURL *)absoluteUr:(int)_width
{
    if (relativePath && domain)
    {
        NSString *relative = [self composeRelativeFromWidth:(_width*RetinaFactor)];
        
        return [NSURL URLWithString:relative relativeToURL:[NSURL URLWithString:self.domain]];
    }
    else
        return nil;
}

-(NSURL *)absoluteUr:(int)_width height:(int)_height
{
    if (relativePath && domain)
    {
        NSString *relative = [self composeRelativeFromWidth:(_width*RetinaFactor) height:(_height*RetinaFactor)];
        
        return [NSURL URLWithString:relative relativeToURL:[NSURL URLWithString:self.domain]];
    }
    else
        return nil;
}

-(NSString *) composeRelativeFromWidth:(int)inWid
{
    return  [NSString stringWithFormat:@"%@_%dx0.jpg",self.relativePath,inWid];
}

-(NSString *) composeRelativeFromWidth:(int)inWid height:(int)inHeight
{
    return  [NSString stringWithFormat:@"%@_%dx%d.jpg",self.relativePath,inWid,inHeight];
}

@end
