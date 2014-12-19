//
//  UIViewController+Loading.m
//  FashionShop
//
//  Created by gong yi on 11/23/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "MBProgressHUD.h"
#import "FSConfiguration.h"
#import "FSOverlayView.h"

#define UIVIEWCONTROLLER_CAT_LOADING_ID 10000
#define UIVIEWCONTROLLER_CAT_REPORT_ID 10001
#define UIVIEWCONTROLLER_CAT_PROGRESS_ID 10002
#define UIVIEWCONTROLLER_CAT_ENTER_VIEW 10003
#define UIVIEWCONTROLLER_NO_RESULT_ID 10004
#define UIVIEWCONTROLLER_NO_RESULT_ImageID 10005

BOOL networkIsWorking = NO;

@implementation UIViewController(loading)

-(void) prepareEnterView:(UIView *)container
{
    if (!container)
        container = self.view;
    UIView *emptyView = (UIView *)[container viewWithTag:UIVIEWCONTROLLER_CAT_ENTER_VIEW];
    if (!emptyView)
    {
        /*
        emptyView = [[UIView alloc] initWithFrame:container.frame];
        emptyView.backgroundColor = [UIColor whiteColor];
        UIImageView *loadMoreView =(UIImageView *)[container viewWithTag:UIVIEWCONTROLLER_CAT_ENTER_VIEW];
        if(!loadMoreView)
        {
            loadMoreView= [[UIImageView alloc] initWithFrame:CGRectMake(container.frame.size.width/2-20,container.frame.origin.y+50, 40, 40)];
        }
        [emptyView addSubview:loadMoreView];
        [loadMoreView.layer removeAllAnimations];
        loadMoreView.image = [UIImage imageNamed:@"refresh-spinner-dark"];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/180, 0, 0, 1.0)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1.0)];
        animation.duration = .4;
        animation.cumulative =YES;
        animation.repeatCount = 2000;
        [loadMoreView.layer addAnimation:animation forKey:@"animation"];
        [loadMoreView startAnimating];

        emptyView.tag = UIVIEWCONTROLLER_CAT_ENTER_VIEW;
         */
        emptyView = [[UIView alloc] initWithFrame:CGRectMake(container.frame.size.width/2-40,container.frame.origin.y+80, 80, 80)];
        emptyView.backgroundColor = [UIColor clearColor];
        emptyView.tag = UIVIEWCONTROLLER_CAT_ENTER_VIEW;
        UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
        inView.backgroundColor = [UIColor blackColor];
        inView.layer.cornerRadius = 10;
        inView.layer.borderWidth = 0;
        inView.alpha = 0.7;
        [emptyView addSubview:inView];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.frame = CGRectMake((inView.frame.size.width-inView.frame.size.width)/2, (inView.frame.size.height-inView.frame.size.height)/2, inView.frame.size.width, inView.frame.size.height);
        [emptyView addSubview:indicatorView];
        [indicatorView startAnimating];
    }
    [container addSubview:emptyView];
    [container bringSubviewToFront:emptyView];

}

-(void) didEnterView:(UIView *)container
{
    if (!container)
        container = self.view;
    UIView *emptyView =(UIView *)[container viewWithTag:UIVIEWCONTROLLER_CAT_ENTER_VIEW];
    if (emptyView)
    {
//        if (emptyView.subviews.count>0)
//        {
//            UIImageView *loadMoreView =(UIImageView *)emptyView.subviews[0];
//            if (loadMoreView)
//            {
//                [loadMoreView.layer removeAllAnimations];
//                loadMoreView.image = nil;
//                [loadMoreView removeFromSuperview];
//            }
//        }
        [emptyView removeFromSuperview];
    }
}

-(void) beginLoading:(UIView *)container
{
    networkIsWorking = YES;
    if (!container)
        container = self.view;
    
    //UIView *superView = container.superview;
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(container.frame.size.width/2-40,container.frame.origin.y+80, 80, 80)];
    //view.center = CGPointMake(superView.frame.size.width/2, superView.frame.size.height/2 - superView.frame.size.height/6);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
    view.center = CGPointMake(container.frame.size.width/2, container.frame.size.height/2 - container.frame.size.height/6);
    view.backgroundColor = [UIColor clearColor];
    view.tag = UIVIEWCONTROLLER_CAT_LOADING_ID;
    UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 80, 80)];
    inView.backgroundColor = [UIColor blackColor];
    inView.layer.cornerRadius = 10;
    inView.layer.borderWidth = 0;
    inView.alpha = 0.7;
    [view addSubview:inView];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = CGRectMake((view.frame.size.width-indicatorView.frame.size.width)/2, (view.frame.size.height-indicatorView.frame.size.height)/2, indicatorView.frame.size.width, indicatorView.frame.size.height);
    [view addSubview:indicatorView];
    [indicatorView startAnimating];
    [container addSubview:view];
}

