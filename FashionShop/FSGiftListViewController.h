//
//  FSMoreViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"

@interface FSGiftListViewController : FSBaseViewController<UITableViewDataSource,UITableViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (strong,nonatomic) FSUser *currentUser;

@end
