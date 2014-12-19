//
//  FSMeViewController.h
//  FashionShop
//
//  Created by gong yi on 11/8/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "RestKit.h"
#import "FSMoreViewController.h"
#import "FSProDetailViewController.h"
#import "FSFavorProCell.h"
#import "SpringboardLayout.h"
#import "FSRefreshableViewController.h"
#import "FSSegmentControl.h"
#import "AKSegmentedControl.h"
#import "FSQQConnectActivity.h"

typedef void (^FSLoginCompleteDelegate) (BOOL isSuccess);

@interface FSMeViewController : FSRefreshableViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate,PSUICollectionViewDataSource,FSMoreCompleteDelegate,SpringboardLayoutDelegate, UIGestureRecognizerDelegate,FSProDetailItemSourceProvider,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSThumViewDelegate,UINavigationControllerDelegate,FSQQConnectActivityDelegate,AKSegmentedControlDelegate>

@property (strong, nonatomic) IBOutlet FSThumView *thumbImg;
@property (strong, nonatomic) IBOutlet UIButton *btnHeaderBg;
@property (strong, nonatomic) IBOutlet UIImageView *btnHeaderImgV;
@property (strong, nonatomic) IBOutlet UIScrollView *tbScroll;

@property (strong, nonatomic) IBOutlet UIImageView *imgLevel;

@property (strong, nonatomic) IBOutlet UILabel *lblNickie;

@property (strong, nonatomic) IBOutlet UIButton *btnSuggest;
@property (strong, nonatomic) IBOutlet UIButton *btnLike;
@property (strong, nonatomic) IBOutlet UIButton *btnFans;
@property (strong, nonatomic) IBOutlet UIButton *btnPoints;
@property (strong, nonatomic) IBOutlet UIButton *btnCoupons;

@property (strong, nonatomic) IBOutlet AKSegmentedControl *segHeader;
@property (strong, nonatomic) IBOutlet UIView *likeContainer;

@property (strong, nonatomic) IBOutlet PSUICollectionView *likeView;
@property (strong,nonatomic) FSLoginCompleteDelegate completeCallBack;

- (IBAction)doLogin:(id)sender;
- (IBAction)doLoginQQWeiBo:(id)sender;
- (IBAction)doLoginQQ:(id)sender;
- (IBAction)attentionXHYT:(id)sender;

- (IBAction)doSuggest:(id)sender;
- (IBAction)doShowLikes:(id)sender;
- (IBAction)doShowFans:(id)sender;
- (IBAction)doShowPoints:(id)sender;
- (IBAction)doShowCoupons:(id)sender;

-(void)showDotIcon:(BOOL)flag;
-(void) displayUserLogin;


@end
