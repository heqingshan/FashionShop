//
//  FSStoreDetailViewController.h
//  FashionShop
//
//  Created by gong yi on 1/4/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FSStore.h"
#import "FSRefreshableViewController.h"
#import "FSProDetailViewController.h"

@interface FSStoreDetailViewController : FSRefreshableViewController<UITableViewDataSource,UITableViewDelegate,FSProDetailItemSourceProvider>
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic) int storeID;
@property (strong, nonatomic) id pController;

@end
