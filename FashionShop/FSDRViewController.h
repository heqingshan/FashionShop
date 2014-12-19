//
//  FSDRViewController.h
//  FashionShop
//
//  Created by gong yi on 12/21/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpringboardLayout.h"
#import "FSRefreshableViewController.h"
#import "FSProDetailViewController.h"
#import "FSThumView.h"
#import "AKSegmentedControl.h"
#import "FSAvatarHDViewController.h"

@interface FSDRViewController : FSRefreshableViewController<PSUICollectionViewDataSource,PSUICollectionViewDelegateFlowLayout,SpringboardLayoutDelegate,FSProDetailItemSourceProvider,FSThumViewDelegate,FSAvatarHDViewDelegate,AKSegmentedControlDelegate>

- (IBAction)goLikeView:(id)sender;
- (IBAction)goFanView:(id)sender;
- (IBAction)contact:(id)sender;

@property (strong, nonatomic) IBOutlet FSThumView *thumLogo;
@property (strong, nonatomic) IBOutlet UILabel *lblNickie;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIButton *touchButn;

@property (strong, nonatomic) IBOutlet UIButton *btnFans;
@property (strong, nonatomic) IBOutlet PSUICollectionView *itemsView;
@property (strong, nonatomic) IBOutlet UIView *itemsContainer;
@property (strong, nonatomic) IBOutlet AKSegmentedControl *segHeader;

@property (nonatomic) int userId;
@end
