//
//  FSPLetterViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPLetterViewController.h"
#import "FSPLetterRequest.h"
#import "FSDRViewController.h"
#import "FSPagedMyPLetter.h"
#import "FSMyCommentCell.h"
#import "FSProCommentInputView.h"
#import "NSString+Extention.h"

#define PRIVATE_LETTER_COMMENT_INPUT_TAG 2000
#define PRIVATE_LETTER_TOOLBAR_HEIGHT 45
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface FSPLetterViewController ()
{
    BOOL _isInLoading;
    BOOL _isSending;
    int currentPage;
    BOOL noMore;
    FSPLetterCommentInputView *commentView;
    CGPoint lastPoint;
    
    NSMutableArray *dataArray;
    CGRect _keyboardRect;
    UIEdgeInsets _priorInset;
    BOOL _priorInsetSaved;
    CGPoint originalContentOffset;
}

@end

@implementation FSPLetterViewController

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
    self.title = _touchUser.nickie;
    
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    //[self addRightButton:@"清空"];
    CGRect _rect = _tbAction.frame;
    _rect.size.height -= PRIVATE_LETTER_TOOLBAR_HEIGHT;
    _tbAction.frame = _rect;
    
    [self displayCommentInputView];
     
    NSArray *array = [FSCoreMyLetter fetchLatestLetters:10 one:[[FSModelManager sharedModelManager].localLoginUid intValue] two:[_touchUser.uid intValue]];
    if (array.count > 0) {
        [self fillDataArray:array isInsert:NO];
        _lastConversationId = [array[array.count - 1] id];
    }
    else{
        _lastConversationId = 0;
    }
    
    currentPage = 1;
    [self requestData:YES];
    
    //刷新处理
    [self prepareRefreshLayout:_tbAction withRefreshAction:^(dispatch_block_t action) {
        //do something
        [self performSelector:@selector(addLastData:) withObject:action afterDelay:1.0];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePushNotification_pletter:) name:@"ReceivePushNotification_pletter" object:nil];
}

-(void)receivePushNotification_pletter:(NSNotification*)notification
{
    //获取最新的数据
    [self requestData:NO];
}

-(void)addLastData:(dispatch_block_t)action
{
    if (noMore) {
        if (action) {
            action();
        }
        return;
    }
    FSCoreMyLetter *item = dataArray[0];
    NSArray *array = [FSCoreMyLetter fetchData:item.id one:[[FSModelManager sharedModelManager].localLoginUid intValue] two:[_touchUser.uid intValue] length:10 ascending:NO];
    if (array.count > 0) {
        [self fillDataArray:array isInsert:YES];
        NSMutableArray *paths = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSIndexPath *_item = [NSIndexPath indexPathForRow:i inSection:0];
            [paths addObject:_item];
        }
        originalContentOffset = _tbAction.contentOffset;
        [_tbAction beginUpdates];
        [_tbAction insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        [_tbAction endUpdates];
        _tbAction.contentOffset = originalContentOffset;
    }
    else{
        noMore = YES;
    }
    if (action) {
        action();
    }
}

-(void) fillDataArray:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods || prods.count <= 0)
        return;
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    if (isinserted) {
        prods = [[prods reverseObjectEnumerator] allObjects];
    }
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [dataArray indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
            if ([[(FSCoreMyLetter *)obj1 valueForKey:@"id"] intValue] ==[[(FSCoreMyLetter *)obj valueForKey:@"id"] intValue])
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
                [dataArray addObject:obj];
            }
            else
            {
                [dataArray insertObject:obj atIndex:0];
            }
        }
    }];
}

