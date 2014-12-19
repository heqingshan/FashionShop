//
//  FSMyCommentController.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSMyCommentController.h"
#import "FSProCommentCell.h"
#import "FSCommonCommentRequest.h"
#import "FSPagedMyComment.h"
#import "FSPagedMyPLetter.h"
#import "FSMyCommentCell.h"
#import "FSDRViewController.h"
#import "FSPLetterViewController.h"
#import "FSMessageViewController.h"
#import "FSPLetterRequest.h"

@interface FSMyCommentController ()
{
    NSMutableArray *_dataSourceList;
    NSMutableArray *_noMoreList;
    NSMutableArray *_pageIndexList;
    int _currentSelIndex;
    
    BOOL    _isInLoading;
    BOOL    _isInRefreshing;
    BOOL    _isLoadMore;
    BOOL    _isCommentPaged;
    BOOL    _isLetterPaged;
    
    FSAudioButton   *lastButton;
    FSSourceType *type;
    NSOperationQueue *_asyncQueue;
}

@end

@implementation FSMyCommentController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification:) name:@"ReceivePushNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification_pletter:) name:@"ReceivePushNotification_pletter" object:nil];
    
    [self initArray];
    
    [self setSegHeader];
    
    //刷新处理
    [self prepareRefreshLayout:_tbAction withRefreshAction:^(dispatch_block_t action) {
        _isInRefreshing = YES;
        _isLoadMore = NO;
        [self requestDataWithCallback:^{
            _isInRefreshing = NO;
            action();
        }];
    }];
}

-(void)receivePushNotification:(NSNotification*)notification
{
    int totalCount = [theApp newCommentCount];
    [self showDotIcon:(totalCount>0?YES:NO) withIndex:1];
    if (_currentSelIndex == 1) {
        [self refreshData];
    }
}

-(void)receivePushNotification_pletter:(NSNotification*)notification
{
    int totalCount = [theApp newCommentCount_pletter];
    [self showDotIcon:(totalCount>0?YES:NO) withIndex:0];
    if (_currentSelIndex == 0) {
        [self refreshData];
    }
}

-(void)refreshData
{
    if (_isInLoading) {
        return;
    }
    [self startRefresh:nil withCallback:^{
        _isInRefreshing = YES;
        _isLoadMore = NO;
        [self requestDataWithCallback:^{
            _isInRefreshing = NO;
        }];
    }];
}

-(void)updateDotIcon
{
    int commentCount = [theApp newCommentCount];
    [self showDotIcon:(commentCount>0?YES:NO) withIndex:1];
    
    int letterCount = [theApp newCommentCount_pletter];
    [self showDotIcon:(letterCount>0?YES:NO) withIndex:0];
}

-(void)showDotIcon:(BOOL)flag withIndex:(int)selIndex
{
    if (selIndex == 0) {
        //私信处显示红点
        UIView *view = [_segHeader viewWithTag:6001];
        if (view) {
            view.hidden = !flag;
        }
        else{
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 8, 15, 15)];
            dotView.image = [UIImage imageNamed:@"dot.png"];
            dotView.tag = 6001;
            dotView.hidden = !flag;
            [_segHeader addSubview:dotView];
        }
    }
    else {
        //评论处显示红点
        UIView *view = [_segHeader viewWithTag:5001];
        if (view) {
            view.hidden = !flag;
        }
        else{
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 8, 15, 15)];
            dotView.image = [UIImage imageNamed:@"dot.png"];
            dotView.tag = 5001;
            dotView.hidden = !flag;
            [_segHeader addSubview:dotView];
        }
    }
}

-(void)initArray
{
    _dataSourceList = [@[] mutableCopy];
    _pageIndexList = [@[] mutableCopy];
    _noMoreList = [@[] mutableCopy];
    
    for (int i = 0; i < 3; i++) {
        [_dataSourceList insertObject:[@[] mutableCopy] atIndex:i];
        [_pageIndexList insertObject:@1 atIndex:i];
        [_noMoreList insertObject:@NO atIndex:i];
    }
}

