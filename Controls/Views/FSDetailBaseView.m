//
//  FSDetailBaseView.m
//  FashionShop
//
//  Created by gong yi on 12/14/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSDetailBaseView.h"

#define UIVIEW_PROBASE_MASK_IDENTIFER 2002
@implementation FSDetailBaseView
@synthesize pType;
@synthesize showViewMask = _showViewMask;
@synthesize myToolBar;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setShowViewMask:(BOOL)showViewMask
{
    if (showViewMask ==_showViewMask)
        return;
    _showViewMask = showViewMask;
    if (showViewMask)
    {
        UIView *emptyView = (UIView *)[self viewWithTag:UIVIEW_PROBASE_MASK_IDENTIFER];
        if (!emptyView)
        {
            emptyView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-40,self.frame.origin.y+80, 80, 80)];
            emptyView.backgroundColor = [UIColor clearColor];
            emptyView.tag = UIVIEW_PROBASE_MASK_IDENTIFER;
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
        [self addSubview:emptyView];
        [self bringSubviewToFront:emptyView];
    } else
    {
        UIView *emptyView =(UIView *)[self viewWithTag:UIVIEW_PROBASE_MASK_IDENTIFER];
        if (emptyView)
        {
            [emptyView removeFromSuperview];
        }

    }
}
-(void)resetScrollViewSize
{}
-(void) updateInteraction:(id)updatedEntity{}

@end
