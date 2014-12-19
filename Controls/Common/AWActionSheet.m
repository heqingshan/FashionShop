//
//  AWActionSheet.m
//  AWIconSheet
//
//  Created by Narcissus on 10/26/12.
//  Copyright (c) 2012 Narcissus. All rights reserved.
//

#import "AWActionSheet.h"
#import <QuartzCore/QuartzCore.h>
#define itemPerPage 9

@interface AWActionSheet()<UIScrollViewDelegate>
@property (nonatomic, retain)UIScrollView* scrollView;
@property (nonatomic, retain)UIPageControl* pageControl;
@property (nonatomic, retain)NSMutableArray* items;
@property (nonatomic, assign)id<AWActionSheetDelegate> IconDelegate;
@end
@implementation AWActionSheet
@synthesize scrollView;
@synthesize pageControl;
@synthesize items;
@synthesize IconDelegate;
-(void)dealloc
{
    IconDelegate= nil;
    
}

-(id)initWithIconSheetDelegate:(id<AWActionSheetDelegate>)delegate ItemCount:(int)cout
{
    int rowCount = 3;
    if (cout <=3) {
        rowCount = 1;
    } else if (cout <=6) {
        rowCount = 2;
    }
    NSString* titleBlank = @"\n\n\n\n\n";
    for (int i = 1 ; i<rowCount; i++) {
        titleBlank = [NSString stringWithFormat:@"%@%@",titleBlank,@"\n\n\n\n\n\n"];
    }
    self = [super initWithTitle:titleBlank
                       delegate:nil
              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
         destructiveButtonTitle:nil
              otherButtonTitles:nil];
    if (self) {
        [self setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        IconDelegate = delegate;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, 320, 70*rowCount)];
        [scrollView setPagingEnabled:YES];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:YES];
        [scrollView setBounces:NO];
        
        [self addSubview:scrollView];
    
        
        self.items = [[NSMutableArray alloc] initWithCapacity:cout];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)showInView:(UIView *)view
{
    [super showInView:view];
    [self reloadData];
}

- (void)reloadData
{
    for (AWActionSheetCell* cell in items) {
        [cell removeFromSuperview];
        [items removeObject:cell];
    }
   
    
    int count = [IconDelegate numberOfItemsInActionSheet];
    
    if (count <= 0) {
        return;
    }
    
    int rowCount = 3;
    int height = 100;
    if (count <= 3) {
        [self setTitle:@"\n\n\n\n\n\n"];
        [scrollView setFrame:CGRectMake(0, 10, 320, height)];
        rowCount = 1;
    } else if (count <= 6) {
        [self setTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n"];
        [scrollView setFrame:CGRectMake(0, 10, 320, height*2)];
        rowCount = 2;
    }
    [scrollView setContentSize:CGSizeMake(320*(count/itemPerPage+1), scrollView.frame.size.height)];
    [pageControl setNumberOfPages:count/itemPerPage+1];
    [pageControl setCurrentPage:0];
    
    
    for (int i = 0; i< count; i++) {
        AWActionSheetCell* cell = [IconDelegate cellForActionAtIndex:i];
        int PageNo = i/itemPerPage;
        int index  = i%itemPerPage;
        
        if (itemPerPage == 9) {
            
            int row = index/3;
            int column = index%3;
            
            
            float centerY = (1+row*2)*self.scrollView.frame.size.height/(2*rowCount);
            float centerX = (1+column*2)*self.scrollView.frame.size.width/6;

            [cell setCenter:CGPointMake(centerX+320*PageNo, centerY)];
            [self.scrollView addSubview:cell];
          
        }
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionForItem:)];
        [self addGestureRecognizer:tap];
        [items addObject:cell];
    }
    
}

- (void)actionForItem:(UITapGestureRecognizer*)recongizer
{
    CGPoint touchPoint = [recongizer locationInView:self];
    UIView* touchedView = [self hitTest:touchPoint withEvent:nil];
    if ([touchedView isKindOfClass:[AWActionSheetCell class]])
    {
        AWActionSheetCell* cell = (AWActionSheetCell*)touchedView;
        [IconDelegate DidTapOnItemAtIndex:cell.index];
    };
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];
}
#pragma mark -
#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x /320;
    pageControl.currentPage = page;
}


@end

#pragma mark - AWActionSheetCell
@interface AWActionSheetCell ()
@end
@implementation AWActionSheetCell
@synthesize iconView;
@synthesize titleLabel;


-(id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 80, 90)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        [iconView setBackgroundColor:[UIColor clearColor]];
        [[iconView layer] setCornerRadius:8.0f];
        [[iconView layer] setMasksToBounds:YES];
        
        [self addSubview:iconView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 80, 20)];
        self.titleLabel.font = ME_FONT(12);
        if (IOS7) {
            self.titleLabel.textColor = [UIColor blackColor];
        }
        else
        {
            self.titleLabel.textColor = [UIColor whiteColor];
        }
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

@end


