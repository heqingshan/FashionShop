//
//  FSMoreViewController.m
//  FashionShop
//
//  Created by HeQingshan on 13-4-27.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSMoreViewController.h"
#import "FSNickieViewController.h"
#import "FSFeedbackViewController.h"
#import "FSCardBindViewController.h"
#import "FSAboutViewController.h"
#import "FSGiftListViewController.h"
#import "FSOrderListViewController.h"
#import "FSAddressManagerViewController.h"
#import "FSCommonRequest.h"
#import "FSCoreMyLetter.h"

@interface FSMoreViewController () {
    NSMutableArray *_titles;
    NSMutableArray *_icons;
}

@end

@implementation FSMoreViewController

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
    self.title = NSLocalizedString(@"More", nil);
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    _tbAction.tableFooterView = [self createTableFooterView];
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    _tbAction.backgroundView = nil;
    
    [self initTitlesArray];
    [self initIconsArray];
    
    //检测更新
    if (!theApp.versionData) {
        [self checkVersion:NO];
    }
}

-(void)initIconsArray
{
    _icons = [@[
              @[
                @"gift_icon.png",
                @"order_icon.png",
                ],//@"order_icon.png",
              @[
                @"eidit_icon.png",
                @"bindcard_icon.png",
                @"address_icon.png",
                ],//@"address_icon.png"
              @[
                @"feedback_icon.png",
                @"aboutyt_icon.png",
                @"checkversion_icon.png",
                @"write_icon.png",
                @"clean_icon.png"]
              ] mutableCopy];
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTitlesArray
{
    if (_titles) {
        return;
    }
    
    _titles = [@[
                @[
                    NSLocalizedString(@"Gift List", nil),
                    NSLocalizedString(@"Pre Order Title", nil),
                    ],//NSLocalizedString(@"Pre Order Title", nil)
                @[
                    NSLocalizedString(@"Edit Personal Info",nil),
                    ([_currentUser.isBindCard boolValue]?NSLocalizedString(@"Card Info Query", nil):NSLocalizedString(@"Bind Member Card",nil)),
                    NSLocalizedString(@"Address Manager", nil),
                    ],//NSLocalizedString(@"Address Manager", nil)
                @[
                    NSLocalizedString(@"FeedBack",nil),
                    NSLocalizedString(@"About Love Intime",nil),
                    NSLocalizedString(@"Check Version",nil),
                    NSLocalizedString(@"Like Intime",nil),
                    NSLocalizedString(@"Clear Cache",nil)]
               ] mutableCopy];
}

- (IBAction)clickToExit:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:NSLocalizedString(@"Exit Current Account", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    alert.tag = 101;
    [alert show];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"更多页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:USER_EXIT withParameters:_dic];
}

-(void)attentionXhyt:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ATTENTION_XHYT_URL]];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"更多页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:ATTETION_XHYT withParameters:_dic];
}

- (void)stopLoading
{
    [self endLoading:self.view];
}

-(UIView*)createTableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    view.backgroundColor = [UIColor clearColor];
    
    int xOffset = 49;
    int yOffset = 15;
    
    UIButton *btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAttention.frame = CGRectMake(xOffset, yOffset, 222, 40);
    [btnAttention setTitle:NSLocalizedString(@"Attention XHYT", nil) forState:UIControlStateNormal];
    [btnAttention setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAttention addTarget:self action:@selector(attentionXhyt:) forControlEvents:UIControlEventTouchUpInside];
    btnAttention.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    yOffset += btnAttention.frame.size.height + yOffset;
    
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.frame = CGRectMake(xOffset, yOffset, 222, 40);
    [btnExit setTitle:NSLocalizedString(@"USER_SETTING_LOGOUT", nil) forState:UIControlStateNormal];
    [btnExit setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnExit addTarget:self action:@selector(clickToExit:) forControlEvents:UIControlEventTouchUpInside];
    btnExit.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [view addSubview:btnAttention];
    [view addSubview:btnExit];
    
    return view;
}

