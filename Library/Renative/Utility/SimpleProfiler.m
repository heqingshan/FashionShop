//
//  TaskTiming.m
//  Monogram
//
//  Created by Junyu Chen on 5/23/12.
//  Copyright (c) 2012 Fara Inc. All rights reserved.
//

#import "SimpleProfiler.h"

@implementation SimpleProfiler
{
	NSDate *time;
    NSDate *total;
}

+(SimpleProfiler *)new
{
	SimpleProfiler *tt = [[SimpleProfiler alloc] init];
	
	[tt begin];
	
	return tt;
}

- (void)begin
{
	time = [NSDate date];
    total = [NSDate date];
}

- (void)usage:(NSString *)name
{
    DLog(@"[%@] USAGE: %f", name, [[NSDate date] timeIntervalSinceDate: time]);
    
    time = [NSDate date];
}

- (void)end
{
    DLog(@"TOTAL USAGE: %f", [[NSDate date] timeIntervalSinceDate: total]);    
}

@end
