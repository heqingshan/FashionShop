//
//  FSProdDetailView.h
//  FashionShop
//
//  Created by gong yi on 12/14/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "SYPageView.h"
#import "FSDetailBaseView.h"
#import "FSProdItemEntity.h"
#import "FSThumView.h"
#import "FSAudioButton.h"
#import "RTLabel.h"

@interface FSProdDetailView : FSDetailBaseView {
    int _viewHeight;
}

@property (strong, nonatomic) IBOutlet UIScrollView *svContent;

@property (strong, nonatomic) IBOutlet UIView *imgNameView;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet FSThumView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *price1;
@property (strong, nonatomic) IBOutlet UILabel *priceOriginal;
@property (strong, nonatomic) IBOutlet UILabel *lblNickie;
@property (strong, nonatomic) IBOutlet UIButton *btnBrand;

@property (strong, nonatomic) IBOutlet UIView *descAddView;
@property (strong, nonatomic) IBOutlet UIView *countView;
@property (strong, nonatomic) IBOutlet UIImageView *imgLikeBG;
@property (strong, nonatomic) IBOutlet UILabel *lblFavorCount;
@property (strong, nonatomic) IBOutlet UILabel *lblCoupons;
@property (strong, nonatomic) IBOutlet UIButton *btnContact;
@property (strong, nonatomic) IBOutlet UIButton *btnBuy;
@property (strong, nonatomic) IBOutlet UILabel *lblDescrip;
@property (strong, nonatomic) IBOutlet UIButton *btnStore;
@property (strong, nonatomic) IBOutlet UIButton *btnToDail;

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
@property (nonatomic) BOOL isCanTalk;

@end
