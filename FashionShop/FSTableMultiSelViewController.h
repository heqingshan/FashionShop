//
//  FSTableMultiSelViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-3.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProPostMainViewController.h"

typedef id (^PostTableDataSource)();

@interface FSTableMultiSelViewController : FSBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tbAction;

-(void) setDataSource:(PostTableDataSource)source step:(PostProgressStep)current selectedCallbackTarget:(id)target;

@end
