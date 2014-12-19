//
//  FSMoreViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"

enum FSMorePageStatus {
    FSMoreGift = 0,
    FSMoreOrder,
    FSMoreEdit = 10,
    FSMoreBindCard,
    FSMoreAddress,
    FSMoreFeedback = 20,
    FSMoreAbout,
    FSMoreCheckVersion,
    FSMoreLike,
    FSMoreClear,
    FSMoreOther,
};

@protocol FSMoreCompleteDelegate;

@interface FSMoreViewController : FSBaseViewController<UITableViewDataSource,UITableViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property(nonatomic,strong) FSUser *currentUser;
@property(nonatomic) id<FSMoreCompleteDelegate> delegate;

@end

@protocol FSMoreCompleteDelegate <NSObject>

-(void)settingView:(FSMoreViewController*)view didLogOut:(BOOL)flag;

@end
