//
//  FSProdTagCell.h
//  FashionShop
//
//  Created by gong yi on 12/10/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVAlignLabel.h"
#import "FSTag.h"

@interface FSProdTagCell : PSUICollectionViewCell

@property (strong, nonatomic) FSVAlignLabel *lblTag;

@property(strong ,nonatomic) FSTag *data;
@end
