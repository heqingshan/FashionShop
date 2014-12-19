//
//  FSProPostMainViewController.m
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSProPostMainViewController.h"
#import "FSCommonProRequest.h"
#import "UIImageView+WebCache.h"
#import "FSStore.h"
#import "FSBrand.h"
#import "FSGroupBrand.h"
#import "FSCoreBrand.h"
#import "FSProPostTitleViewController.h"
#import "FSPostTableSelViewController.h"
#import "FSProItemEntity.h"
#import "FSCoreStore.h"
#import "FSImageUploadCell.h"
#import "NSString+Extention.h"
#import "FSPurchase.h"
#import "FSTableMultiSelViewController.h"
#import "JSONKit.h"

#define EXIT_ALERT_TAG 1011
#define SAVE_INFO_TAG 1012
#define FILL_PRODUCT_CODE 1013


@interface FSProPostMainViewController ()
{
    FSCommonProRequest  *_proRequest;
    NSMutableArray *_sections;
    NSMutableArray *_keySections;
    NSMutableDictionary *_rows;
    NSMutableDictionary *_rowDone;
    NSMutableArray *_properties;
    BOOL _originalTabbarStatus;
    
    TDDatePickerController* _datePicker;
    TDDatePickerController* _dateEndPicker;
    FSProPostTitleViewController *_titleSel;
    UIImagePickerController *camera;
    int _dateRowIndex;
    
    PostFields _availFields;
    PostFields _mustFields;
    int _totalFields;
    NSString * _route;
    
    FSMyPickerView *paywayPickerView;
}

@end

@implementation FSProPostMainViewController
@synthesize currentUser;

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
    if (self.navigationItem)
    {
        UIBarButtonItem *baritemCancel= [self createPlainBarButtonItem:@"goback_icon" target:self action:@selector(onButtonCancel)];
        UIBarButtonItem *baritemSet= [self createPlainBarButtonItem:@"ok_icon" target:self action:@selector(doSave)];
        [self.navigationItem setLeftBarButtonItem:baritemCancel];
        [self.navigationItem setRightBarButtonItem:baritemSet];
        [baritemSet setEnabled:false];
        
    }
    [self initActionsSource];
    [self bindControl];
}

-(void) initActionsSource
{
    /*
    _keySections = [@[NSLocalizedString(@"PRO_POST_IMG_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_SALE_LABEL", nil),
                    NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil)
                    ] mutableCopy];
     */
    _keySections = [@[NSLocalizedString(@"PRO_POST_IMG_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil),
                    NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil)
                    ] mutableCopy];
    _sections = [@[] mutableCopy];
    _totalFields = 0;
    if (_availFields & ImageField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_IMG_LABEL", Nil)];
        if (_mustFields & ImageField)
            _totalFields++;
    }
    if (_availFields & TitleField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil)];
         if (_mustFields & TitleField)
             _totalFields++;
    }
    if (_availFields & DurationField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil)];
         if (_mustFields & DurationField)
             _totalFields+=2;
    }
    if (_availFields & BrandField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil)];
         if (_mustFields & BrandField)
             _totalFields++;
    }
    if (_availFields & StoreField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil)];
        if (_mustFields & StoreField)
            _totalFields++;
    }
    if (_availFields & SaleField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_SALE_LABEL", nil)];
        if (_mustFields & SaleField)
            _totalFields++;
    }
    if (_availFields & TagField)
    {
        [_sections addObject:NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil)];
        if (_mustFields & TagField)
            _totalFields++;
    }
    /*
    _rows = [@{NSLocalizedString(@"PRO_POST_IMG_LABEL", Nil):NSLocalizedString(@"PRO_POST_IMG_NOTEXT", Nil),
             NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil):NSLocalizedString(@"PRO_POST_TITLE_NOTEXT", Nil),
            NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil):
                    [@[NSLocalizedString(@"PRO_POST_DURATION_STARTTEXT", Nil),NSLocalizedString(@"PRO_POST_DURATION_ENDTEXT", Nil)] mutableCopy],
            NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil):NSLocalizedString(@"PRO_POST_BRAND_NOTEXT", Nil),
            NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil):NSLocalizedString(@"PRO_POST_STORE_NOTEXT", Nil),
            NSLocalizedString(@"PRO_POST_SALE_LABEL", nil):NSLocalizedString(@"PRO_POST_SALE_NOTEXT", nil),
            NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil):NSLocalizedString(@"PRO_POST_TAG_NOTEXT", Nil),
            } mutableCopy];
     */
    _rows = [@{NSLocalizedString(@"PRO_POST_IMG_LABEL", Nil):NSLocalizedString(@"PRO_POST_IMG_NOTEXT", Nil),
             NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil):NSLocalizedString(@"PRO_POST_TITLE_NOTEXT", Nil),
             NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil):
             [@[NSLocalizedString(@"PRO_POST_DURATION_STARTTEXT", Nil),NSLocalizedString(@"PRO_POST_DURATION_ENDTEXT", Nil)] mutableCopy],
             NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil):NSLocalizedString(@"PRO_POST_BRAND_NOTEXT", Nil),
             NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil):NSLocalizedString(@"PRO_POST_STORE_NOTEXT", Nil),
             NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil):NSLocalizedString(@"PRO_POST_TAG_NOTEXT", Nil),
             } mutableCopy];
    _rowDone = [@{} mutableCopy];
}