//进行版本检测
-(void)checkVersion:(BOOL)needAlert
{
    //请求网络数据，此处可更改为版本更新检查
    FSCommonRequest *request = [[FSCommonRequest alloc] init];
    [request setRouteResourcePath:RK_REQUEST_CHECK_VERSION];
    [request send:[FSCommon class] withRequest:request completeCallBack:^(FSEntityBase *resp) {
        if (resp.isSuccess)
        {
            theApp.versionData = resp.responseData;
            [_tbAction reloadData];
            if (needAlert) {
                if (theApp.versionData.type > 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:theApp.versionData.title message:theApp.versionData.desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    alert.tag = 102;
                    [alert show];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:theApp.versionData.title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
            [_dic setValue:theApp.versionData.version forKey:@"版本号"];
            [_dic setValue:@"更多页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_VERSION withParameters:_dic];
        }
    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_titles || section >= _titles.count) {
        return 0;
    }
    return [[_titles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MoreCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array = [_icons objectAtIndex:indexPath.section];
    cell.imageView.image = [UIImage imageNamed:[array objectAtIndex:indexPath.row]];
    array = [_titles objectAtIndex:indexPath.section];
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"181818"];
    cell.textLabel.font = ME_FONT(15);
    if (indexPath.section == 2 &&
        indexPath.row + indexPath.section * 10 == FSMoreCheckVersion) {
        if (theApp.versionData && theApp.versionData.type > 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"发现新版本V%@", theApp.versionData.version];
            cell.detailTextLabel.font = ME_FONT(12);
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#e4007f"];
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titles.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row + indexPath.section * 10) {
        case FSMoreGift:
        {
            FSGiftListViewController *couponView = [[FSGiftListViewController alloc] initWithNibName:@"FSGiftListViewController" bundle:nil];
            couponView.currentUser = _currentUser;
            [self.navigationController pushViewController:couponView animated:true];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"更多页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_ORDER_LIST withParameters:_dic];
        }
            break;
        case FSMoreOrder:
        {
            FSOrderListViewController *orderView = [[FSOrderListViewController alloc] initWithNibName:@"FSOrderListViewController" bundle:nil];
            [self.navigationController pushViewController:orderView animated:true];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"更多页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CHECK_GIFT_LIST withParameters:_dic];
        }
            break;
        case FSMoreEdit:    //编辑个人资料
        {
            FSNickieViewController *nickieController = [[FSNickieViewController alloc] initWithNibName:@"FSNickieViewController" bundle:nil];
            nickieController.currentUser = _currentUser;
            [self.navigationController pushViewController:nickieController animated:true];
        }
            break;
        case FSMoreBindCard: //会员卡绑定和会员卡积点查询
        {
            FSCardBindViewController *con = [[FSCardBindViewController alloc] initWithNibName:@"FSCardBindViewController" bundle:nil];
            con.currentUser = _currentUser;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
        case FSMoreAddress:
        {
            FSAddressManagerViewController *addressView = [[FSAddressManagerViewController alloc] initWithNibName:@"FSAddressManagerViewController" bundle:nil];
            addressView.pageFrom = 1;
            [self.navigationController pushViewController:addressView animated:true];
        }
            break;
        case FSMoreFeedback:    //意见反馈
        {
            FSFeedbackViewController *feedbackController = [[FSFeedbackViewController alloc] initWithNibName:@"FSFeedbackViewController" bundle:nil];
            feedbackController.currentUser = _currentUser;
            [self.navigationController pushViewController:feedbackController animated:true];
        }
            break;
        case FSMoreAbout:
        {
            FSAboutViewController *controller = [[FSAboutViewController alloc] initWithNibName:@"FSAboutViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:true];
        }
            break;
        case FSMoreCheckVersion:
        {
            if (!theApp.versionData) {
                [self checkVersion:YES];
            }
            else{
                if (theApp.versionData.type > 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:theApp.versionData.title message:theApp.versionData.desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                    alert.tag = 102;
                    [alert show];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:theApp.versionData.title delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                //统计
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:2];
                [_dic setValue:theApp.versionData.version forKey:@"版本号"];
                [_dic setValue:@"更多页" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:CHECK_VERSION withParameters:_dic];
            }
        }
            break;
        case FSMoreLike:    //去appstore评论
        {
            if (!_currentUser.appID || [_currentUser.appID isEqualToString:@""]) {
                _currentUser.appID = @"615975780";
            }
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",_currentUser.appID];
//            if (IOS7) {
//                str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/guang-dian-bi-zhi/id%@?mt=8", _currentUser.appID];
//            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"更多页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:LIKE_XHYT withParameters:_dic];
        }
            break;
        case FSMoreClear:   //清理缓存
        {
            [self beginLoading:self.view];
            [[FSModelManager sharedModelManager] clearCache];
            [FSCoreMyLetter cleanMessage];
            [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0f];
            
            //统计
            NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic setValue:@"更多页" forKey:@"来源页面"];
            [[FSAnalysis instance] logEvent:CLEAR_CACHE withParameters:_dic];
        }
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101 && buttonIndex == 1) {
        [FSUser removeUserProfile];
        if (_delegate)
        {
            [_delegate settingView:self didLogOut:true];
        }
        [self reportError:NSLocalizedString(@"COMM_OPERATE_COMPL", nil)];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 102 && buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theApp.versionData.downLoadURL]];
    }
}

@end
