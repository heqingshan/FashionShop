//
//  FSSegmentControl.m
//  FashionShop
//
//  Created by gong yi on 12/11/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSSegmentControl.h"
#import "UIColor+RGB.h"
#import "FSConfiguration.h"
#define SC_HEIGHT 25


@interface StainView : UIView
@end

@interface FSSegmentControl ()
{
    CGFloat _arrowSize;
}

@property (strong, nonatomic) NSMutableArray *_items;
@property (strong, nonatomic) UIView *_selectedStainView;

@end

@implementation FSSegmentControl
{
    NSInteger _selectedSegmentIndex;
    BOOL _hasSetColor;
}

+ (Class)layerClass
{
    return CAShapeLayer.class;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    if ((self = [self init]))
    {
        [items enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL *stop)
         {
             [self insertSegmentWithTitle:title atIndex:idx animated:NO];
         }];
    }
    return self;
}

- (void)awakeFromNib
{
    
    [self commonInit];
    _selectedSegmentIndex = super.selectedSegmentIndex;
    for (NSInteger i = 0; i < super.numberOfSegments; i++)
    {
        [self insertSegmentWithTitle:[super titleForSegmentAtIndex:i] atIndex:i animated:NO];
    }
     
    [super removeAllSegments];
}

- (void)commonInit
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _selectedSegmentIndex = 0;
    self._items = NSMutableArray.array;
    _arrowSize = 8;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    ((CAShapeLayer *)self.layer).fillColor = PRO_LIST_HEADER_BGCOLOR.CGColor;
    self.backgroundColor =[UIColor whiteColor];
}

-(void)setSegBGColor:(UIColor*)aColor
{
    ((CAShapeLayer *)self.layer).fillColor = aColor.CGColor;
}

-(void)setTitleColor:(UIColor*)aColor selectedColor:(UIColor*)aSelColor
{
    [self._items enumerateObjectsUsingBlock:^(UILabel *item, NSUInteger idx, BOOL *stop)
     {
         if (self.selectedSegmentIndex == idx)
         {
             item.textColor = aColor;
         }
         else
         {
             item.textColor = aSelColor;
         }
     }];
    _hasSetColor = YES;
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    NSAssert(NO, @"insertSegmentWithImage:atIndex:animated: is not supported on SDSegmentedControl");
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)segment
{
    NSAssert(NO, @"imageForSegmentAtIndex: is not supported on SDSegmentedControl");
    return nil;
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment
{
    NSAssert(NO, @"setImage:forSegmentAtIndex: is not supported on SDSegmentedControl");
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = self._items[index];
    segmentView.text = title;
    segmentView.font = ME_FONT(PRO_LIST_HEADER_FONTSZ);
    segmentView.backgroundColor = [UIColor clearColor];
    [segmentView sizeToFit];
    [self setNeedsLayout];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UILabel *segmentView = self._items[index];
    return segmentView.text;
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated
{
    UILabel *segmentView = UILabel.new;
   // segmentView.alpha = 1;
    segmentView.text = title;
    segmentView.textColor = PRO_LIST_HEADER_COLOR;
    segmentView.font = [UIFont systemFontOfSize:PRO_LIST_HEADER_FONTSZ];
    segmentView.backgroundColor = [UIColor clearColor];
    segmentView.userInteractionEnabled = YES;
    [segmentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSelect:)]];
    [segmentView sizeToFit];
    
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments), 0);
    if (index < self._items.count)
    {
        segmentView.center = ((UIView *)self._items[index]).center;
        [self insertSubview:segmentView belowSubview:self._items[index]];
        [self._items insertObject:segmentView atIndex:index];
    }
    else
    {
        segmentView.center = self.center;
        [self addSubview:segmentView];
        [self._items addObject:segmentView];
    }
   
    if (animated)
    {
        [UIView animateWithDuration:.4 animations:^
         {
             [self layoutSegments];
         }];
    }
    else
    {
        [self setNeedsLayout];
    }
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated
{
    if (self._items.count == 0) return;
    NSUInteger index = MAX(MIN(segment, self.numberOfSegments - 1), 0);
    UIView *segmentView = self._items[index];
    
    if (self.selectedSegmentIndex >= index)
    {
        self.selectedSegmentIndex--;
    }
    
    if (animated)
    {
        [self._items removeObject:segmentView];
        [UIView animateWithDuration:.4 animations:^
         {
             segmentView.alpha = 0;
             [self layoutSegments];
         }
                         completion:^(BOOL finished)
         {
             [segmentView removeFromSuperview];
         }];
    }
    else
    {
        [segmentView removeFromSuperview];
        [self._items removeObject:segmentView];
        [self setNeedsLayout];
    }
}

