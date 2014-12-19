//
//  FSPointExDescCell.m
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSPointExDescCell.h"
#import "FSScopeCell.h"

@implementation FSPointExDescCell

-(void)setData:(id)data
{
    _data = data;
    int yCap = 12;
    _cellHeight = yCap;
    
    //title
    NSString *str = @"活动描述";
    [_titleView setText:str];
    CGRect _rect = _titleView.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 99;
    _titleView.frame = _rect;
    [_titleView sizeToFit];
    _cellHeight += _titleView.frame.size.height + yCap;
    
    //line1
    _rect = _line1.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 1;
    _line1.frame = _rect;
    _cellHeight += _rect.size.height + yCap;
    
    //活动时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy年MM月dd日"];
    str = [NSString stringWithFormat:@"活动时间 : %@ 至 %@", [df stringFromDate:_data.activeStartDate], [df stringFromDate:_data.activeEndDate]];
    [_activityTime setText:str];
    _activityTime.textColor = [UIColor colorWithHexString:@"#666666"];
    _rect = _activityTime.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 100;
    _activityTime.frame = _rect;
    [_activityTime sizeToFit];
    _cellHeight += _activityTime.frame.size.height + yCap;
    
    //使用有效期
    str = [NSString stringWithFormat:@"使用有效期 : %@止", [df stringFromDate:_data.couponEndDate]];
    [_useTime setText:str];
    _useTime.textColor = [UIColor colorWithHexString:@"#666666"];
    _rect = _useTime.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 100;
    _useTime.frame = _rect;
    [_useTime sizeToFit];
    _cellHeight += _useTime.frame.size.height + yCap;
    
    //参与门店title
    _rect = _joinStoreTitle.frame;
    _rect.origin.y = _cellHeight;
    _joinStoreTitle.frame = _rect;
    
    //参与门店
    NSMutableString *storeDesc = [NSMutableString string];
    for (int i = 0; i < _data.inscopenotices.count; i++) {
        FSCommon *com = _data.inscopenotices[i];
        if (i != _data.inscopenotices.count - 1) {
            [storeDesc appendFormat:@"%@\n", com.storename];
        }
        else{
            [storeDesc appendFormat:@"%@", com.storename];
        }
    }
    str = [NSString stringWithFormat:@"%@", storeDesc];
    [_joinStore setText:str];
    _rect = _joinStore.frame;
    _rect.origin.y = _cellHeight + 4;
    _rect.origin.x = 90;
    _rect.size.width = 210;
    _rect.size.height = 100;
    _joinStore.frame = _rect;
    [_joinStore sizeToFit];
    _cellHeight += _joinStore.frame.size.height + yCap + 3;
    
    //礼券使用范围
    str = [NSString stringWithFormat:@"礼券使用范围  "];
    [_useScope setText:str];
    _rect = _useScope.frame;
    _rect.origin.y = _cellHeight;
    _useScope.frame = _rect;
    [_useScope sizeToFit];
    _cellHeight += _useScope.frame.size.height + yCap;
    
    _rect = _useScopeBtn.frame;
    _rect.origin.y = _useScope.frame.origin.y - (_rect.size.height - _useScope.frame.size.height)/2;
    _rect.origin.x = _useScope.frame.origin.x + _useScope.frame.size.width;
    _useScopeBtn.frame = _rect;
    
    //line2
    _rect = _line2.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 1;
    _line2.frame = _rect;
    _cellHeight += _rect.size.height;
}

@end

@implementation FSPointExDoCell

