//
//  FSStoreMapViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-2-7.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FSStore.h"

@interface FSStoreMapViewController : FSBaseViewController<MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) FSStore *store;

@end
