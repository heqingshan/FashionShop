//
//  FSCoreModelBase.h
//  FashionShop
//
//  Created by gong yi on 11/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FSModelBase.h"

@interface FSCoreModelBase : NSManagedObject<FSManagedModelMappable>

@property(nonatomic,assign) BOOL isSuccess;
@property(nonatomic,strong) NSString *errorDescrip;
@property(nonatomic,assign) FSNetworkErrorType errorType;

@end
