//
//  FSThumView.h
//  FashionShop
//
//  Created by gong yi on 12/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"

@protocol FSThumViewDelegate <NSObject>

- (void)didTapThumView:(id)sender;

@end
@interface FSThumView : UIView

-(FSThumView *)initWithFrame:(CGRect)frame ownerUser:(FSUser *)user;
-(void) reloadThumb:(NSURL *)image;
-(void) setImage:(UIImage*)image;
-(UIImage*)getThumbImage;

@property(nonatomic,strong) FSUser *ownerUser;
@property(nonatomic,strong) id<FSThumViewDelegate> delegate;
@property(nonatomic) BOOL showCamera;

@end