-(void)setPageIndex:(int)_index selectedSegmentIndex:(NSInteger)_selIndexSegment
{
    NSNumber * nsNum = [NSNumber numberWithInt:_index];
    [_pageIndexList replaceObjectAtIndex:_selIndexSegment withObject:nsNum];
}

-(void)setNoMore:(BOOL)_more selectedSegmentIndex:(NSInteger)_selIndexSegment
{
    NSNumber * nsNum = [NSNumber numberWithBool:_more];
    [_noMoreList replaceObjectAtIndex:_selIndexSegment withObject:nsNum];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setSegHeader
{
    [_segHeader setDelegate:self];
    UIImage *backgroundImage = [UIImage imageNamed:@"tab_two_bg_normal.png"];
    [_segHeader setBackgroundImage:backgroundImage];
    [_segHeader setContentEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [_segHeader setSegmentedControlMode:AKSegmentedControlModeSticky];
    [_segHeader setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [_segHeader setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonPressImage = [UIImage imageNamed:@"tab_two_bg_selected"];
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn1 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn1 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn1 setTitle:@"我的私信" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn1.showsTouchWhenHighlighted = YES;
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateHighlighted];
    [btn2 setBackgroundImage:buttonPressImage forState:UIControlStateSelected];
    [btn2 setBackgroundImage:buttonPressImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [btn2 setTitle:@"我的评论" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:COMMON_SEGMENT_FONT_SIZE];
    btn2.showsTouchWhenHighlighted = YES;
    
    [_segHeader setButtonsArray:@[btn1, btn2]];
    _segHeader.selectedIndex = _originalIndex;
    self.title = _segHeader.selectedIndex==0?@"我的私信":@"我的评论";
    _isInRefreshing = NO;
    _isLoadMore = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //每次进行页面刷新
    _isInRefreshing = NO;
    _isLoadMore = NO;
    [self requestDataWithCallback:nil];
    //更新小红点
    [self updateDotIcon];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(void)requestDataWithCallback:(dispatch_block_t)callback
{
    if (_currentSelIndex == 0) {
        FSPLetterRequest * request=[[FSPLetterRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_MY_PLETTER;
        __block int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        //防止请求数据过程中出现再次点击segment的情形
        __block int _curSel = _currentSelIndex;
        if (_isInRefreshing) {
            currentPage = 1;
        }
        request.nextPage = [NSNumber numberWithInt:currentPage + (_isLoadMore?1:0)];
        request.pageSize = @COMMON_PAGE_SIZE;
        request.userToken = [FSModelManager sharedModelManager].loginToken;
        if (!_isInRefreshing) {
            _isLoadMore?[self beginLoadMoreLayout:_tbAction]:[self beginLoading:self.view];
        }
        _isInLoading = YES;
        [request send:[FSPagedMyPLetter class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            if (!_isInRefreshing) {
                _isLoadMore?[self endLoadMore:_tbAction]:[self endLoading:self.view];
            }
            _isInLoading = NO;
            if (resp.isSuccess)
            {
                FSPagedMyPLetter *item = resp.responseData;
                currentPage += _isLoadMore?1:0;
                [self setPageIndex:currentPage selectedSegmentIndex:_curSel];
                if (item.totalPageCount <= currentPage){
                    [self setNoMore:YES selectedSegmentIndex:_curSel];
                }
                [self fillProdInMemory:item.items isInsert:NO];
                _tbAction.contentOffset = CGPointZero;
                
                if (_tbAction.hidden) {
                    _tbAction.hidden = NO;
                }
                [_tbAction reloadData];
                if (!_isLoadMore) {
                    //更新badge存储内容
                    [self updateBadgeData];
                }
                if (_isLoadMore) {
                    //统计
                    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [_dic setValue:@"我的私信列表页" forKey:@"来源"];
                    [_dic setValue:[NSString stringWithFormat:@"%d", currentPage+1] forKey:@"页码"];
                    [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
                }
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
            if (callback)
                callback();
        }];
    }
    else{
        FSCommonCommentRequest * request=[[FSCommonCommentRequest alloc] init];
        request.routeResourcePath = RK_REQUEST_MYCOMMENT_LIST;
        __block int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        if (_isInRefreshing) {
            currentPage = 1;
        }
        request.nextPage = [NSNumber numberWithInt:currentPage + (_isLoadMore?1:0)];
        __block int _curSel = _currentSelIndex;
        request.pageSize = @COMMON_PAGE_SIZE;
        request.userToken = [FSModelManager sharedModelManager].loginToken;
        _isLoadMore?[self beginLoadMoreLayout:_tbAction]:[self beginLoading:self.view];
        _isInLoading = YES;
        [request send:[FSPagedMyComment class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _isLoadMore?[self endLoadMore:_tbAction]:[self endLoading:self.view];
            _isInLoading = NO;
            if (resp.isSuccess)
            {
                FSPagedMyComment *result = resp.responseData;
                _isLetterPaged = result.isPaged;
                currentPage += _isLoadMore?1:0;
                _isCommentPaged = result.isPaged;
                [self setPageIndex:currentPage selectedSegmentIndex:_curSel];
                if (result.totalPageCount <= currentPage)
                    [self setNoMore:YES selectedSegmentIndex:_curSel];
                [self fillProdInMemory:result.items isInsert:NO];
                _tbAction.contentOffset = CGPointZero;
                
                if (_tbAction.hidden) {
                    _tbAction.hidden = NO;
                }
                [_tbAction reloadData];
                if (!_isLoadMore) {
                    //更新badge存储内容
                    [self updateBadgeData];
                }
                if (_isLoadMore) {
                    //统计
                    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                    [_dic setValue:@"我的评论列表页" forKey:@"来源"];
                    [_dic setValue:[NSString stringWithFormat:@"%d", currentPage+1] forKey:@"页码"];
                    [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
                }
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
            if (callback)
                callback();
        }];
    }
}

-(void)updateBadgeData
{
    if (!_asyncQueue) {
        _asyncQueue = [[NSOperationQueue alloc] init];
        [_asyncQueue setMaxConcurrentOperationCount:1];
    }
    if (_currentSelIndex == 1) {
        [_asyncQueue addOperationWithBlock:^{
            NSMutableArray *_comments = _dataSourceList[_currentSelIndex];
            NSMutableArray *toRemove = [NSMutableArray array];
            NSMutableArray *_array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue"]];
            if (!_array) {
                return ;
            }
            for (NSString *item1 in _array) {
                BOOL flag = NO;
                for (FSComment *item2 in _comments) {
                    if ([item1 intValue] == item2.sourceid) {
                        flag = YES;
                        break;
                    }
                }
                if (!flag) {
                    [toRemove addObject:item1];
                }
            }
            if (toRemove.count > 0) {
                [theApp removeCommentIDs:toRemove];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification" object:nil];
            }
        }];
    }
    else if(_currentSelIndex == 0) {
        [_asyncQueue addOperationWithBlock:^{
            NSMutableArray *plist = _dataSourceList[_currentSelIndex];
            NSMutableArray *toRemove = [NSMutableArray array];
            NSMutableArray *_array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue_pletter"]];
            if (!_array) {
                return ;
            }
            for (NSString *item1 in _array) {
                BOOL flag = NO;
                for (FSCoreMyLetter *item2 in plist) {
                    if ([item1 intValue] == item2.id) {
                        flag = YES;
                        break;
                    }
                }
                if (!flag) {
                    [toRemove addObject:item1];
                }
            }
            if (toRemove.count > 0) {
                [theApp removePLetterIDs:toRemove];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivePushNotification_pletter" object:nil];
            }
        }];
    }
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods)
        return;
    if (_currentSelIndex == 0) {
        NSMutableArray *plist = _dataSourceList[_currentSelIndex];
        if (!plist) {
            plist = [[NSMutableArray alloc] initWithCapacity:5];
        }
        if (_isInRefreshing) {
            [plist removeAllObjects];
        }
        [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [plist indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSMyLetter *)obj1 valueForKey:@"id"] intValue] ==[[(FSMyLetter *)obj valueForKey:@"id"] intValue])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index==NSNotFound)
            {
                if (!isinserted)
                {
                    [plist addObject:obj];
                }
                else
                {
                    [plist insertObject:obj atIndex:0];
                }
            }
        }];
    }
    else{
        NSMutableArray *_comments = _dataSourceList[_currentSelIndex];
        if (!_comments) {
            _comments = [NSMutableArray array];
        }
        if (_isInRefreshing) {
            [_comments removeAllObjects];
        }
        [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_comments indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSComment *)obj1 valueForKey:@"commentid"] intValue] ==[[(FSComment *)obj valueForKey:@"commentid"] intValue])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index==NSNotFound)
            {
                if (!isinserted)
                {
                    [_comments addObject:obj];
                }
                else
                {
                    [_comments insertObject:obj atIndex:0];
                }
            }
        }];
    }
    [self showBlankIcon];
    [_tbAction reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [self setSegHeader:nil];
    [super viewDidUnload];
}

