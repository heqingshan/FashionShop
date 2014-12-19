//
//  FSSuggestCell.m
//  FashionShop
//
//  Created by gong yi on 11/14/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSFavorProCell.h"
#import "SpringboardLayoutAttributes.h"
#import "FSResource.h"


#define MARGIN 2
@interface FSFavorProCell()
{
    
    UIImage *deleteButtonImg;
    BOOL isInRemove;
}

//- (IBAction)doRemoveItem:(id)sender;

@end

@implementation FSFavorProCell
@synthesize data = _data;
@synthesize deleteButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareRemoveClick];
    }
    return self;
}
 - (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self prepareRemoveClick];
    }
    return self;
}

-(void)willRemoveFromView
{
    _imgResource.image = nil;
   // [deleteButton setImage:nil forState:UIControlStateNormal];
    NSLog(@"image removed");
}

-(void) prepareRemoveClick
{
    _imgResource = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:_imgResource];
    _imgResource.clipsToBounds = YES;
    
    _btnPro = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_btnPro setImage:[UIImage imageNamed:@"promotion_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_btnPro];
    
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 24)];
    [deleteButton setImage:[UIImage imageNamed:@"cancel2_icon.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:deleteButton];
}


-(void) setData:(id)dataSource{
    if (dataSource){
        _data = dataSource;
        _imgResource.frame = self.bounds;
    }
}

-(void) showProIcon
{
    _btnPro.hidden = NO;
    _btnPro.frame = CGRectMake(3, 3, 17, 17);
}

-(void) hidenProIcon
{
    _btnPro.hidden = YES;
}

- (void)applyLayoutAttributes:(SpringboardLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    if (layoutAttributes.isDeleteButtonHidden)
    {
        deleteButton.layer.opacity = 0.0;
        [self stopQuivering];
    }
    else
    {
        deleteButton.layer.opacity = 1.0;
        [self bringSubviewToFront:deleteButton];
        [self startQuivering];
        
    }
}

-(void)imageContainerStartDownload:(id)container withObject:(id)indexPath andCropSize:(CGSize)crop
{
    if (!self.imgResource.image &&
        [_data respondsToSelector:@selector(resources)])
    {
        if ([_data resources] && [_data resources].count>0)
        {
            FSResource *resource = nil;
            for (FSResource *res in [_data resources]) {
                if (res.type == 1) {
                    resource = res;
                    break;
                }
            }
            if (resource) {
                NSURL *url = [resource absoluteUrl];
                if (url)
                {
                    [self.imgResource setImageUrl:url resizeWidth:CGSizeMake(crop.width*RetinaFactor, crop.height*RetinaFactor) placeholderImage:[UIImage imageNamed:@"default_icon120.png"]];
                }
            }
        }
       
    }
    else if (!self.imgResource.image &&
             [_data respondsToSelector:@selector(resource)])
    {
        if ([_data resource] && [_data resource].count>0)
        {
            FSResource *resource = nil;
            for (FSResource *res in [_data resource]) {
                if (res.type == 1) {
                    resource = res;
                    break;
                }
            }
            if (resource) {
                NSURL *url = [resource absoluteUrl];
                if (url)
                {
                    [self.imgResource setImageUrl:url resizeWidth:CGSizeMake(crop.width*RetinaFactor, crop.height*RetinaFactor) placeholderImage:[UIImage imageNamed:@"default_icon120.png"]];
                }
            }
        }
        
    }
}


- (void)startQuivering
{
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    float startAngle = (-2) * M_PI/180.0;
    float stopAngle = -startAngle;
    quiverAnim.fromValue = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue = [NSNumber numberWithFloat:3 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration = 0.5;
    quiverAnim.repeatCount = HUGE_VALF;
    float timeOffset = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset = timeOffset;
    CALayer *layer = self.layer;
    [layer addAnimation:quiverAnim forKey:@"quivering"];
}

- (void)stopQuivering
{
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:@"quivering"];
}
@end
