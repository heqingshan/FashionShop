//
//  FSMyLetter.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSUser.h"

@interface FSMyLetter : FSModelBase

@property (nonatomic,strong) FSUser *touser;
@property (nonatomic,strong) FSUser *fromuser;
@property (nonatomic) BOOL isauto;
@property (nonatomic) int id;
@property (nonatomic) BOOL isvoice;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSDate *createdate;

@end
