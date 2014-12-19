//
//  FSAddressManagerViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-6-24.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSAddressManagerViewController.h"
#import "FSAddressDetailViewController.h"
#import "FSCommonUserRequest.h"
#import "FSAddress.h"
#import "FSPagedAddress.h"
#import "FSAddressCell.h"
#import "FSAddressRequest.h"

@interface FSAddressManagerViewController ()
{
    NSMutableArray *_likes;
    int _currentPage;
    BOOL _noMore;
    BOOL _inLoading;
    int _currentSelIndex;
}

@end

@implementation FSAddressManagerViewController

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
    if (_pageFrom == 1) {
        self.title = @"收货地址管理";
    }
    else {
        self.title = @"选择收货地址";
    }
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    [self prepareRefresh];
    
    [self addRightButton:@"添加地址"];
    _contentView.backgroundColor = APP_TABLE_BG_COLOR;
    _contentView.backgroundView = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareData];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRightButton:(NSString*)title
{
    UIImage *btnNormal = [[UIImage imageNamed:@"btn_big_normal.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:5];    
    UIButton *sheepButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheepButton setTitle:title forState:UIControlStateNormal];
    [sheepButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    sheepButton.titleLabel.font = ME_FONT(13);
    sheepButton.showsTouchWhenHighlighted = YES;
    [sheepButton setBackgroundImage:btnNormal forState:UIControlStateNormal];
    [sheepButton sizeToFit];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:sheepButton];
    [self.navigationItem setRightBarButtonItem:item];
}

-(void)clickRightButton:(UIButton*)sender
{
    if (_likes.count >= 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Address Allow Max Number", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK",nil), nil];
        [alert show];
        return;
    }
    FSAddressDetailViewController *addressView = [[FSAddressDetailViewController alloc] initWithNibName:@"FSAddressDetailViewController" bundle:nil];
    addressView.pageState = FSAddressDetailStateNew;
    [self.navigationController pushViewController:addressView animated:YES];
}

