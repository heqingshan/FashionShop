//
//  FSPostTableSelViewController.h
//  FashionShop
//
//  Created by gong yi on 12/13/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProPostMainViewController.h"

typedef id (^PostTableDataSource)();


@interface FSPostTableSelViewController : FSBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbContent;

-(void) setDataSource:(PostTableDataSource)source step:(PostProgressStep)current selectedCallbackTarget:(id)target;

@end


