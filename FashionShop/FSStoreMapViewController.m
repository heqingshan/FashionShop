//
//  FSStoreMapViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-2-7.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSStoreMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PositionAnnotation.h"

#define kMKCoordinateSpan 0.007

@interface FSStoreMapViewController ()
- (void)animateToPlace:(CLLocationCoordinate2D)place;
@end

@implementation FSStoreMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地图";
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    if (self.locationManager == nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.distanceFilter = kCLDistanceFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
    self.locationManager.delegate = self;
	//[self.locationManager startUpdatingLocation];
    
    CLLocationCoordinate2D center;
    center.latitude = [_store.lantit floatValue];
    center.longitude = [_store.longit floatValue];
    [self searchPositon:center title:_store.name subTitle:_store.descrip];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//设置标记
- (void)searchPositon:(CLLocationCoordinate2D)position title:(NSString *)aTitle subTitle:(NSString*)aSubTitle {
    _currentCoordinate = position;
    [self animateToPlace:_currentCoordinate];
    PositionAnnotation *annotation = [[PositionAnnotation alloc] initWithCoordinate:_currentCoordinate title:aTitle subTitle:nil];
//    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView addAnnotation:annotation];
}

//定位
- (void)animateToPlace:(CLLocationCoordinate2D)place
{
    MKCoordinateSpan span = {kMKCoordinateSpan, kMKCoordinateSpan};
    MKCoordinateRegion region = MKCoordinateRegionMake(place, span);
    
    [self.mapView setRegion:region animated:NO];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView;
    for (annotationView in views)
    {
        if ([annotationView isKindOfClass:[MKPinAnnotationView class]])
        {
            CGRect endFrame = annotationView.frame;
            annotationView.frame = CGRectMake(endFrame.origin.x, endFrame.origin.y - (APP_HIGH-44)/2, endFrame.size.width, endFrame.size.height);
            
            [UIView beginAnimations:@"drop" context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [annotationView setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    
    static NSString *defaultPinID = @"com.invasivecode.pin";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    if ( pinView == nil )
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.canShowCallout = YES;
    pinView.animatesDrop = YES;
    
    return pinView;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
    
//    [self searchPositon:newLocation.coordinate title:@"当前位置" subTitle:nil];
    
    //再定位当前位置
//    CLLocationCoordinate2D center;
//    center.latitude = [_store.lantit floatValue];
//    center.longitude = [_store.longit floatValue];
//    [self searchPositon:center title:_store.name subTitle:_store.descrip];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	
	[self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self.locationManager stopUpdatingLocation];
	self.locationManager.delegate = nil;
    [super viewDidUnload];
}

@end
