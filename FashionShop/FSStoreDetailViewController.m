//
//  FSStoreDetailViewController.m
//  FashionShop
//
//  Created by gong yi on 1/4/13.
//  Copyright (c) 2013 Fashion. All rights reserved.
//

#import "FSStoreDetailViewController.h"
#import <MapKit/MapKit.h>
#import "FSLocationManager.h"
#import "UIImageView+WebCache.h"
#import "FSStoreMapViewController.h"
#import "PositionAnnotation.h"
#import "FSProListRequest.h"
#import "FSProItems.h"
#import "FSStoreDetailCell.h"
#import "FSProNearDetailCell.h"
#import "FSStoreDetailRequest.h"

#define kMKCoordinateSpan 0.005

@interface FSStoreDetailViewController ()
{
    UIImageView *_picImage;
    UIImageView *_picArrow;
    NSMutableArray *_promotions;
    BOOL _isInLoading;
    bool _noMoreResult;
    int _currentPage;
    BOOL _isExpandOfDesc;
    FSStore *_store;
}

@end

@implementation FSStoreDetailViewController

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
    
    UIBarButtonItem *baritemCancel = [self createPlainBarButtonItem:@"goback_icon.png" target:self action:@selector(onButtonBack:)];
    [self.navigationItem setLeftBarButtonItem:baritemCancel];
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    _tbAction.hidden = YES;
    if(IOS7 && _pController) {
        CGRect _rect = _tbAction.frame;
        _rect.origin.y += NAV_HIGH;
        _rect.size.height -= NAV_HIGH;
        _tbAction.frame = _rect;
    }
    
    if (!_picImage) {
        _picImage = [[UIImageView alloc] init];
        _picImage.frame = CGRectMake(0, 0, 320, 200);
        _picImage.clipsToBounds = YES;
    }
    _picImage.contentMode = UIViewContentModeScaleAspectFill;
    _picImage.image = [UIImage imageNamed:@"default_icon320.png"];
    
    _currentPage = 1;
    [self requestDetailData];
}

-(void)requestDetailData
{
    //请求店铺详情数据
    FSStoreDetailRequest *storeRequest = [[FSStoreDetailRequest alloc] init];
    storeRequest.routeResourcePath = REQUEST_STORE_DETAIL;
    storeRequest.longit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.longitude];
    storeRequest.lantit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    storeRequest.storeid = _storeID;
    [self beginLoading:self.view];
    _isInLoading = YES;
    [storeRequest send:[FSStore class] withRequest:storeRequest completeCallBack:^(FSEntityBase *respData) {
        if (respData.isSuccess)
        {
            _store = respData.responseData;
            [self requestData:NO];
        }
        else
        {
            _isInLoading = NO;
            [self endLoading:self.view];
            [self reportError:respData.errorDescrip];
        }
    }];
}

-(void)requestData:(BOOL)isLoadMore
{   
    //请求店铺列表数据
    FSProListRequest *request = [[FSProListRequest alloc] init];
    request.requestType = 1;
    request.routeResourcePath = RK_REQUEST_PRO_LIST;
    request.pageSize = COMMON_PAGE_SIZE;
    request.filterType = FSProSortByDist;
    request.longit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.longitude];
    request.lantit = [NSNumber numberWithDouble:[FSLocationManager sharedLocationManager].currentCoord.latitude];
    request.previousLatestDate = [NSDate date];
    request.nextPage = _currentPage + (isLoadMore?1:0);
    request.storeid = _store.id;
    if (isLoadMore) {
        [self beginLoadMoreLayout:_tbAction];
    }
    _isInLoading = YES;
    __block FSStoreDetailViewController *blockSelf = self;
    [request send:[FSProItems class] withRequest:request completeCallBack:^(FSEntityBase *respData) {
        _isInLoading = NO;
        if (!isLoadMore) {
            [self endLoading:self.view];
        }
        else{
            [self endLoadMore:_tbAction];
        }
        if (!respData.isSuccess) {
            [blockSelf reportError:respData.errorDescrip];
        }
        else{
            FSProItems *response = (FSProItems *) respData.responseData;
            _currentPage += isLoadMore?1:0;
            if (response.totalPageCount <= _currentPage)
                _noMoreResult = YES;
            [blockSelf fillProdInMemory:response.items isInsert:NO];
            
            if (_tbAction.hidden) {
                _tbAction.hidden = NO;
            }
        }
    }];
}

