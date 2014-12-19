//
//  FSTag.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSTag.h"

@implementation FSTag

@synthesize   id;
@synthesize name;
@synthesize sortorder;
@synthesize description;

+(RKObjectMapping *) getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPathsToAttributes:@"id",@"id",@"name",@"name",@"description",@"description",@"sortorder",@"sortorder",nil];

    return relationMapping;
}

-(void)logTags
{
    NSLog(@"id:%d,name:%@,description:%@", id,name,description);
}

/*
+(NSArray *) localTags
{
    return [FSTag findAllSortedBy:@"sortorder" ascending:NO];
}
 */
@end