-(void)showBlankIcon
{
    NSMutableArray *tmpPros = [_dataSourceList objectAtIndex:_currentSelIndex];
    if (tmpPros.count < 1) {
        if (_currentSelIndex == 0) {
//            if (IOS7) {
//                [self showNoResultImage:_tbAction withImage:@"blank_message.png" withText:NSLocalizedString(@"TipInfo_Private_Letter_None", nil)  originOffset:40];
//            }
//            else
            {
                [self showNoResultImage:_tbAction withImage:@"blank_message.png" withText:NSLocalizedString(@"TipInfo_Private_Letter_None", nil)  originOffset:100];
            }
            
        }
        else{
//            if (IOS7) {
//                [self showNoResultImage:_tbAction withImage:@"blank_comment.png" withText:NSLocalizedString(@"TipInfo_Comment_None", nil)  originOffset:40];
//            }
//            else
            {
                [self showNoResultImage:_tbAction withImage:@"blank_comment.png" withText:NSLocalizedString(@"TipInfo_Comment_None", nil)  originOffset:100];
            }
            
        }
    }
    else{
        [self hideNoResultImage:_tbAction];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //首先判断是否需要翻页
    if (_currentSelIndex == 0) {
        if (!_isLetterPaged) {
            return;
        }
    }
    else{
        if (!_isCommentPaged) {
            return;
        }
    }
    BOOL _noMore = [[_noMoreList objectAtIndex:_currentSelIndex] boolValue];
    if (!_noMore &&
        !_isInLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
        && scrollView.contentSize.height>scrollView.frame.size.height
        &&scrollView.contentOffset.y>0)
    {
        _isLoadMore = YES;
        _isInRefreshing = NO;
        [self requestDataWithCallback:nil];
        
        //统计
        NSString *value = _segHeader.selectedIndex==0?@"我的私信":@"我的评论";
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:value forKey:@"来源"];
        int currentPage = [[_pageIndexList objectAtIndex:_currentSelIndex] intValue];
        [_dic setValue:[NSString stringWithFormat:@"%d", currentPage+1] forKey:@"页码"];
        [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
    }
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelIndex == 0) {
        NSMutableArray *_plist = _dataSourceList[_currentSelIndex];
        FSMyLetter *item = _plist[indexPath.row];
        
        FSMessageViewController *viewController = [[FSMessageViewController alloc] init];
        if ([item.fromuser.uid intValue] == [[FSUser localProfile].uid intValue]) {
            viewController.touchUser = item.touser;
        }
        else{
            viewController.touchUser = item.fromuser;
        }
        viewController.lastConversationId = item.id;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:nav animated:YES completion:nil];
        [theApp removePLetterID:[NSString stringWithFormat:@"%d", [item.fromuser.uid intValue]]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"我的私信列表" forKey:@"来源页面"];
        [_dic setValue:viewController.touchUser.nickie forKey:@"私信对象名称"];
        [_dic setValue:viewController.touchUser.uid forKey:@"私信对象ID"];
        [[FSAnalysis instance] logEvent:CHECK_MESSAGE_PAGE withParameters:_dic];
        
        [[FSAnalysis instance] autoTrackPages:nav];
    }
    else{
        NSMutableArray *_comments = _dataSourceList[_currentSelIndex];
        FSComment *item = _comments[indexPath.row];
        FSProDetailViewController *detailViewController = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
        if (item.sourcetype == FSSourceProduct) {
            FSProdItemEntity *fsItem = [[FSProdItemEntity alloc] init];
            fsItem.id = item.sourceid;
            type = FSSourceProduct;
            detailViewController.navContext = [NSArray arrayWithObjects:fsItem, nil];
        }
        if (item.sourcetype == FSSourcePromotion) {
            FSProItemEntity *fsItem = [[FSProItemEntity alloc] init];
            fsItem.id = item.sourceid;
            type = FSSourcePromotion;
            detailViewController.navContext = [NSArray arrayWithObjects:fsItem, nil];
        }
        detailViewController.dataProviderInContext = self;
        detailViewController.indexInContext = 0;
        detailViewController.sourceType = item.sourcetype;
        UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [self presentViewController:navControl animated:YES completion:nil];
        [theApp removeCommentID:[NSString stringWithFormat:@"%d", item.sourceid]];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
        
        if (item.sourcetype == FSSourceProduct) {
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [_dic setValue:[NSString stringWithFormat:@"%d", item.sourceid] forKey:@"商品ID"];
            [_dic setValue:@"我的评论列表" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST_DETAIL withParameters:_dic];
        }
        else if(item.sourcetype == FSSourcePromotion) {
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [_dic setValue:[NSString stringWithFormat:@"%d", item.sourceid] forKey:@"促销ID"];
            [_dic setValue:@"我的评论列表" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_PROLIST_DETAIL withParameters:_dic];
        }
        
        //统计2
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"我的评论列表" forKey:@"来源页面"];
        [_dic setValue:item.sourcetype == FSSourceProduct?@"商品":@"活动" forKey:@"来源分类"];
        [[FSAnalysis instance] logEvent:CHECK_COMMENT_LIST withParameters:_dic];
        
        [[FSAnalysis instance] autoTrackPages:navControl];
    }
}

