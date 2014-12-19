//
//  FSComment.h
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSModelBase.h"
#import "FSUser.h"
#import "FSResource.h"

@interface FSComment : FSModelBase

@property(nonatomic) int id;
@property(nonatomic,retain) NSString * comment;
@property(nonatomic,retain) NSDate * indate;
@property(nonatomic,retain) FSUser * inUser;
@property(nonatomic,retain) NSMutableArray *resources;
@property(nonatomic,retain) NSString * replyUserName;
@property(nonatomic,assign) int replyUserID;

//我的评论新增
@property(nonatomic,retain) FSUser * replyUser;
@property(nonatomic,assign) int commentid;
@property(nonatomic,assign) int sourceid;
@property(nonatomic,assign) int sourcetype;
@property(nonatomic,retain) NSString * replyUserName_myComment;
@property(nonatomic,assign) int replyUserID_myComment;
@property(nonatomic,retain) FSResource * myResource;


@end
