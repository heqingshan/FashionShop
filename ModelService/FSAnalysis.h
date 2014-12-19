//
//  FSAnalysis.h
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#define PRO_LIST_NEAR_PV @"Promotion Near PV"
#define PRO_LIST_NEW_PV @"Promotion New PV"
#define PRO_DETAIL_PV @"Promotion Detail PV"
#define PROD_DETAIL_PV @"Product Detail PV"
#define PROD_LIST_PV @"Product List PV"

@interface FSAnalysis : NSObject

-(void) start;

+(FSAnalysis *)instance;

-(void) logError:(NSException *)exception fromWhere:(NSString *)category;

- (void) logEvent:(NSString *) 	eventName
   withParameters:(NSDictionary *) parameters;

-(void) autoTrackPages:(UIViewController *)rootConroller;
-(void) autoTrackPage;

-(void) setLocation:(CLLocation*)location;
-(void) setUserID:(NSString*)userID;

@end
