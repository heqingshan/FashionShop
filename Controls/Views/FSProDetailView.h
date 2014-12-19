//
//  FSProDetailView.h
//  FashionShop
//
//  Created by gong yi on 12/4/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "SYPageView.h"
#import "FSDetailBaseView.h"
#import "FSProItemEntity.h"
#import "FSAudioButton.h"


@interface FSProDetailView : FSDetailBaseView {
    int _viewHeight;
}

@property (strong, nonatomic) IBOutlet UIScrollView *svContent;

@property (strong, nonatomic) IBOutlet UIView *imgNameView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UIView *titleDurationView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDuration;
@property (strong, nonatomic) IBOutlet UIButton *btnTag;

@property (strong, nonatomic) IBOutlet UIView *descAddView;
@property (strong, nonatomic) IBOutlet UILabel *lblFavorCount;
@property (strong, nonatomic) IBOutlet UILabel *lblCoupons;
@property (strong, nonatomic) IBOutlet UILabel *lblDescrip;
@property (strong, nonatomic) IBOutlet UIButton *btnStore;

@property (strong, nonatomic) IBOutlet UITableView *tbComment;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnFavor;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnComment;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCoupon;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixibleItem1;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixibleItem2;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixibleItem3;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *fixibleItem4;

@property (strong, nonatomic) NSString *imageURL;
@property (nonatomic,strong) FSAudioButton *audioButton;


@end