-(void)requestData:(int)flag
{
    if (_isInLoading) {
        return;
    }
    FSPLetterRequest * request=[[FSPLetterRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_MY_PLETTER_CONVERSATION;
    request.nextPage = [NSNumber numberWithInt:currentPage];
    request.pageSize = @COMMON_PAGE_SIZE;
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    request.userid = _touchUser.uid;
    request.lastconversationid = [NSNumber numberWithInt:_lastConversationId];
    if(flag)[self beginLoading:_tbAction];
    _isInLoading = YES;
    request.rootKeyPath = @"data.items";
    [request send:[FSCoreMyLetter class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        if(flag)[self endLoading:_tbAction];
        _isInLoading = NO;
        if (resp.isSuccess)
        {
            NSArray *array = [FSCoreMyLetter fetchData:_lastConversationId one:[[FSModelManager sharedModelManager].localLoginUid intValue] two:[_touchUser.uid intValue] length:[resp.responseData count] ascending:YES];
            if (array.count > 0) {
                if (!dataArray) {
                    dataArray = [NSMutableArray arrayWithCapacity:5];
                }
                [self fillDataArray:array isInsert:NO];
                _lastConversationId = [dataArray[dataArray.count - 1] id];
                originalContentOffset = _tbAction.contentOffset;
                [_tbAction reloadData];
            }
            [self resetTableOffset:NO];
        }
        else
        {
            [self reportError:resp.errorDescrip];
        }
    }];
}

-(void)resetTableOffset:(BOOL)flag
{
    _tbAction.contentOffset = originalContentOffset;
    int height = _tbAction.contentSize.height;
    if (height < _tbAction.frame.size.height) {
        height = _tbAction.frame.size.height;
    }
    if (flag) {
        [UIView animateWithDuration:0.33 animations:^{
            if (_tbAction.contentInset.bottom > 0) {
                _tbAction.contentOffset = CGPointMake(0, height - _tbAction.contentInset.bottom);
            }
            else{
                _tbAction.contentOffset = CGPointMake(0, height - _tbAction.frame.size.height);
            }
        } completion:^(BOOL finished) {
            //nil
        }];
    }
    else{
        if (_tbAction.contentInset.bottom > 0) {
            _tbAction.contentOffset = CGPointMake(0, height - _tbAction.contentInset.bottom);
        }
        else{
            _tbAction.contentOffset = CGPointMake(0, height - _tbAction.frame.size.height);
        }
    }
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
    //do something
}

- (IBAction)onButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods)
        return;
    if (!dataArray) {
        dataArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [dataArray indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
            if ([[(FSCoreMyLetter *)obj1 valueForKey:@"id"] intValue] ==[[(FSCoreMyLetter *)obj valueForKey:@"id"] intValue])
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
                [dataArray addObject:obj];
            }
            else
            {
                [dataArray insertObject:obj atIndex:0];
            }
        }
    }];
}

- (void) displayCommentInputView
{
    if (!commentView)
    {
        commentView = [[[NSBundle mainBundle] loadNibNamed:@"FSProCommentInputView" owner:self options:nil] objectAtIndex:1];
        CGFloat height = PRIVATE_LETTER_TOOLBAR_HEIGHT;
        commentView.frame = CGRectMake(0, SCREEN_HIGH - 20 - NAV_HIGH - height, self.view.frame.size.width, height);
        commentView.txtComment.delegate = self;
        
        [commentView.btnComment addTarget:self action:@selector(saveComment:) forControlEvents:UIControlEventTouchUpInside];
        [commentView.btnCancel addTarget:self action:@selector(clearComment:) forControlEvents:UIControlEventTouchUpInside];
        commentView.btnComment.showsTouchWhenHighlighted = YES;
        
        [self.view addSubview:commentView];
        commentView.tag = PRIVATE_LETTER_COMMENT_INPUT_TAG;
    }
}

-(void) hideCommentInputView
{
    //如果commentInput不为空，则
    if (commentView)
    {
        commentView.txtComment.text = @"";
        [commentView.txtComment resignFirstResponder];
    }
}

-(void)clearComment:(UIButton *)sender
{
    //隐藏输入区域
    [self hideCommentInputView];
}

-(void)saveComment:(UIButton *)sender
{
    if (_isSending) {
        return;
    }
    NSString *trimedText = [commentView.txtComment.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([NSString isNilOrEmpty:trimedText]) {
        return;
    }
    //request Data
    FSPLetterRequest * request=[[FSPLetterRequest alloc] init];
    request.routeResourcePath = RK_REQUEST_MY_PLETTER_SAY;
    request.touchUser = _touchUser.uid;
    request.textmsg = trimedText;
    request.userToken = [FSModelManager sharedModelManager].loginToken;
    _isSending = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [request send:[FSCoreMyLetter class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        if (resp.isSuccess)
        {
            FSCoreMyLetter *result = resp.responseData;
            [result show];
            if (!dataArray) {
                dataArray = [NSMutableArray arrayWithCapacity:5];
            }
            FSCoreMyLetter *result1 = [FSCoreMyLetter findLetterByConversationId:result.id];
            if (result1) {
                [self fillDataArray:[NSArray arrayWithObject:result1] isInsert:NO];
                originalContentOffset = _tbAction.contentOffset;
                [_tbAction beginUpdates];
                NSArray *insert = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:dataArray.count - 1 inSection:0]];
                [_tbAction insertRowsAtIndexPaths:insert withRowAnimation:UITableViewRowAnimationBottom];
                [_tbAction endUpdates];
                commentView.txtComment.text = @"";
                [result1 show];
                _lastConversationId = result1.id;
            }
            [self resetTableOffset:YES];
        }
        else
        {
            [self hideCommentInputView];
            [self reportError:resp.errorDescrip];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _isSending = NO;
    }];
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
//    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
//    [_dic setValue:@"我的评论列表页" forKey:@"来源页面"];
//    [[FSAnalysis instance] logEvent:CHECK_DAREN_DETAIL withParameters:_dic];
}