-(void) fillProdInMemory:(NSArray *)prods isInsert:(BOOL)isinserted
{
    if (!prods)
        return;
    if (!_promotions) {
        _promotions = [NSMutableArray array];
    }
    [prods enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int index = [_promotions indexOfObjectPassingTest:^BOOL(id obj1, NSUInteger idx1, BOOL *stop1) {
            if ([[(FSProItemEntity *)obj1 valueForKey:@"id"] intValue] ==[[(FSProItemEntity *)obj valueForKey:@"id"] intValue])
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
                [_promotions addObject:obj];
            } else
            {
                [_promotions insertObject:obj atIndex:0];
            }
        }
    }];
    [_tbAction reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    
    if (!_noMoreResult &&
        !_isInLoading &&
        (scrollView.contentOffset.y+scrollView.frame.size.height) + 200 > scrollView.contentSize.height
        && scrollView.contentSize.height>scrollView.frame.size.height
        &&scrollView.contentOffset.y>0)
    {
        [self requestData:YES];
    }
}

- (IBAction)onButtonBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToDial:(id)sender
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", _store.phone]];
	[[UIApplication sharedApplication] openURL:url];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:4];
    [_dic setValue:_store.phone forKey:@"电话号码"];
    [_dic setValue:_store.name forKey:@"实体店名称"];
    [_dic setValue:[NSString stringWithFormat:@"%d", _store.id] forKey:@"实体店ID"];
    [_dic setValue:@"实体店详情页" forKey:@"来源页面"];
    [[FSAnalysis instance] logEvent:DIAL_STORE_PHONE withParameters:_dic];
}

- (void)viewDidUnload {
    [self setTbAction:nil];
    [super viewDidUnload];
}