-(void)setData:(id)data
{
    _data = data;
    [_exBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg.png"] forState:UIControlStateNormal];
    [_exBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg_sel.png"] forState:UIControlStateHighlighted];
    _pointTipLb.text = [NSString stringWithFormat:@"起兑积点:%d", _data.minPoints];
    _unitPerPoint.text = [NSString stringWithFormat:@"注意：兑换的积点必须是%d的整数倍", _data.unitPerPoints];
    UIEdgeInsets insert = _selStoreBtn.contentEdgeInsets;
    _selStoreBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    _selStoreBtn.titleLabel.minimumFontSize = 10;
    insert.right = 25;
    _selStoreBtn.contentEdgeInsets = insert;
}

@end

@interface FSPointExCommonCell()
{
    NSMutableArray *array;
}

@end

@implementation FSPointExCommonCell

-(void)setData
{
    int yCap = 12;
    _cellHeight = 0;
    
    //title
    NSString *str = _title;
    [_titleView setText:str];
    [_titleView setTextColor:[UIColor colorWithHexString:@"#181818"]];
    [_titleView setFont:[UIFont boldSystemFontOfSize:16]];
    CGRect _rect = _titleView.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = _titleView.frame.size.height;
    _titleView.frame = _rect;
    _cellHeight += _rect.size.height;
    
    //line2
    _rect = _line2.frame;
    _rect.origin.y = _cellHeight;
    _rect.size.height = 1;
    _line2.frame = _rect;
    _cellHeight += _rect.size.height + yCap;
    
    [_content setText:_desc];
    _rect = _content.frame;
    _rect.origin.y = _cellHeight;
    _content.frame = _rect;
    [_content sizeToFit];
    NSLog(@"_content height:%.2f\n_desc:%@", _content.frame.size.height, _desc);
    _cellHeight += _content.frame.size.height + yCap;
    
    if (_hasAddionalView) {
        if (!array) {
            [self initArray];
        }
        if (!_additionalView.collectionViewLayout) {
            PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
            _additionalView.collectionViewLayout = layout;
            [_additionalView registerClass:[FSScopeCell class] forCellWithReuseIdentifier:@"FSScopeCell"];
        }
        
        _additionalView.hidden = NO;
        _additionalView.frame = CGRectMake(10, _cellHeight, 300, (_changeDaga.rules.count+1)*30);
        _additionalView.backgroundColor = [UIColor clearColor];
        _additionalView.showsHorizontalScrollIndicator = NO;
        _additionalView.showsVerticalScrollIndicator = NO;
        _additionalView.scrollEnabled = NO;
        _additionalView.delegate = self;
        _additionalView.dataSource = self;
        _cellHeight += _additionalView.frame.size.height + 8;
        
        [_additionalView reloadData];
    }
    else{
        _additionalView.hidden = YES;
    }
}

-(void)initArray
{
    array = [NSMutableArray array];
    [array addObject:@"起始积点"];
    [array addObject:@"结束积点"];
    [array addObject:@"兑换比例(100:1)"];
    for (int i = 0; i < _changeDaga.rules.count; i++) {
        FSCommon *item = _changeDaga.rules[i];
        [array addObject:[NSString stringWithFormat:@"%@", item.rangefrom]];
        [array addObject:[NSString stringWithFormat:@"%@", item.rangeto]];
        [array addObject:[NSString stringWithFormat:@"%@", item.ratio]];
    }
}

#pragma mark - PSUICollectionView Datasource && PSUICollectionViewDelegate

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (PSUICollectionView *)collectionView {
    return 1;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FSScopeCell" forIndexPath:indexPath];
    [(FSScopeCell *)cell setContent:array[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(PSTCollectionView *)collectionView layout:(PSTCollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 20);
}

@end

@implementation FSPointScopeCell

-(void)setData:(id)data
{
    _data = data;
    int yCap = 12;
    _cellHeight = yCap;
    
    //title
    NSString *str = [NSString stringWithFormat:@"使用门店 : %@", _data.storename];
    [_storeName setText:str];
    CGRect _rect = _storeName.frame;
    _rect.origin.y = _cellHeight;
    _storeName.frame = _rect;
    [_storeName sizeToFit];
    _cellHeight += _rect.size.height + yCap - 6;
    
    str = [NSString stringWithFormat:@"使用范围 : %@",_data.excludes];
    [_useScope setText:str];
    _rect = _useScope.frame;
    _rect.origin.y = _cellHeight;
    _useScope.frame = _rect;
    [_useScope sizeToFit];
    _cellHeight += _useScope.frame.size.height + yCap;
}

@end

//礼券兑换成功Cell
@implementation FSPointExSuccessCell

-(void)setData:(id)data
{
    _data = data;
    _giftNumber.text = _data.giftCode;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yy年MM月dd日 HH:mm:ss"];
    _exTime.text = [NSString stringWithFormat:@"%@", [df stringFromDate:_data.createDate]];
    [df setDateFormat:@"yy年MM月dd日"];
    _stopTime.text = [NSString stringWithFormat:@"%@止", [df stringFromDate:_data.validEndDate]];
    _storeName.text = _data.storeName;
    _pointCount.text = [NSString stringWithFormat:@"%d", _data.points];
    _moneyCount.text = [NSString stringWithFormat:@"%.2f元", _data.amount];
    [_moneyCount setTextColor:[UIColor colorWithHexString:@"#e5004f"]];
}

@end