//
//  UIViewController+Loading.h
//  FashionShop
//
//  Created by gong yi on 11/23/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UICallBackWith1Param)(id data);
typedef void (^UICallBackWith2Param)(id data,id data2);

typedef void (^FSProgressExecBlock) (dispatch_block_t);

@interface UIViewController(loading)

-(void) beginLoading:(UIView *)container;
-(void) endLoading:(UIView *)container;

-(void) showNoResult:(UIView *)container withText:(NSString *)text;
-(void) showNoResult:(UIView *)container withText:(NSString *)text originOffset:(CGFloat)height;
-(void) hideNoResult:(UIView *)container;

-(void) showNoResultImage:(UIView *)container withImage:(NSString *)imageName withText:(NSString *)text;
-(void) showNoResultImage:(UIView *)container withImage:(NSString *)imageName  withText:(NSString *)text originOffset:(CGFloat)height;
-(void) hideNoResultImage:(UIView *)container;

-(void) reportError:(NSString *)message;

-(void) startProgress:(NSString *)message withExeBlock:(FSProgressExecBlock)block completeCallbck:(dispatch_block_t)callback;

-(void) updateProgress:(NSString *) message ;
-(void) updateProgressThenEnd:(NSString *) message withDuration:(float)duration;

-(void) endProgress;

-(void) setTransition:(NSString *)direction toController:(UIViewController *)controller;

-(void) prepareEnterView:(UIView *)containner;

-(void) didEnterView:(UIView *)container;

-(UIBarButtonItem *)createPlainBarButtonItem:(NSString *)imageName target:(id)targ action:(SEL)action;

-(void)replaceBackItem;

-(void)decorateOverlayToCamera:(UIImagePickerController *)camera;
-(UIImagePickerController *)inUserCamera;
@end
