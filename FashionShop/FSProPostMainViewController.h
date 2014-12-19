//
//  FSProPostMainViewController.h
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FSUser.h"
#import "TDSemiModal.h"
#import "TDDatePickerController.h"
#import "FSMyPickerView.h"

typedef enum{
    PostBegin,
    PostStep1Finished,
    PostStep2Finished,
    PostStep3Finished,
    PostStep4Finished,
    PostStepStoreFinished,
    PostStepSaleTag,
    PostStepTagFinished,
    PostStepProperties,
} PostProgressStep;

typedef enum{
    ImageField = 1,
    TitleField = 1<<1,
    DurationField = 1<<2,
    StoreField = 1<<3,
    BrandField = 1<<4,
    TagField = 1<<5,
    SaleField = 1<<6,
} PostFields;


@protocol FSProPostStepCompleteDelegate <NSObject>

-(void) proPostStep:(PostProgressStep)step didCompleteWithObject:(NSArray *)object;

@end

@interface FSProPostMainViewController : FSBaseViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,FSProPostStepCompleteDelegate,UIAlertViewDelegate,FSMyPickerViewDatasource,FSMyPickerViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPhoto;
@property (strong, nonatomic) IBOutlet UITableView *tbAction;
@property (strong, nonatomic) FSUser *currentUser;
@property (nonatomic) FSSourceType publishSource;
@property (nonatomic,strong) NSString *fileName;

- (IBAction)doTakePhoto:(id)sender;
- (IBAction)doTakeDescrip:(id)sender;
- (IBAction)doSelStore:(id)sender;
- (IBAction)doSelBrand:(id)sender;

-(void) setAvailableFields:(PostFields)fields;
-(void) setMustFields:(PostFields)fields;
-(void) setRoute:(NSString *)route;

@end

