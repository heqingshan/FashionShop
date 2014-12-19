//
//  FSAudioShowView.h
//  FashionShop
//
//  Created by HeQingshan on 13-4-6.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSAudioShowView : UIView

-(void)updateAudioLabelFrame:(double)aRate;

-(void)showAudioView;
-(void)showTrashView;
-(void)showAudioViewInUpload;

@end
