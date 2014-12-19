//
//  FSAnalysis.m
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSAnalysis.h"
#import "Flurry.h"
#import "FSConfiguration.h"

static FSAnalysis *_instance;
@implementation FSAnalysis

-(id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

-(void) start
{
    [Flurry startSession:FLURRY_APP_KEY];
}


-(void) logError:(NSException *)exception fromWhere:(NSString *)category
{
    [Flurry logError:category message:exception.description exception:exception];
}

- (void) logEvent:(NSString *) 	eventName
          withParameters:(NSDictionary *) parameters
{
    if (parameters) {
        [Flurry logEvent:eventName withParameters:parameters];
    }
    else{
        [Flurry logEvent:eventName];
    }
}

-(void) autoTrackPages:(UIViewController *)rootConroller
{
    [Flurry logAllPageViews:rootConroller];
}

-(void) autoTrackPage
{
    [Flurry logPageView];
}

-(void) setLocation:(CLLocation*)location
{
    [Flurry setLatitude:location.coordinate.latitude longitude:location.coordinate.longitude horizontalAccuracy:location.horizontalAccuracy verticalAccuracy:location.verticalAccuracy];
}

-(void) setUserID:(NSString*)userID
{
    [Flurry setUserID:userID];
}

+(FSAnalysis *) instance
{
    if (!_instance)
    {
        _instance = [[FSAnalysis alloc] init];
    }
    return _instance;
}

@end
