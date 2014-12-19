//
//  FSMyCommentCell.h
//  FashionShop
//
//  Created by HeQingshan on 13-5-14.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSComment.h"
#import "FSMyLetter.h"
#import "FSCoreMyLetter.h"
#import "FSThumView.h"
#import "FSAudioButton.h"

@interface FSMyCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet FSThumView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *lblInDate;
@property (strong, nonatomic) IBOutlet UILabel *lblReplyDesc;
@property (strong, nonatomic) IBOutlet UIImageView *dotView;
@property (nonatomic,strong) FSAudioButton *audioButton;

@property (strong, nonatomic) FSComment *data;
@property (nonatomic,assign) int cellHeight;

-(void)updateFrame;

@end

@interface FSMyLetterCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FSThumView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UIImageView *dotView;

@property (strong, nonatomic) FSMyLetter *data;
@property (nonatomic,assign) int cellHeight;

@end

@interface FSMyLetterToCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FSThumView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) FSCoreMyLetter *data;
@property (nonatomic,assign) int cellHeight;

@end

@interface FSMyLetterFromCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FSThumView *imgThumb;
@property (strong, nonatomic) IBOutlet UILabel *lblComment;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) FSCoreMyLetter *data;
@property (nonatomic,assign) int cellHeight;

@end
