//
//  PositionAnnotation.m
//  MapTest
//
//  Created by zhangyicheng on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PositionAnnotation.h"

@implementation PositionAnnotation

@synthesize centerCoordinate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)position title:(NSString *)_title subTitle:(NSString*)_subTitle{
    self = [super init];
    if (self != nil) {
        centerCoordinate.latitude = position.latitude;
        centerCoordinate.longitude = position.longitude;
        title = _title;
        subTitle = _subTitle;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    return centerCoordinate; 
}

- (NSString *)title
{
    return title;
}

- (NSString *)subtitle
{
    return subTitle;
}

@end