- (void)removeAllSegments
{
    [self._items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self._items removeAllObjects];
    _selectedSegmentIndex = -1;
    [self setNeedsLayout];
}

- (NSUInteger)numberOfSegments
{
    return self._items.count;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGRect frame = self.frame;
    if (frame.size.height == 0)
    {
        frame.size.height = SC_HEIGHT;
    }
    if (frame.size.width == 0)
    {
        frame.size.width = CGRectGetWidth(newSuperview.bounds);
    }
}

- (void)setArrowSize:(CGFloat)arrowSize
{
    _arrowSize = arrowSize;
    [self setNeedsLayout];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    if (_selectedSegmentIndex != selectedSegmentIndex)
    {
        NSParameterAssert(selectedSegmentIndex < self._items.count);
        _selectedSegmentIndex = selectedSegmentIndex;
        [self setNeedsLayout];
    }
}

- (NSInteger)selectedSegmentIndex
{
    return _selectedSegmentIndex;
}

- (void)layoutSubviews
{
    [self layoutSegments];
}

- (void)layoutSegments
{
    CGFloat totalItemWidth = 0;
    for (UIView *item in self._items)
    {
        totalItemWidth += CGRectGetWidth(item.bounds);
    }
    
    CGFloat spaceLeft = CGRectGetWidth(self.bounds) - totalItemWidth;
    CGFloat interItemSpace = spaceLeft / (CGFloat)(self._items.count + 1);
    CGFloat itemsVAlignCenter = (CGRectGetHeight(self.bounds) - self.arrowSize / 2) / 2;
    
    __block CGFloat pos = interItemSpace;
    __block int itemIndex = 0;
    [self._items enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop)
     {
         if (self.selectedSegmentIndex == idx)
         {
             [item sizeToFit];
             item.center = CGPointMake(pos + CGRectGetWidth(item.bounds) / 2, itemsVAlignCenter);
             
         }
         else
         {
             item.frame = CGRectMake(pos, 0, CGRectGetWidth(item.bounds), itemsVAlignCenter * 2);
         }
         pos += CGRectGetWidth(item.bounds) + interItemSpace;
         if (itemIndex++<self._items.count-1)
         {
             UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(item.center.x+CGRectGetWidth(item.bounds)/2+interItemSpace/2, self.frame.origin.y, 1, self.frame.size.height)];
             [separator setImage:[UIImage imageNamed:@"timeline_nav_sep"]];
             [self addSubview:separator];
             
         }
     }];
       
    if (self.selectedSegmentIndex == -1)
    {
        [self drawSelectedMaskAtPosition:-1];
    }
    else
    {
        UIView *selectedItem = self._items[self.selectedSegmentIndex];
        
        for (UILabel *item in self._items)
        {
            if (item == selectedItem)
            {
                if (!_hasSetColor) {
                    item.textColor = [UIColor colorWithRed:255 green:255 blue:255];
                }
                item.font = [UIFont boldSystemFontOfSize:PRO_LIST_HEADER_FONTSZ];
            }
            else
            {
                if (!_hasSetColor) {
                    item.textColor =PRO_LIST_HEADER_COLOR;
                }
            }
        }
        
        [self drawSelectedMaskAtPosition:selectedItem.center.x];
    }

}

- (void)drawSelectedMaskAtPosition:(CGFloat)position
{
    // TODO: make this animatable
    UIBezierPath *path = UIBezierPath.new;
    CGRect bounds = self.bounds;
    [path moveToPoint:bounds.origin];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMinY(bounds))];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))];
    if (position >= 0)
    {
        [path addLineToPoint:CGPointMake(position + self.arrowSize, CGRectGetMaxY(bounds))];
        [path addLineToPoint:CGPointMake(position, CGRectGetMaxY(bounds) - self.arrowSize)];
        [path addLineToPoint:CGPointMake(position - self.arrowSize, CGRectGetMaxY(bounds))];
    }
    [path addLineToPoint:CGPointMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds))];
    [path addLineToPoint:bounds.origin];
    ((CAShapeLayer *)self.layer).path = path.CGPath;
}

- (void)handleSelect:(UIGestureRecognizer *)gestureRecognizer
{
    NSUInteger index = [self._items indexOfObject:gestureRecognizer.view];
    if (index != NSNotFound)
    {
        self.selectedSegmentIndex = index;
        [self setNeedsLayout];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end