-(void) endLoading:(UIView *)container
{
    networkIsWorking = NO;
    if (!container)
        container = self.view;
    
    UIView *view = [container viewWithTag:UIVIEWCONTROLLER_CAT_LOADING_ID];
    [view removeFromSuperview];
}

-(void) showNoResult:(UIView *)container withText:(NSString *)text
{
    [self showNoResult:container withText:text originOffset:0];
}

-(void) showNoResult:(UIView *)container withText:(NSString *)text originOffset:(CGFloat)height
{
    if (!container)
        container = self.view;
    UILabel *noResult = (UILabel *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ID];
    if(!noResult)
    {
        noResult = [[UILabel alloc] init];
        noResult.text = text;
        noResult.font = ME_FONT(12);
        noResult.backgroundColor = [UIColor clearColor];
        CGSize resultSize = [noResult.text sizeWithFont:ME_FONT(12)];
        noResult.frame = CGRectMake(self.view.frame.size.width/2-resultSize.width/2,self.view.frame.origin.y+height+10, resultSize.width, resultSize.height);
        noResult.tag = UIVIEWCONTROLLER_NO_RESULT_ID;
    }
    [container addSubview:noResult];
    [container bringSubviewToFront:noResult];

}
-(void) hideNoResult:(UIView *)container
{
    if (!container)
        container = self.view;
    UILabel *noResult =(UILabel *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ID];
    if (noResult)
    {
        [noResult removeFromSuperview];
    }
    
}

//列表为空时显示图片

-(void) showNoResultImage:(UIView *)container withImage:(NSString *)imageName  withText:(NSString *)text
{
    [self showNoResultImage:container withImage:imageName  withText:(NSString *)text originOffset:0];
}
-(void) showNoResultImage:(UIView *)container withImage:(NSString *)imageName  withText:(NSString *)text originOffset:(CGFloat)_height
{
    if (!container)
        container = self.view;
    int height = _height + ([UIDevice isRunningOniPhone5]?44:0);
    UIImageView *blankView =(UIImageView *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ImageID];
    if(!blankView)
    {
        UIImage *blankImage = [UIImage imageNamed:imageName];
        blankView = [[UIImageView alloc] initWithImage:blankImage];
        blankView.frame = CGRectMake(self.view.frame.size.width/2-blankImage.size.width/2,self.view.frame.origin.y+height+10, blankImage.size.width, blankImage.size.height);
        blankView.tag = UIVIEWCONTROLLER_NO_RESULT_ImageID;
    }
    else{
        UIImage *blankImage = [UIImage imageNamed:imageName];
        blankView.image = blankImage;
    }
    if(text)
    {
        UILabel *noResult =(UILabel *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ID];
        if(!noResult)
        {
            noResult = [[UILabel alloc] init];
            noResult.text = text;
            noResult.numberOfLines = 0;
            noResult.lineBreakMode = NSLineBreakByCharWrapping;
            noResult.textAlignment = UITextAlignmentCenter;
            noResult.font = ME_FONT(14);
            CGSize resultSize = [noResult.text sizeWithFont:noResult.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            noResult.frame = CGRectMake(10,blankView.frame.origin.y+blankView.frame.size.height+20, 300, resultSize.height);
            noResult.tag = UIVIEWCONTROLLER_NO_RESULT_ID;
            noResult.backgroundColor = [UIColor clearColor];
        }
        else{
            noResult.text = text;
            noResult.textAlignment = UITextAlignmentCenter;
            CGSize resultSize = [noResult.text sizeWithFont:noResult.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByCharWrapping];
            noResult.frame = CGRectMake(10,blankView.frame.origin.y+blankView.frame.size.height+20, 300, resultSize.height);
            noResult.text = text;
        }
        
        [container addSubview:noResult];
        [container bringSubviewToFront:noResult];
    }
    [container addSubview:blankView];
    [container bringSubviewToFront:blankView];
    
}
-(void) hideNoResultImage:(UIView *)container
{
    if (!container)
        container = self.view;
    UIImageView *blankView =(UIImageView *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ImageID];
    if (blankView)
    {
        [blankView removeFromSuperview];
    }
    UILabel *noResult =(UILabel *)[container viewWithTag:UIVIEWCONTROLLER_NO_RESULT_ID];
    if (noResult)
    {
        [noResult removeFromSuperview];
    }
}

-(void) reportError:(NSString *)message
{
    MBProgressHUD * statusReport =(MBProgressHUD *)[self.view viewWithTag:UIVIEWCONTROLLER_CAT_REPORT_ID];
    if(!statusReport)
    {
        statusReport = [[MBProgressHUD alloc] initWithView:self.view];
        statusReport.dimBackground = true;
        statusReport.mode = MBProgressHUDModeText;
    }
    [self.view addSubview:statusReport];
    statusReport.detailsLabelText = message;
    [statusReport show:true];
    float timeLong = 2.5;
    if (message.length > 15) {
        timeLong += message.length/10;
    }
    [statusReport performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:timeLong];

}


-(void) startProgress:(NSString *)message withExeBlock:(FSProgressExecBlock)block completeCallbck:(dispatch_block_t)callback
{
    MBProgressHUD * statusReport =(MBProgressHUD *)[self.view viewWithTag:UIVIEWCONTROLLER_CAT_PROGRESS_ID];
    if(!statusReport)
    {
        statusReport = [[MBProgressHUD alloc] initWithView:self.view];
        statusReport.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
        statusReport.tag = UIVIEWCONTROLLER_CAT_PROGRESS_ID;
    }
    [self.view addSubview:statusReport];
    statusReport.detailsLabelText = message;
    [statusReport show:true];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        block(callback);
    });
    

}

