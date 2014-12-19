//
//  FSImageCollectionCell.h
//  FashionShop
//
//  Created by gong yi on 1/2/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"
@interface FSImageCollectionCell : PSUICollectionViewCell
@property (strong, nonatomic) UIButton *btnRemove;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnSizeSel;

@end
