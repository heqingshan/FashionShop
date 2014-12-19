//
//  FSProdDetailCell.h
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSProdItemEntity.h"
#import "UIImageView+WebCache.h"

@interface FSProdDetailCell : PSUICollectionViewCell<ImageContainerDownloadDelegate>
@property (strong, nonatomic) UIImageView *imgPic;

@property (strong, nonatomic) UIButton *btnPrice;
@property (strong, nonatomic) UIButton *btnPro;
@property (strong, nonatomic) UIButton *btnProBag;

@property(nonatomic,strong) FSProdItemEntity *data;

-(void) showProIcon;
-(void) hidenProIcon;
-(void) showProBag;
-(void) hidenProBag;
-(void)willRemoveFromView;
@end
