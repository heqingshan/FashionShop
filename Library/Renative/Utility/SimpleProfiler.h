//
//  TaskTiming.h
//  Monogram
//
//  Created by Junyu Chen on 5/23/12.
//  Copyright (c) 2012 Fara Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleProfiler : NSObject

+(SimpleProfiler *)new;
-(void)begin;
-(void)end;
-(void)usage:(NSString *)name;
@end


/*
 
*/