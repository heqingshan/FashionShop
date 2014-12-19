//
//  FSVAlignLabel.h
//  FashionShop
//
//  Created by gong yi on 12/27/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface FSVAlignLabel : UILabel
@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
