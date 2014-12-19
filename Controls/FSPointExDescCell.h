//
//  FSPointExDescCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-2.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSExchange.h"
#import "FSCommon.h"
#import "RTLabel.h"

@interface FSPointExDescCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UILabel *activityTime;
@property (strong, nonatomic) IBOutlet UILabel *useTime;
@property (strong, nonatomic) IBOutlet UILabel *joinStore;
@property (strong, nonatomic) IBOutlet UILabel *joinStoreTitle;
@property (strong, nonatomic) IBOutlet UILabel *useScope;
@property (strong, nonatomic) IBOutlet UIButton *useScopeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *line1;
@property (strong, nonatomic) IBOutlet UIImageView *line2;

@property (nonatomic) int cellHeight;
@property (nonatomic, strong) FSExchange* data;

@end

@interface FSPointExDoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *selStoreBtn;
@property (strong, nonatomic) IBOutlet UILabel *remainPoint;
@property (strong, nonatomic) IBOutlet UITextField *pointExField;
@property (strong, nonatomic) IBOutlet UILabel *exMoney;
@property (strong, nonatomic) IBOutlet UITextField *idCardField;
@property (strong, nonatomic) IBOutlet UIButton *exBtn;
@property (strong, nonatomic) IBOutlet UILabel *pointTipLb;
@property (strong, nonatomic) IBOutlet UILabel *unitPerPoint;

@property (nonatomic) int cellHeight;
@property (nonatomic, strong) FSExchange* data;

@end

@interface FSPointExCommonCell : UITableViewCell<PSUICollectionViewDelegate, PSUICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *line1;
@property (strong, nonatomic) IBOutlet UILabel *titleView;
@property (strong, nonatomic) IBOutlet UIImageView *line2;
@property (strong, nonatomic) IBOutlet UILabel *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *desc;
@property (strong, nonatomic) IBOutlet PSUICollectionView *additionalView;
@property (nonatomic) BOOL hasAddionalView;
@property (nonatomic,strong) FSExchange *changeDaga;

@property (nonatomic) int cellHeight;
-(void)setData;

@end

//礼券使用范围Cell
@interface FSPointScopeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *useScope;


@property (nonatomic) int cellHeight;
@property (nonatomic, strong) FSCommon* data;

@end

//礼券兑换成功Cell
@interface FSPointExSuccessCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *giftNumber;
@property (strong, nonatomic) IBOutlet UILabel *exTime;
@property (strong, nonatomic) IBOutlet UILabel *stopTime;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *pointCount;
@property (strong, nonatomic) IBOutlet UILabel *moneyCount;

@property (nonatomic) int cellHeight;
@property (nonatomic, strong) FSExchangeSuccess* data;

@end