#pragma mark - UITableViewSource delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentSelIndex == 0) {
        NSMutableArray *plist = _dataSourceList[_currentSelIndex];
        return plist.count;
    }
    else{
        NSMutableArray *_comments = _dataSourceList[_currentSelIndex];
        return _comments.count;
    }
}

#define My_Comment_Cell_Indentifier @"FSMyCommentCell"
#define My_Letter_Cell_Indetifier @"FSMyLetterCell"

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelIndex == 0) {
        FSMyLetterCell *cellMy = (FSMyLetterCell*)[tableView dequeueReusableCellWithIdentifier:My_Letter_Cell_Indetifier];
        if (cellMy == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSMyCommentCell" owner:self options:nil];
            if (_array.count > 1) {
                cellMy = (FSMyLetterCell*)_array[1];
            }
            else{
                cellMy = [[FSMyLetterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:My_Letter_Cell_Indetifier];
            }
        }
        cellMy.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellMy.selectionStyle = UITableViewCellSelectionStyleBlue;
        NSMutableArray *plist = _dataSourceList[_currentSelIndex];
        FSMyLetter *item = [plist objectAtIndex:indexPath.row];
        [cellMy setData:item];
        cellMy.clipsToBounds = YES;
        cellMy.imgThumb.delegate = self;
        BOOL flag = YES;
        NSArray *_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue_pletter"];
        if (_array) {
            //增加显示红点标识
            for (NSString *value in _array) {
                if ([value intValue] == [item.fromuser.uid intValue]) {
                    flag = NO;
                    break;
                }
            }
        }
        cellMy.dotView.hidden = flag;
        
        return cellMy;
    }
    else{
        FSMyCommentCell *cellMy = (FSMyCommentCell*)[tableView dequeueReusableCellWithIdentifier:My_Comment_Cell_Indentifier];
        if (cellMy == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSMyCommentCell" owner:self options:nil];
            if (_array.count > 0) {
                cellMy = (FSMyCommentCell*)_array[0];
            }
            else{
                cellMy = [[FSMyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:My_Comment_Cell_Indentifier];
            }
        }
        cellMy.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cellMy.selectionStyle = UITableViewCellSelectionStyleBlue;
        NSMutableArray *_comments = _dataSourceList[_currentSelIndex];
        FSComment *item = [_comments objectAtIndex:indexPath.row];
        [cellMy setData:item];
        cellMy.clipsToBounds = YES;
        cellMy.imgThumb.delegate = self;
        if (!cellMy.audioButton.audioDelegate) {
            cellMy.audioButton.audioDelegate = self;
        }
        [cellMy updateFrame];
        
        BOOL flag = YES;
        NSArray *_array = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetvalue"];
        if (_array) {
            //增加显示红点标识
            for (NSString *value in _array) {
                if ([value intValue] == item.sourceid) {
                    flag = NO;
                    break;
                }
            }
        }
        cellMy.dotView.hidden = flag;
        
        return cellMy;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentSelIndex == 0) {
        FSMyLetterCell *cell = (FSMyLetterCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else{
        FSMyCommentCell *cell = (FSMyCommentCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    return 40;
}

#pragma mark - FSThumbView delegate

-(void)didTapThumView:(id)sender
{
    if ([sender isKindOfClass:[FSThumView class]])
    {
        [self goDR:[(FSThumView *)sender ownerUser].uid];
    }
}

- (IBAction)goDR:(NSNumber *)userid {
    
    FSDRViewController *dr = [[FSDRViewController alloc] initWithNibName:@"FSDRViewController" bundle:nil];
    dr.userId = [userid intValue];
    [self.navigationController pushViewController:dr animated:TRUE];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"我的评论列表页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:CHECK_DAREN_DETAIL withParameters:_dic];
}

#pragma mark - FSProDetailItemSourceProvider

-(void)proDetailViewDataFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index  completeCallback:(UICallBackWith1Param)block errorCallback:(dispatch_block_t)errorBlock
{
    FSProItemEntity *item =  [view.navContext objectAtIndex:index];
    if (item)
        block(item);
    else
        errorBlock();
    
}
-(FSSourceType)proDetailViewSourceTypeFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return type;
}

-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return TRUE;
}

#pragma mark - FSAudioDelegate

-(void)clickAudioButton:(FSAudioButton*)aButton
{
    if (lastButton) {
        if (lastButton != aButton) {
            [lastButton stop];
        }
    }
    lastButton = aButton;
}

#pragma mark - AKSegmentedControlDelegate

- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    if (segmentedControl == _segHeader){
        if (_isInLoading) {
            return;
        }
        if(_currentSelIndex == index)
        {
            return;
        }
        _currentSelIndex = index;
        NSMutableArray *source = [_dataSourceList objectAtIndex:index];
        if (source == nil || source.count<=0)
        {
            _isLoadMore = NO;
            _isInRefreshing = NO;
            [self requestDataWithCallback:nil];
        }
        else{
            [self showBlankIcon];
            [_tbAction reloadData];
            [_tbAction setContentOffset:CGPointZero];
        }
        self.title = _currentSelIndex==0?@"我的私信":@"我的评论";
        
        //统计
        NSString *value = index == 0?@"我的私信":@"我的评论";
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [_dic setValue:@"私信评论列表页" forKey:@"来源页面"];
        [_dic setValue:value forKey:@"分类名称"];
        [[FSAnalysis instance] logEvent:CHECK_COUPONT_LIST_TAB withParameters:_dic];
    }
}

@end
