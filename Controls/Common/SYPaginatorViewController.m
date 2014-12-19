//
//  SYPaginatorViewController.m
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYPaginatorViewController.h"
#import "SYPageView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SYPaginatorViewController()
{
    
}
- (void)_initialize;
@end

@implementation SYPaginatorViewController

@synthesize paginatorView = _paginator;
@synthesize currentPageIndex = _currentPageIndex;

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[self _initialize];
	}
	return self;
}


- (void)dealloc {
	_paginator.dataSource = nil;
	_paginator.delegate = nil;
}

-(void) setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [_paginator setCurrentPageIndex:_currentPageIndex animated:FALSE];
}

#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self _initialize];
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	_paginator.frame =self.view.frame;
    [self.view addSubview:_paginator];
}


#pragma mark - Private

- (void)_initialize {
	_paginator = [[SYPaginatorView alloc] initWithFrame:CGRectZero];
	_paginator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
	_paginator.dataSource = self;
	_paginator.delegate = self;
}


#pragma mark - SYPaginatorDataSource


@end