-(void) setAvailableFields:(PostFields)fields
{
    _availFields = fields;
}

-(void) setMustFields:(PostFields)fields
{
    _mustFields = fields;
}

-(void) setRoute:(NSString *)route
{
    _route = route;
}

-(void)onButtonCancel
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt",nil) message:NSLocalizedString(@"Exit Upload", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    alert.tag = EXIT_ALERT_TAG;
    [alert show];
}

-(void) bindControl
{
    [self.view setBackgroundColor:[UIColor colorWithRed:229 green:229 blue:229]];
    [_tbAction setBackgroundView:nil];
    [_tbAction setBackgroundColor:[UIColor clearColor]];
    [_tbAction registerNib:[UINib nibWithNibName:@"FSImageUploadCell" bundle:nil] forCellReuseIdentifier:@"FSImageUploadCell"];
    [self setProgress:PostBegin withObject:nil];
    _tbAction.dataSource = self;
    _tbAction.delegate = self;
    _tbAction.backgroundView = nil;
    _tbAction.backgroundColor = APP_TABLE_BG_COLOR;
    _tbAction.contentOffset = CGPointMake(0, 0);
    [_tbAction reloadData];
}

-(void) clearData
{
    [_proRequest clean];
    [self initActionsSource];
    [self bindControl];
    [self updateSaveButton];
    
    //清空_titleSel里的内容
    [_titleSel cleanData];
}

-(void) internalDoSave:(dispatch_block_t) cleanup
{
    __block FSProPostMainViewController *blockSelf = self;
    [_proRequest upload:^{
        //如果是上传活动成功，则返回活动id，在客户端显示
        if (self.publishSource == FSSourcePromotion) {
            UIAlertView *_alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt", nil) message:[NSString stringWithFormat:NSLocalizedString(@"Take_Care_Invoice:%@", nil), _proRequest.pID] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [_alert show];
        }
        [blockSelf updateProgress:NSLocalizedString(@"COMM_OPERATE_COMPL",nil)];
        if (cleanup)
            cleanup();
        [blockSelf clearData];
    } error:^{
        [blockSelf updateProgress:NSLocalizedString(@"upload failed!", nil)];
        if (cleanup)
            cleanup();
    }];
}

