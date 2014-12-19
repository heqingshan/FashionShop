//
//  FSMessageViewController.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-10.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesViewController.h"
#import "FSUser.h"
#import "FSThumView.h"

@interface FSMessageViewController : MessagesViewController<FSThumViewDelegate>

@property (nonatomic, strong) FSUser *touchUser;
@property (nonatomic) int lastConversationId;
@property (nonatomic, strong) NSString *preSendMsg;

@end
