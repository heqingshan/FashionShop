//
//  FSPLetterViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSThumView.h"
#import "FSRefreshableViewController.h"
#import "FSUser.h"

@interface FSPLetterViewController : FSRefreshableViewController<FSThumViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (nonatomic, strong) FSUser *touchUser;
@property (nonatomic) int lastConversationId;

@end