-(void) doSave
{
    NSMutableString *error = [@"" mutableCopy];
    if (_publishSource == FSSourcePromotion) {
        if(![self validateDate:&error])
        {
            [self reportError:error];
            return;
        }
    }
    if (_publishSource == FSSourceProduct) {
        //判断货号是否填写
        if ([_proRequest.is4sale boolValue]) {
            if ([NSString isNilOrEmpty:_proRequest.upccode]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warm prompt",nil) message:NSLocalizedString(@"Fill Product Code", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
                alert.tag = FILL_PRODUCT_CODE;
                [alert show];
                return;
            }
        }
        //初始化property对象
        NSMutableArray *pArray = [NSMutableArray array];
        for (FSPurchaseSaleColorsItem *item in _properties) {
            NSMutableArray *array = [NSMutableArray array];
            for (FSPurchaseSaleColorsItem *sub in item.sizes) {
                if (sub.isChecked) {
                    [array addObject:sub.colorName];
                }
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
            [dic setValue:array forKey:@"values"];
            [dic setValue:item.colorName forKey:@"propertyname"];
            [pArray addObject:dic];
        }
        _proRequest.property = [pArray JSONString];
    }
    //做预发布
    NSMutableString *_msg = [NSMutableString string];
    [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Title:%@", nil), _proRequest.title];
    [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Desc:%@", nil), _proRequest.descrip];
    if (_publishSource == FSSourceProduct) {
        if (_proRequest.originalPrice && [_proRequest.originalPrice intValue] > 0) {
            [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Original_Price:%@", nil), _proRequest.originalPrice];
        }
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Price:%@", nil), _proRequest.price];
        if (![NSString isNilOrEmpty:_proRequest.upccode]) {
            [_msg appendFormat:NSLocalizedString(@"Upload_Preview_PCode:%@", nil), _proRequest.upccode];
        }
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_BrandName:%@", nil), _proRequest.brandName];
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_TagType:%@", nil), _proRequest.tagName];
        for (FSPurchaseSaleColorsItem *item in _properties) {
            NSMutableString *str = [NSMutableString string];
            for (FSPurchaseSaleColorsItem *subItem in item.sizes) {
                if (!subItem.isChecked) {
                    continue;
                }
                [str appendFormat:@"%@;", subItem.colorName];
            }
            [_msg appendFormat:@"%@:%@\n", item.colorName, str];
        }
        BOOL flag = _proRequest.sizeIndex && [_proRequest.sizeIndex intValue] >= 0;
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Size_Selected:%@", nil), flag?@"YES":@"NO"];
    }
    else {
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Pro_StartTime:%@", nil), _proRequest.startdate];
        [_msg appendFormat:NSLocalizedString(@"Upload_Preview_Pro_EndTime:%@", nil), _proRequest.enddate];
    }
    [_msg appendFormat:NSLocalizedString(@"Upload_Preview_StoreName:%@", nil), _proRequest.storeName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Content Preview",nil) message:_msg delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    alert.tag = SAVE_INFO_TAG;
    //左对齐
    for(UIView *subview in alert.subviews)
    {
        if([[subview class] isSubclassOfClass:[UILabel class]])
        {
            UILabel *label = (UILabel*)subview;
            if([label.text isEqualToString:_msg])
                label.textAlignment = UITextAlignmentLeft;
        }
    }
    [alert show];
}

-(void) setProgress:(PostProgressStep)step withObject:(id)value
{
    switch (step) {
        case PostBegin:
        {
            _proRequest = [[FSCommonProRequest alloc] init];
            _proRequest.uToken = currentUser.uToken;
            _proRequest.routeResourcePath = _route;

            break;
        }
        case PostStep1Finished:
        {
            if (!_proRequest.imgs)
                _proRequest.imgs = [@[] mutableCopy];
            if (value && [value count]>0)
                [_proRequest.imgs addObject:(UIImage *)value[0]];
            else
                [_proRequest.imgs removeAllObjects];
            //disable photo button if more than 3 imags
            if (_proRequest.imgs.count>=5)
                _btnPhoto.enabled = FALSE;
            else
                _btnPhoto.enabled = TRUE;
            break;
        }
        case PostStep2Finished:
        {
            _proRequest.title = [(NSArray *)value objectAtIndex:0];
            _proRequest.descrip = [(NSArray *)value objectAtIndex:1];
            _proRequest.fileName = [(NSArray *)value objectAtIndex:2];
            NSString *price = [(NSArray *)value objectAtIndex:3];
            _proRequest.price =[NSNumber numberWithInt:[price floatValue]];
            price = [(NSArray *)value objectAtIndex:4];
            _proRequest.originalPrice =[NSNumber numberWithInt:[price floatValue]];
            _proRequest.upccode = [(NSArray *)value objectAtIndex:5];
            break;
        }
        case PostStep3Finished:
        {
            if (value)
            {
                if (_dateRowIndex == 0)
                    _proRequest.startdate = value[0];
                else
                    _proRequest.enddate = value[0];
            }
            break;
        }
        case PostStep4Finished:
        {
            _proRequest.brandId = [(FSBrand *)value valueForKey:@"id"];
            _proRequest.brandName = [(FSBrand *)value valueForKey:@"name"];
            break;
        }
        case PostStepStoreFinished:
        {
            _proRequest.storeId = [(FSStore *)value valueForKey:@"id"];
            _proRequest.storeName = [(FSStore *)value name];
            break;
        }
            /*
        case PostStepSaleTag:
        {
            _proRequest.is4sale = value[0];
            break;
        }
             */
        case PostStepTagFinished:
        {
            _proRequest.tagId =[(FSTag *)value valueForKey:@"id"];
            _proRequest.tagName = [(FSTag *)value valueForKey:@"name"];
            break;
        }
        default:
        {
            //到正式提交的时候再去获取参数
        }
            break;
    }
}

-(void)updateSaveButton
{
    if ([self uploadPercent]>=1)
    {
        UIBarButtonItem *rightButton = self.navigationItem.rightBarButtonItem;
        [rightButton setEnabled:true];
    } else
    {
        UIBarButtonItem *rightButton = self.navigationItem.rightBarButtonItem;
        [rightButton setEnabled:false];
    }
}

-(float) uploadPercent
{
    int finishedFields = 0;
    int totalFields = _totalFields;
    _proRequest.imgs &&_proRequest.imgs.count>0 && (_mustFields&ImageField)?finishedFields++:finishedFields;
    _proRequest.title && (_mustFields&TitleField)?finishedFields++:finishedFields;
    _proRequest.startdate &&(_mustFields & DurationField)?finishedFields++:finishedFields;
    _proRequest.enddate&&(_mustFields &DurationField)?finishedFields++:finishedFields;
    _proRequest.brandId&&(_mustFields &TagField)?finishedFields++:finishedFields;
    _proRequest.storeId&&(_mustFields &StoreField)?finishedFields++:finishedFields;
    //_proRequest.is4sale&&(_mustFields &SaleField)?finishedFields++:finishedFields;
    _proRequest.tagId&&(_mustFields &TagField)?finishedFields++:finishedFields;
    /*
    if (_properties.count > 0) {
        for (FSPurchaseSaleColorsItem *item in _properties) {
            BOOL flag = NO;
            for (FSPurchaseSaleColorsItem *sub in item.values) {
                if (sub.isChecked) {
                    flag = YES;
                    break;
                }
            }
            if (flag) {
                finishedFields ++;
            }
        }
    }
     */
    return _totalFields==0?0:(float)finishedFields/(float)totalFields;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doTakePhoto:(id)sender {
    if (!camera)
    {
        camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self decorateOverlayToCamera:camera];
        [UIView animateWithDuration:0.2 animations:nil completion:^(BOOL finished) {
            [self presentViewController:camera animated:YES completion:nil];
        }];
    }
    else
    {
        [self reportError:NSLocalizedString(@"Can Not Camera", nil)];
        return;
    }
}

-(void)didImageRemoveAll
{
    [self proPostStep:PostStep1Finished didCompleteWithObject:nil];
}

- (IBAction)doTakeDescrip:(id)sender {
    if (!_titleSel)
        _titleSel = [[FSProPostTitleViewController alloc] initWithNibName:@"FSProPostTitleViewController" bundle:nil];
    _titleSel.delegate = self;
    _titleSel.publishSource = _publishSource;
    [self presentViewController:_titleSel animated:TRUE completion:nil];
    
    
}

- (IBAction)doSelStore:(id)sender {
    FSPostTableSelViewController *tableSelect = [[FSPostTableSelViewController alloc] initWithNibName:@"FSPostTableSelViewController" bundle:Nil];
    [ tableSelect setDataSource:^id{
        return theApp.allStores;//[FSCoreStore allStoresLocal];
    } step:PostStepStoreFinished selectedCallbackTarget:self];
    tableSelect.navigationItem.title =NSLocalizedString(@"PRO_POST_STORE_NOTEXT", nil);
    [self.navigationController pushViewController:tableSelect animated:TRUE];

}

- (IBAction)doSelBrand:(id)sender {
    FSPostTableSelViewController *tableSelect = [[FSPostTableSelViewController alloc] initWithNibName:@"FSPostTableSelViewController" bundle:Nil];
    [ tableSelect setDataSource:^id{
        return [FSGroupBrandList allBrandsLocal];
    } step:PostStep4Finished selectedCallbackTarget:self];
    tableSelect.navigationItem.title =NSLocalizedString(@"PRO_POST_BRAND_NOTEXT", nil);
    [self.navigationController pushViewController:tableSelect animated:TRUE];
}

-(void)doSelTag:(id)sender
{
    FSPostTableSelViewController *tableSelect = [[FSPostTableSelViewController alloc] initWithNibName:@"FSPostTableSelViewController" bundle:Nil];
    [tableSelect setDataSource:^id{
        return theApp.allTags;
    } step:PostStepTagFinished selectedCallbackTarget:self];
    tableSelect.navigationItem.title =NSLocalizedString(@"PRO_POST_TAG_NOTEXT", nil);
    [self.navigationController pushViewController:tableSelect animated:TRUE];
}

-(void)doSelDuration:(id)sender{
    if (_dateRowIndex == 0) {
        if (!_datePicker) {
            _datePicker = [[TDDatePickerController alloc] init];
            _datePicker.delegate = self;
        }
        //_datePicker.datePicker.minimumDate = [NSDate date];
        [self presentSemiModalViewController:_datePicker];
    }
    else {
        if (!_dateEndPicker) {
            _dateEndPicker = [[TDDatePickerController alloc] init];
            _dateEndPicker.delegate = self;
        }
        //_dateEndPicker.datePicker.minimumDate = [NSDate date];
        [self presentSemiModalViewController:_dateEndPicker];
    }
}

-(void)doSelProperties:(int)section
{
    FSTableMultiSelViewController *tableSelect = [[FSTableMultiSelViewController alloc] initWithNibName:@"FSTableMultiSelViewController" bundle:Nil];
    int index = section - 6;
    if (_publishSource == FSSourcePromotion) {
        //do nothing
    }
    if (index < 0 || index >= _properties.count) {
        return;
    }
    FSPurchaseSaleColorsItem *item = _properties[index];
    [tableSelect setDataSource:^id{
        return item.sizes;
    } step:PostStepProperties+index selectedCallbackTarget:self];
    tableSelect.navigationItem.title = [NSString stringWithFormat:@"选择%@", item.colorName];
    [self.navigationController pushViewController:tableSelect animated:TRUE];
}

-(void)doSelSale:(id)sender
{
    if (!paywayPickerView) {
        paywayPickerView = [[FSMyPickerView alloc] init];
        paywayPickerView.delegate = self;
        paywayPickerView.datasource = self;
    }
    //初始化选中项
    int index = 0;
    if ([_proRequest.is4sale boolValue]) {
        index = 1;
    }
    else{
        index = 0;
    }
    [paywayPickerView.picker selectRow:index inComponent:0 animated:NO];
    [paywayPickerView showPickerView:nil];
}

#pragma FSProPostStepCompleteDelegate

-(void)proPostStep:(PostProgressStep)step didCompleteWithObject:(NSArray *)object
{
    [self setProgress:step withObject:object];
    switch (step) {
        case PostStep1Finished:
        {
            [_tbAction reloadData];
            break;
        }
        case PostStep2Finished:
        {
            [_rows setValue:_proRequest.title forKey:NSLocalizedString(@"PRO_POST_TITLE_LABEL", Nil)];
            [_tbAction reloadData];
            break;
        }
        case PostStep3Finished:
        {
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            if (_dateRowIndex==0 && _proRequest.startdate)
            {
                [(NSMutableArray *)[_rows objectForKey:NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil)] replaceObjectAtIndex:0 withObject:[formater stringFromDate:_proRequest.startdate]] ;
                 [_tbAction reloadData];
            } else if(_dateRowIndex == 1 && _proRequest.enddate)
            {
                 [(NSMutableArray *)[_rows objectForKey:NSLocalizedString(@"PRO_POST_DURATION_LABEL", Nil)] replaceObjectAtIndex:1 withObject:[formater stringFromDate:_proRequest.enddate]] ;
                 [_tbAction reloadData];
            }
                       
            break;
        }
        case PostStep4Finished:
        {
            [_rows setValue:_proRequest.brandName forKey:NSLocalizedString(@"PRO_POST_BRAND_LABEL", Nil)];
            [_tbAction reloadData];
            break;
        }
        case PostStepStoreFinished:
        {
            [_rows setValue:_proRequest.storeName forKey:NSLocalizedString(@"PRO_POST_STORE_LABEL", Nil)];
            [_tbAction reloadData];
            break;
        }
            /*
        case PostStepSaleTag:
        {
            BOOL flag = [object[0] boolValue];
            [_rows setValue:flag?@"是":@"否" forKey:NSLocalizedString(@"PRO_POST_SALE_LABEL", nil)];
            [_tbAction reloadSections:[NSIndexSet indexSetWithIndex:4] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
             */
        case PostStepTagFinished:
        {
            [_rows setValue:_proRequest.tagName forKey:NSLocalizedString(@"PRO_POST_TAG_LABEL", Nil)];
            [_tbAction reloadData];
            //请求tagid对应的数据
            //[self requestTagProperties:_proRequest.tagId];
            break;
        }
        default:
        {
            /*
            int index = step- PostStepProperties;
            if (index < 0 || index >= _properties.count) {
                return;
            }
            FSPurchaseSaleColorsItem *item = _properties[index];
            NSMutableString *desc = [NSMutableString string];
            for (int i = 0; i < item.values.count; i++) {
                FSPurchaseSaleColorsItem *_item = item.values[i];
                if (_item.isChecked) {
                    [desc appendFormat:@"%@;", _item.valuename];
                }
            }
            if ([NSString isNilOrEmpty:desc]) {
                [_rows setValue:[NSString stringWithFormat:@"请选择%@", item.propertyname] forKey:item.propertyname];
            }
            else{
                [_rows setValue:desc forKey:item.propertyname];
            }
            [_tbAction reloadData];
             */
        }
            break;
    }
    [self updateSaveButton];
}

-(void)requestTagProperties:(NSNumber*)tagId
{
    FSCommonProRequest* request = [[FSCommonProRequest alloc] init];
    request.uToken = currentUser.uToken;
    request.tagId = tagId;
    request.routeResourcePath = RK_REQUEST_TAG_PROPERTIES;
    request.rootKeyPath = @"data.items";
    [self beginLoading:self.view];
    _tbAction.userInteractionEnabled = NO;
    [request send:[FSPurchaseSaleColorsItem class] withRequest:request completeCallBack:^(FSEntityBase *response) {
        [self endLoading:self.view];
        _tbAction.userInteractionEnabled = YES;
        if (response.isSuccess) {
            //加入新的选择行
            [self resetProperties];
            _properties = response.responseData;
            for (int i = 0; i < _properties.count; i++) {
                FSPurchaseSaleColorsItem *item = _properties[i];
                NSString* key = item.colorName;
                NSString* value = [NSString stringWithFormat:@"请选择%@", item.colorName];
                [_sections addObject:key];
                [_keySections addObject:value];
                [_rows setValue:value forKey:key];
                [_tbAction beginUpdates];
                [_tbAction insertSections:[NSIndexSet indexSetWithIndex:5]
                         withRowAnimation:UITableViewRowAnimationFade];
                [_tbAction endUpdates];
            }
            _totalFields += _properties.count;
            
            [self updateSaveButton];
        }
        else{
            [self reportError:response.errorDescrip];
        }
    }];
}

-(void)resetProperties
{
    for (int i = 0; i < _properties.count; i++) {
        if (_sections.count <= 6) {
            break;
        }
        FSPurchaseSaleColorsItem *item = _properties[i];
        NSString* key = item.colorName;
        NSString* value = [NSString stringWithFormat:@"请选择%@", item.colorName];
        [_rows removeObjectForKey:key];
        [_sections removeObject:key];
        [_keySections removeObject:value];
        [_tbAction beginUpdates];
        [_tbAction deleteSections:[NSIndexSet indexSetWithIndex:6]
                 withRowAnimation:UITableViewRowAnimationFade];
        [_tbAction endUpdates];
    }
    _totalFields -= _properties.count;
}

#pragma mark - UITableViewSource delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int keyIndex = [_keySections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL match = [[_sections objectAtIndex:section] isEqualToString:obj];
        *stop = match;
        return match;
    }];
    switch (keyIndex) {
        case 2:
            return [[_rows objectForKey:[_sections objectAtIndex:section]] count];
        default:
            return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sections objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *detailCell =  [tableView dequeueReusableCellWithIdentifier:@"defaultcell"];
    if (!detailCell)
    {
        detailCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"];
    }
    detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    detailCell.imageView.image = nil;
    detailCell.textLabel.text = nil;
    detailCell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    detailCell.textLabel.font = ME_FONT(15);
    id detailText = [_rows objectForKey:[_sections objectAtIndex:indexPath.section]];
    int keyIndex = [_keySections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL match = [[_sections objectAtIndex:indexPath.section] isEqualToString:obj];
        *stop = match;
        return match;
    }];
    switch (keyIndex) {
        case 0:
        {
            if (_proRequest.imgs &&
                _proRequest.imgs.count>0)
            {
                detailCell = [tableView dequeueReusableCellWithIdentifier:@"FSImageUploadCell"];
                FSImageUploadCell *_imageUploadCell = (FSImageUploadCell *)detailCell;
                [_imageUploadCell setImages:_proRequest.imgs];
                [_imageUploadCell setImageRemoveDelegate:self];
                [_imageUploadCell setSizeSelDelegate:self];
            }
            else
            {
                detailCell.imageView.image = nil;
                detailCell.textLabel.text = detailText;
            }
            break;
        }
        case 1:
        case 3:
        case 4:
        case 5:
        {
            detailCell.textLabel.text = detailText;
            break;
        }
        case 2:
        {
            detailCell.textLabel.text = [detailText objectAtIndex:indexPath.row];
        }
        default:
        {
            //默认处理
            detailCell.textLabel.text = detailText;
        }
            break;
    }
    return detailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int keyIndex = [_keySections indexOfObject:[_sections objectAtIndex:indexPath.section]];

    switch (keyIndex*10+indexPath.row) {
        case 0:
        {
            [self doTakePhoto:nil];
            break;
        }
        case 10:
        {
            [self doTakeDescrip:nil];
            break;
        }
        case 20:
        case 21:
        {
            _dateRowIndex = indexPath.row;
            [self doSelDuration:nil];
            break;
        }
        case 30:
        {
            [self doSelBrand:nil];
            break;
        }
        case 40:
        {
            [self doSelStore:nil];
            break;
        }
            /*
        case 50:
        {
            [self doSelSale:nil];
            break;
        }
             */
        case 50:
        {
            [self doSelTag:nil];
            break;
        }
        default:
        {
            //[self doSelProperties:indexPath.section];
        }
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int keyIndex = [_keySections indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL match = [[_sections objectAtIndex:indexPath.section] isEqualToString:obj];
        *stop = match;
        return match;
    }];
    if (keyIndex==0 &&
        _proRequest.imgs.count>0)
    {
        return floor((_proRequest.imgs.count+2)/3)*150;
    }
    else
    {
        return tableView.rowHeight;
    }
}

#pragma mark - UIImagePicker delegate

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];  
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	
	if([mediaType isEqualToString:@"public.image"])
	{
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

        [NSThread detachNewThreadSelector:@selector(cropImage:) toTarget:self withObject:image];
            }
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

