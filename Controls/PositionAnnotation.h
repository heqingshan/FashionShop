//
//  PositionAnnotation.h
//  MapTest
//
//  Created by zhangyicheng on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PositionAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D centerCoordinate;
    NSString *title;
    NSString *subTitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

- (id) initWithCoordinate:(CLLocationCoordinate2D)position title:(NSString *)_title subTitle:(NSString*)_subTitle;

@end