-(void) updateProgress:(NSString *) message 
{
    MBProgressHUD * statusReport =(MBProgressHUD *)[self.view viewWithTag:UIVIEWCONTROLLER_CAT_PROGRESS_ID];

    statusReport.detailsLabelText = message;
   
}
-(void) updateProgressThenEnd:(NSString *) message withDuration:(float)duration
{
    MBProgressHUD * statusReport =(MBProgressHUD *)[self.view viewWithTag:UIVIEWCONTROLLER_CAT_PROGRESS_ID];
    
    statusReport.detailsLabelText = message;
    [statusReport performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:duration];
    
}

-(void) endProgress
{
    MBProgressHUD * statusReport =(MBProgressHUD *)[self.view viewWithTag:UIVIEWCONTROLLER_CAT_PROGRESS_ID];
    if (!statusReport)
        return;
    [statusReport performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}


-(void) setTransition:(NSString *)direction toController:(UIViewController *)controller
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    
    animation.delegate = controller;
    animation.removedOnCompletion = YES;
    
    animation.type = kCATransitionFade;
    
    animation.subtype = direction;
    
    [controller.view.layer addAnimation:animation forKey:nil];
}


-(UIBarButtonItem *)createPlainBarButtonItem:(NSString *)imageName target:(id)targ action:(SEL)action
{
    UIImage *sheepImage = [UIImage imageNamed:imageName];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setImage:sheepImage forState:UIControlStateNormal];
    [sheepButton addTarget:targ action:action forControlEvents:UIControlEventTouchUpInside];
    [sheepButton setShowsTouchWhenHighlighted:YES];
    [sheepButton sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
}

-(void)replaceBackItem
{
    UIImage *sheepImage = [UIImage imageNamed:@"goback_icon"];
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setImage:sheepImage forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [sheepButton setShowsTouchWhenHighlighted:YES];
    [sheepButton sizeToFit];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:sheepButton]];
   
}

-(void)goBack
{
     //[self dismissViewControllerAnimated:TRUE completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)decorateOverlayToCamera:(UIImagePickerController *)camera
{
    if (camera &&
        camera.sourceType== UIImagePickerControllerSourceTypeCamera)
    {
        camera.showsCameraControls = NO;
        
        if ([[camera.cameraOverlayView subviews] count] == 0)
        {
            FSOverlayView *oView =[[[NSBundle mainBundle] loadNibNamed:@"FSOverlayView" owner:self options:nil] lastObject];
            CGRect overlayViewFrame = camera.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0,
                                         CGRectGetHeight(overlayViewFrame) -
                                         oView.frame.size.height - 10.0,
                                         CGRectGetWidth(overlayViewFrame),
                                        oView.frame.size.height + 10.0);
            
            oView.frame = newFrame;
            [camera.cameraOverlayView addSubview:oView];
            [oView.btnCancel setTarget:self];
            [oView.btnCancel setAction:@selector(doCancelCamera:)];
            [oView.btnGoGalary setTarget: self];
            [oView.btnGoGalary setAction:@selector(doGoGalary:)];
            [oView.btnTakePhoto setTarget:self];
            [oView.btnTakePhoto setAction:@selector(doTakePhotoExtend:)];
        }
    }

}



-(void) doCancelCamera:(UIView *)sender
{
    UIImagePickerController *camera = [self inUserCamera];
    [(id<UIImagePickerControllerDelegate>)self imagePickerControllerDidCancel:camera];
}

-(void) doTakePhotoExtend:(UIView *)sender
{
    UIImagePickerController *camera = [self inUserCamera];
    [camera takePicture];
}
-(void) doGoGalary:(UIView *)sender
{
    UIImagePickerController *camera = [self inUserCamera];
    [camera dismissViewControllerAnimated:TRUE completion:^{
         [(id<UIImagePickerControllerDelegate>)self imagePickerControllerDidCancel:camera];
        UIImagePickerController *galary = [[UIImagePickerController alloc] init];
        galary.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            galary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            galary.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            galary.allowsEditing = NO;
            [self presentViewController:galary animated:YES completion:nil];
            
        }

    }];
   
}

@end