-(void) prepareData
{
    [self beginLoading:_contentView];
    _inLoading = YES;
    _currentPage = 1;
    FSAddressRequest *request = [self createRequest:_currentPage];
    [request send:[FSPagedAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        [self endLoading:_contentView];
        _inLoading = NO;
        if (resp.isSuccess)
        {
            FSPagedAddress *innerResp = resp.responseData;
            if (innerResp.totalPageCount<=_currentPage)
                _noMore = YES;
            [self mergeLike:innerResp isInsert:false];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void)initIndex
{
    _selectedIndex = -1;
    for (int i = 0; i < _likes.count; i++) {
        FSAddress *item = _likes[i];
        if (item.id == _selAddressId) {
            _selectedIndex = i;
        }
        else{
            continue;
        }
    }
}

-(void) prepareRefresh
{
    [self prepareRefreshLayout:_contentView withRefreshAction:^(dispatch_block_t action) {
        FSAddressRequest *request = [self createRequest:1];
        [request send:[FSPagedAddress class] withRequest:request completeCallBack:^(FSEntityBase * resp) {
            action();
            if (resp.isSuccess)
            {
                FSPagedAddress *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage)
                    _noMore = true;
                [self mergeLike:innerResp isInsert:false];
                
                _currentPage = 1;//如果刷新成功，则当前页标识设置成第一页
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }];
}

-(void) mergeLike:(FSPagedAddress *)response isInsert:(BOOL)isinsert
{
    if (!_likes)
    {
        _likes = [@[] mutableCopy];
    }
    else{
        [_likes removeAllObjects];
    }
    if (response && response.items)
    {
        [response.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int index = [_likes indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
                if ([[(FSAddress *)obj1 valueForKey:@"id"] isEqualToValue:[(FSAddress *)obj valueForKey:@"id"]])
                {
                    return TRUE;
                    *stop1 = TRUE;
                }
                return FALSE;
            }];
            if (index == NSNotFound)
            {
                if (isinsert)
                    [_likes insertObject:obj atIndex:0];
                else
                    [_likes addObject:obj];
            }
        }];
        [self initIndex];//初始化selIndex
        [_contentView reloadData];
    }
    if (_likes.count<1)
    {
        //加载空视图
//        if (IOS7) {
//            [self showNoResultImage:_contentView withImage:@"blank_order.png" withText:NSLocalizedString(@"TipInfo_Address_List_None", nil)  originOffset:30];
//        }
//        else
        {
            [self showNoResultImage:_contentView withImage:@"blank_order.png" withText:NSLocalizedString(@"TipInfo_Address_List_None", nil)  originOffset:90];
        }
        
    }
    else
    {
        [self hideNoResultImage:_contentView];
    }
}

-(FSAddressRequest *)createRequest:(int)index
{
    FSAddressRequest *request = [[FSAddressRequest alloc] init];
    
    FSUser *currentUser = [FSUser localProfile];
    request.userToken = currentUser?currentUser.uToken:[FSModelManager sharedModelManager].loginToken;
    request.pageSize = COMMON_PAGE_SIZE;
    request.nextPage = index;
    request.routeResourcePath = REQUEST_ADDRESS_MY;
    
    return request;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _likes?_likes.count:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#define USER_ADDRESS_LIST_CELL @"FSAddressListCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSAddressListCell *listCell = [_contentView dequeueReusableCellWithIdentifier:USER_ADDRESS_LIST_CELL];
    if (listCell == nil) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSAddressCell" owner:self options:nil];
        if (_array.count > 0) {
            listCell = (FSAddressListCell*)_array[0];
        }
        else{
            listCell = [[FSAddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_ADDRESS_LIST_CELL];
        }
    }
    if (_pageFrom == 2) {
        if ([indexPath section] == _selectedIndex) {
            listCell.accessoryType = UITableViewCellAccessoryCheckmark;
            lastIndexPath = indexPath;
        }
        else {
            listCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if (_pageFrom == 1){
        listCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section < _likes.count) {
        FSAddress *address = _likes[indexPath.section];
        [listCell setData:address];
    }
    
    return listCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_pageFrom == 1) {
        FSAddressDetailViewController *addressView = [[FSAddressDetailViewController alloc] initWithNibName:@"FSAddressDetailViewController" bundle:nil];
        addressView.pageState = FSAddressDetailStateShow;
        FSAddress *address = _likes[indexPath.section];
        addressView.addressID = address.id;
        [self.navigationController pushViewController:addressView animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
        //处理选中项的情况
        int newSection = [indexPath section];
        int oldSection = lastIndexPath==nil?-1:[lastIndexPath section];
        if(newSection != oldSection)
        {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            lastIndexPath = indexPath;
            _selectedIndex = newSection;
        }
        _selectedAddress = _likes[indexPath.section];
        if ([_delegate respondsToSelector:@selector(addressManagerViewControllerSetSelected:)]) {
            [_delegate addressManagerViewControllerSetSelected:self];
        }
        
        [self performSelector:@selector(onButtonBack:) withObject:nil afterDelay:0.5];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (!_inLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
        && scrollView.contentOffset.y>0
        && !_noMore)
    {
        _inLoading = YES;
        FSAddressRequest *request = [self createRequest:_currentPage+1];
        [request send:[FSPagedAddress class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
            _inLoading = NO;
            if (resp.isSuccess)
            {
                FSPagedAddress *innerResp = resp.responseData;
                if (innerResp.totalPageCount<=_currentPage+1)
                    _noMore = true;
                _currentPage ++;
                [self mergeLike:innerResp isInsert:FALSE];
                
                //统计
//                NSString *value = _likeType==0?@"关注列表页":@"粉丝列表页";
//                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
//                [_dic setValue:value forKey:@"来源"];
//                [_dic setValue:[NSString stringWithFormat:@"%d", _currentPage] forKey:@"页码"];
//                [[FSAnalysis instance] logEvent:STATISTICS_TURNS_PAGE withParameters:_dic];
            }
            else
            {
                [self reportError:resp.errorDescrip];
            }
        }];
    }
}

@end
