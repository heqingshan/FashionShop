//
//  FSLocationManager.m
//  FashionShop
//
//  Created by gong yi on 11/17/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSLocationManager.h"
#import <CoreLocation/CLGeocoder.h>

static FSLocationManager *_locationManager;

@interface FSLocationManager()
{
    
}
@end

@implementation FSLocationManager
@synthesize currentCoord=_currentCoord;

- (void) initLocationManager{
    // if location services are restricted do nothing
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
//        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
//    {
//        self.locationAwared = TRUE;
//        if (_locationDelegate)
//        {
//            
//            [_locationDelegate performSelector:@selector(didLocationFailAwared:) withObject:self];
//        }
//        return;
//    }
    
    // if locationManager does not currently exist, create it
    if (!_innerLocation)
    {
        _innerLocation = [[CLLocationManager alloc] init];
        [_innerLocation setDelegate:self];
        _innerLocation.distanceFilter = 10.0f;
    }
    
    [_innerLocation startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [_innerLocation stopUpdatingLocation];
    if (locations &&
        locations.count>0)
    {
        _currentCoord = [locations[0] coordinate];
    }
    self.locationAwared = TRUE;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
     [_innerLocation stopUpdatingLocation];
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        self.locationAwared = TRUE;
        return;
    }
    _currentCoord = [newLocation coordinate];
    self.locationAwared = TRUE;
   
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
    
    // stop updating
    [_innerLocation stopUpdatingLocation];

    
    // since we got an error, set selected location to invalid location
    _currentCoord = kCLLocationCoordinate2DInvalid;
    self.locationAwared = TRUE;
    id isShow = [[NSUserDefaults standardUserDefaults] objectForKey:@"NoShow"];
    if (!isShow || (isShow && [isShow boolValue])) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Open Location Desc", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:NSLocalizedString(@"No Show", nil), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"NoShow"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"NoShow"];
    }
}

+ (FSLocationManager *)sharedLocationManager{
    
    if (_locationManager == nil){
        @synchronized(self)
        {
            if(_locationManager==nil)
            {
                _locationManager = [[FSLocationManager alloc] init];
                [_locationManager initLocationManager];
                
            }
            
        }
       
    }
   
    return _locationManager;
}

+ (NSString *) computeDistanceToCurrentLocation:(CLLocationCoordinate2D)where{
    

    CLLocationDegrees latitude, longitude;
    
    latitude = [FSLocationManager sharedLocationManager].currentCoord.latitude;
    longitude = [FSLocationManager sharedLocationManager].currentCoord.longitude;
    CLLocation *to = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    latitude = where.latitude;
    longitude = where.longitude;
    CLLocation *from = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    CLLocationDistance distance = [to distanceFromLocation:from];
    return [NSString stringWithFormat:@"%.f米",distance];
    
}
@end
