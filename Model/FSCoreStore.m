//
//  FSStore.m
//  FashionShop
//
//  Created by gong yi on 11/15/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSCoreStore.h"
#import "RestKit.h"
#import "FSModelManager.h"

@implementation FSCoreStore

@dynamic address;
@dynamic descrip;
@dynamic distance;
@dynamic id;
@dynamic lantit;
@dynamic longit;
@dynamic name;
@dynamic phone;

+(RKObjectMapping *)getRelationDataMap:(Class)class withParentMap:(RKObjectMapping *)parentMap
{
    RKManagedObjectStore *objectStore = [FSModelManager sharedManager].objectStore;
    RKManagedObjectMapping *relationMapping = [RKManagedObjectMapping mappingForClass:[self class] inManagedObjectStore:objectStore];
    //relationMapping.primaryKeyAttribute = @"id";
    //[relationMapping mapKeyPathsToAttributes:@"id",@"id",@"name",@"name",@"location",@"address",@"tel",@"phone",@"lng",@"longit",@"lat",@"lantit",@"distance",@"distance",@"description",@"descrip",nil];
    
    relationMapping.primaryKeyAttribute = @"id";
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"name" toAttribute:@"name"];
    [relationMapping mapKeyPath:@"location" toAttribute:@"address"];
    [relationMapping mapKeyPath:@"tel" toAttribute:@"phone"];
    [relationMapping mapKeyPath:@"lng" toAttribute:@"longit"];
    [relationMapping mapKeyPath:@"lat" toAttribute:@"lantit"];
    [relationMapping mapKeyPath:@"distance" toAttribute:@"distance"];
    [relationMapping mapKeyPath:@"description" toAttribute:@"descrip"];
    
    return relationMapping;
}

+ (NSArray *) allStoresLocal
{
    NSArray *array = [self findAllSortedBy:@"id" ascending:TRUE];
    for (FSCoreStore *item in array) {
        [item show];
    }
    return array;
}

-(void)show
{
    NSLog(@"------------------------------------------------");
    NSLog(@"id:%d", self.id);
    NSLog(@"name:%@", self.name);
    NSLog(@"address:%@", self.address);
    NSLog(@"phone:%@", self.phone);
    NSLog(@"longit:%.2f", self.longit);
    NSLog(@"lantit:%.2f", self.lantit);
    NSLog(@"distance:%.2f", self.distance);
    NSLog(@"descrip:%@", self.descrip);
    NSLog(@"------------------------------------------------");
}

@end
