//
//  FSModelBase.h
//  FashionShop
//
//  Created by gong yi on 11/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"
#import "FSEntityBase.h"

@protocol FSModelMappable <NSObject>

+  (NSString *) relationKeyPath;

+ (RKObjectMapping *) getRelationDataMap;

+ (RKObjectMapping *) getRelationDataMap:(BOOL)isCollection;

@end

@protocol FSManagedModelMappable <FSModelMappable>

+ (RKObjectMapping *) getRelationDataMap:(Class)aClass withParentMap:(RKObjectMapping *)parentMap;

@end

@interface FSModelBase : FSEntityBase<FSModelMappable>


@end

