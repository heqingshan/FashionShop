//
//  JsonInfoBase.h
//  Monogram
//
//  Created by Junyu Chen on 3/17/2012.
//  Copyright (c) 2012 Fara Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestKit.h"


@interface CommonHeader : NSObject

@property(nonatomic,strong,readonly) NSString	*uid;
@property(nonatomic,strong,readonly) NSString	*version;
@property(nonatomic,strong,readonly) NSString    *sign;

- (NSMutableDictionary *) toQueryDic;
@end