-(void)clickToExpandDescContent:(NSArray*)array
{
    _isExpandOfDesc = !_isExpandOfDesc;
    [_tbAction reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    
    CGAffineTransform  transform;
    //设置旋转度数
    if (!_isExpandOfDesc) {
        transform = CGAffineTransformRotate(_picArrow.transform,-M_PI);
        [_picArrow setTransform:transform];
    }
    transform = CGAffineTransformRotate(_picArrow.transform,M_PI);
    //动画开始
    [UIView beginAnimations:@"rotate" context:nil ];
    //动画时常
    [UIView setAnimationDuration:0.33];
    //添加代理
    [UIView setAnimationDelegate:self];
    //获取transform的值
    [_picArrow setTransform:transform];
    //关闭动画
    [UIView commitAnimations];
}

-(void)clickToMoreProduct:(UIButton*)sender
{
    FSProductListViewController *dr = [[FSProductListViewController alloc] initWithNibName:@"FSProductListViewController" bundle:nil];
    dr.store = _store;
    dr.keyWords = _store.name;
    dr.pageType = FSPageTypeStore;
    dr.titleName = dr.keyWords;
    if (_pController) {
        dr.pViewController = self;
    }
    [self.navigationController pushViewController:dr animated:YES];
    
    //统计
    NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic setValue:@"实体店详情页" forKey:@"来源"];
    [[FSAnalysis instance] logEvent:CHECK_PRODUCT_LIST withParameters:_dic];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSStoreDetailCell" owner:self options:nil];
        if (_array.count > 1) {
           FSStoreProHeadView *view = (FSStoreProHeadView*)_array[1];
            [view.moreProductBtn addTarget:self action:@selector(clickToMoreProduct:) forControlEvents:UIControlEventTouchUpInside];
            return view;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return 200;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
            case 2:
            {
                FSStoreDescCell *cell = (FSStoreDescCell*)[tableView.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
                int height = _isExpandOfDesc?cell.cellHeight_Expand:cell.cellHeight_Contract;
                return height;
            }
                break;
            default:
                break;
        }
    }
    else{
        return 80;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                FSStoreMapViewController *controller = [[FSStoreMapViewController alloc] initWithNibName:@"FSStoreMapViewController" bundle:nil];
                controller.store = _store;
                [self.navigationController pushViewController:controller animated:YES];
                
                //统计
                NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:3];
                [_dic setValue:_store.name forKey:@"实体店名称"];
                [_dic setValue:[NSString stringWithFormat:@"%d", _store.id] forKey:@"实体店ID"];
                [_dic setValue:@"实体店详情页" forKey:@"来源页面"];
                [[FSAnalysis instance] logEvent:CHECK_STORE_MAP withParameters:_dic];
            }
                break;
            case 1:
            {
                [self clickToDial:nil];
            }
                break;
            case 2:
            {
                //收起或者展开详细描述内容
                [self clickToExpandDescContent:[NSArray arrayWithObjects:indexPath, nil]];
            }
                break;
            default:
                break;
        }
    }
    else{
        FSProDetailViewController *detailViewController = [[FSProDetailViewController alloc] initWithNibName:@"FSProDetailViewController" bundle:nil];
        detailViewController.navContext = _promotions;
        detailViewController.dataProviderInContext = self;
        detailViewController.indexInContext = indexPath.row;
        detailViewController.sourceType = FSSourcePromotion;
        UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:detailViewController];
        [self presentViewController:navControl animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:FALSE];
        
        //统计
        FSProItemEntity *item = [_promotions objectAtIndex:indexPath.row];
        NSMutableDictionary *_dic = [NSMutableDictionary dictionaryWithCapacity:5];
        [_dic setValue:item.title forKey:@"促销名称"];
        [_dic setValue:[NSString stringWithFormat:@"%d", item.id] forKey:@"促销ID"];
        [_dic setValue:item.store.name forKey:@"实体店名称"];
        [_dic setValue:@"实体店详情页" forKey:@"来源页面"];
        [_dic setValue:item.startDate forKey:@"发布时间"];
        [[FSAnalysis instance] logEvent:CHECK_PROLIST_DETAIL withParameters:_dic];
        
        [[FSAnalysis instance] autoTrackPages:navControl];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    return _promotions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0://图片展现
            {
                NSString *picCell = @"UITableViewCell_Pic";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:picCell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:picCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [_picImage setImageWithURL:_store.storeLogoBg placeholderImage:nil];//[UIImage imageNamed:@"图形1bb.png"]
                [cell addSubview:_picImage];
                return cell;
            }
                break;
            case 1://店名和电话
            {
                NSString *phoneCell = @"UITableViewCell_Phone";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCell];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:phoneCell];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.text = _store.name;
                cell.textLabel.font = ME_FONT(16);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"联系电话: %@", _store.phone];
                cell.detailTextLabel.font = ME_FONT(14);
                return cell;
            }
                break;
            case 2://地址和描述
            {
                NSString *storeDescCell = @"FSStoreDescCell";
                FSStoreDescCell *cell = [tableView dequeueReusableCellWithIdentifier:storeDescCell];
                if (cell == nil) {
                    NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSStoreDetailCell" owner:self options:nil];
                    if (_array.count > 0) {
                        cell = (FSStoreDescCell*)_array[0];
                    }
                    else{
                        cell = [[FSStoreDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:storeDescCell];
                    }
                }
                _picArrow = cell.arrow;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.address.text = _store.address;
                [cell setDescData:_store.descrip];
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else{
        FSProNearDetailCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"FSProNearDetailCell"];
        if (listCell == nil) {
            NSArray *_array = [[NSBundle mainBundle] loadNibNamed:@"FSProNearDetailCell" owner:self options:nil];
            if (_array.count > 1) {
                listCell = (FSProNearDetailCell*)_array[0];
            }
            else{
                listCell = [[FSProNearDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FSProNearDetailCell"];
            }
        }
        listCell.contentView.backgroundColor = RGBCOLOR(125, 125, 125);
        listCell.lblTitle.textColor = [UIColor whiteColor];
        listCell.lblSubTitle.textColor = RGBCOLOR(179, 179, 179);
        listCell.line.backgroundColor = RGBCOLOR(160, 160, 160);
        listCell.line2.backgroundColor = RGBCOLOR(143, 143, 143);
        
        FSProItemEntity* proData = [_promotions objectAtIndex:indexPath.row];
        NSDateFormatter *smdf = [[NSDateFormatter alloc]init];
        [smdf setDateFormat:@"yyyy.MM.dd"];
        NSDateFormatter *emdf = [[NSDateFormatter alloc]init];
        [emdf setDateFormat:@"yyyy.MM.dd"];
        
        NSString * str = [NSString stringWithFormat:@"%@\n至\n%@\n", [smdf stringFromDate:proData.startDate], [emdf stringFromDate:proData.endDate]];
        
        [listCell setTitle:proData.title subTitle:proData.descrip dateString:str];
        
        return listCell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];;
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
    return FSSourcePromotion;
}

-(BOOL)proDetailViewNeedRefreshFromContext:(FSProDetailViewController *)view forIndex:(NSInteger)index
{
    return TRUE;
}

@end
