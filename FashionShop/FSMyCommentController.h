//
//  FSMyCommentController.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSRefreshableViewController.h"
#import "FSThumView.h"
#import "FSProDetailViewController.h"
#import "FSAudioButton.h"
#import "AKSegmentedControl.h"

@interface FSMyCommentController : FSRefreshableViewController<FSThumViewDelegate,FSProDetailItemSourceProvider,FSAudioDelegate,AKSegmentedControlDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (strong, nonatomic) IBOutlet AKSegmentedControl *segHeader;
@property (nonatomic) int originalIndex;

-(void)stopAllAudio;

@end