- (void)cropImage:(UIImage *)image {
    CGSize newSize = image.size;
    newSize = CGSizeMake(640*RetinaFactor, 640*RetinaFactor*image.size.height/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    
    [self proPostStep:PostStep1Finished didCompleteWithObject:@[newImage]];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];  
    return;
}
-(UIImagePickerController*) inUserCamera
{
    return  camera;
}

#pragma mark - TDDatePickerControllerDelegate

- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    [self proPostStep:PostStep3Finished didCompleteWithObject:@[viewController.datePicker.date]];
    [self dismissSemiModalViewController:viewController];
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self proPostStep:PostStep3Finished didCompleteWithObject:nil];
    [self dismissSemiModalViewController:viewController];
}

#pragma titleViewControllerDelegate
-(void)titleViewControllerCancel:(FSProPostTitleViewController *)viewController
{
    [viewController dismissViewControllerAnimated:TRUE completion:nil];
}
-(void)titleViewControllerSetTitle:(FSProPostTitleViewController *)viewController
{
    NSMutableString *_desc = [NSMutableString stringWithFormat:@"%@", viewController.txtDesc.text];
    if (_publishSource == FSSourceProduct) {
        if (![NSString isNilOrEmpty:viewController.txtProDesc.text]) {
            [_desc appendFormat:NSLocalizedString(@"Part_Promotion %@", nil), viewController.txtProDesc.text];
            
            //必须活动描述不为空，才能添加后面的内容
            if (![NSString isNilOrEmpty:viewController.txtProStartTime.text]) {
                [_desc appendFormat:NSLocalizedString(@"Promotion_Duration %@", nil), viewController.txtProStartTime.text];
                if (![NSString isNilOrEmpty:viewController.txtProEndTime.text]) {
                    [_desc appendFormat:@"%@", viewController.txtProEndTime.text];
                }
                else {
                    [_desc appendFormat:@"%@", @"Error"];
                }
            }
        }
    }
    NSLog(@"desc:%@", _desc);
    if (viewController.recordFileName) {
        _fileName = [kRecorderDirectory stringByAppendingPathComponent:viewController.recordFileName];
    }
    else{
        _fileName = @"";
    }
    [self proPostStep:PostStep2Finished didCompleteWithObject:@[viewController.txtTitle.text, _desc, _fileName, viewController.txtPrice.text, viewController.txtOriginalPrice.text,viewController.txtUpccode.text]];
    [viewController dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)viewDidUnload {
    [self setBtnPhoto:nil];
    //清空_titleSel里的内容
    [_titleSel cleanData];
    
    [super viewDidUnload];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == EXIT_ALERT_TAG && buttonIndex == 1) {
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
    if (alertView.tag == SAVE_INFO_TAG && buttonIndex == 1) {
        [self startProgress:NSLocalizedString(@"prodct uploading...", nil) withExeBlock:^(dispatch_block_t callback){
            [self internalDoSave:callback];
        } completeCallbck:^{
            [self endProgress];
            [[NSNotificationCenter defaultCenter] postNotificationName:LN_ITEM_UPDATED object:nil];
        }];
    }
    if (alertView.tag == FILL_PRODUCT_CODE && buttonIndex == 1) {
        [self doTakeDescrip:nil];
    }
}

- (BOOL)validateDate:(NSMutableString **)errorin
{
    if (!errorin)
        *errorin = [@"" mutableCopy];
    NSMutableString *error = *errorin;
    if([_dateEndPicker.datePicker.date compare:_datePicker.datePicker.date] != NSOrderedDescending)
    {
        [error appendString:NSLocalizedString(@"PRO_POST_DURATION_DATE_VALIDATE", nil)];;
        return false;
    }
    return true;
}

#pragma mark - FSMyPickerViewDatasource

- (NSInteger)numberOfComponentsInMyPickerView:(FSMyPickerView *)pickerView
{
    if (pickerView == paywayPickerView) {
        return 1;
    }
    return 0;
}

- (NSInteger)myPickerView:(FSMyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == paywayPickerView) {
        return 2;
    }
    return 0;
}

#pragma mark - FSMyPickerViewDelegate

- (void)didClickOkButton:(FSMyPickerView *)aMyPickerView
{
    if (aMyPickerView == paywayPickerView) {
        int index = [aMyPickerView.picker selectedRowInComponent:0];
        BOOL flag = (index == 0?NO:YES);
        [self proPostStep:PostStepSaleTag didCompleteWithObject:@[[NSNumber numberWithBool:flag]]];
    }
}

- (NSString *)myPickerView:(FSMyPickerView *)aMyPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (aMyPickerView == paywayPickerView) {
        if (row == 1) {
            return @"是";
        }
        else{
            return @"否";
        }
    }
    return @"";
}

#pragma mark - sizeSelDelegate

-(id)selectSizeImageWithIndex:(NSNumber*)aSizeIndex
{
    int index = [_proRequest.sizeIndex intValue];
    if (_proRequest.sizeIndex && index == [aSizeIndex intValue]) {
        _proRequest.sizeIndex = nil;
    }
    else{
        _proRequest.sizeIndex = [NSNumber numberWithInt:[aSizeIndex intValue]];
    }
    return _proRequest.sizeIndex;
}

@end
