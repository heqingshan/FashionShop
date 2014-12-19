//
//  FSNickieViewController.h
//  FashionShop
//
//  Created by gong yi on 11/30/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUser.h"

@interface FSNickieViewController : FSBaseViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> 

@property (strong, nonatomic) IBOutlet UITableView *tbAction;
- (IBAction)doSave:(id)sender;

@property (strong, nonatomic) FSUser *currentUser;
@end