#pragma mark - UITableViewSource delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideCommentInputView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

#define My_Letter_To_Cell_Indentifier @"FSMyLetterToCell"
#define My_Letter_From_Cell_Indetifier @"FSMyLetterFromCell"

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCoreMyLetter *item = [dataArray objectAtIndex:indexPath.row];
    int _id = item.fromuser.uid;
    if (_id != [[FSModelManager sharedModelManager].localLoginUid intValue] && _id != 0) {
        FSMyLetterToCell *cellMy = (FSMyLetterToCell*)[tableView dequeueReusableCellWithIdentifier:My_Letter_To_Cell_Indentifier];
        if (cellMy == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSMyCommentCell" owner:self options:nil];
            if (_array.count > 2) {
                cellMy = (FSMyLetterToCell*)_array[2];
            }
            else{
                cellMy = [[FSMyLetterToCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:My_Letter_To_Cell_Indentifier];
            }
        }
        cellMy.accessoryType = UITableViewCellAccessoryNone;
        cellMy.selectionStyle = UITableViewCellSelectionStyleNone;
        cellMy.imgThumb.delegate = self;
        [cellMy setData:item];
        
        return cellMy;
    }
    else{
        FSMyLetterFromCell *cellMy = (FSMyLetterFromCell*)[tableView dequeueReusableCellWithIdentifier:My_Letter_From_Cell_Indetifier];
        if (cellMy == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSMyCommentCell" owner:self options:nil];
            if (_array.count > 3) {
                cellMy = (FSMyLetterFromCell*)_array[3];
            }
            else{
                cellMy = [[FSMyLetterFromCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:My_Letter_From_Cell_Indetifier];
            }
        }
        cellMy.accessoryType = UITableViewCellAccessoryNone;
        cellMy.selectionStyle = UITableViewCellSelectionStyleNone;
        cellMy.imgThumb.delegate = self;
        [cellMy setData:item];
        
        return cellMy;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FSCoreMyLetter *item = [dataArray objectAtIndex:indexPath.row];
    if (item.fromuser.uid == [_touchUser.uid intValue]) {
        FSMyLetterToCell *cell = (FSMyLetterToCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else{
        FSMyLetterFromCell *cell = (FSMyLetterFromCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
}

#pragma mark - UIKeyboardWillShowNotification & UIKeyboardWillHideNotification

- (void)keyboardWillShow:(NSNotification*)notification {
    _keyboardRect = [[[notification userInfo] objectForKey:_UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (!_priorInsetSaved) {
        _priorInset = _tbAction.contentInset;
        _priorInsetSaved = YES;
    }
    CGRect keyboardRect = [self keyboardRect];
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        _tbAction.contentInset = [self contentInsetForKeyboard];
        [_tbAction setContentOffset:CGPointMake(0, _tbAction.contentSize.height + keyboardRect.size.height - _tbAction.frame.size.height) animated:NO];
        [_tbAction setScrollIndicatorInsets:_tbAction.contentInset];
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    _keyboardRect = CGRectZero;
    [UIView animateWithDuration:[[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
        _tbAction.contentInset = _priorInset;
        _priorInsetSaved = NO;
        [_tbAction setScrollIndicatorInsets:_tbAction.contentInset];
    } completion:^(BOOL finished) {
    }];
}

- (UIEdgeInsets)contentInsetForKeyboard {
    UIEdgeInsets newInset = _tbAction.contentInset;
    CGRect keyboardRect = [self keyboardRect];
    newInset.bottom = keyboardRect.size.height - ((keyboardRect.origin.y+keyboardRect.size.height) - (_tbAction.bounds.origin.y+_tbAction.bounds.size.height));
    return newInset;
}

- (CGRect)keyboardRect {
    CGRect keyboardRect = [_tbAction convertRect:_keyboardRect fromView:nil];
    if ( keyboardRect.origin.y == 0 ) {
        CGRect screenBounds = [_tbAction convertRect:[UIScreen mainScreen].bounds fromView:nil];
        keyboardRect.origin = CGPointMake(0, screenBounds.size.height - keyboardRect.size.height);
    }
    //keyboardRect.size.height += PRIVATE_LETTER_TOOLBAR_HEIGHT;
    
    return keyboardRect;
}

@end
