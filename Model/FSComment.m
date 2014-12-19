//
//  FSComment.m
//  FashionShop
//
//  Created by gong yi on 12/9/12.
//  Copyright (c) 2012 Fashion. All rights reserved.
//

#import "FSComment.h"

@implementation FSComment

@synthesize   id;
@synthesize comment;
@synthesize indate;
@synthesize inUser;
@synthesize resources;
@synthesize replyUserID;
@synthesize replyUserName;
@synthesize myResource;
@synthesize replyUserID_myComment;
@synthesize replyUserName_myComment;

+(RKObjectMapping *) getRelationDataMap
{
    RKObjectMapping *relationMapping = [RKObjectMapping mappingForClass:[self class]];
    [relationMapping mapKeyPathsToAttributes:@"id",@"id",@"content",@"comment",@"createddate",@"indate",@"replycustomer_id",@"replyUserID",@"replycustomer_nickname",@"replyUserName",@"replyuserid",@"replyUserID_myComment",@"replyusername",@"replyUserName_myComment",nil];
    [relationMapping mapKeyPath:@"commentid" toAttribute:@"commentid"];
    [relationMapping mapKeyPath:@"sourceid" toAttribute:@"sourceid"];
    [relationMapping mapKeyPath:@"sourcetype" toAttribute:@"sourcetype"];
    RKObjectMapping *relationMap = [FSUser getRelationDataMap];
    [relationMapping mapKeyPath:@"customer" toRelationship:@"inUser" withMapping:relationMap];
    [relationMapping mapKeyPath:@"commentuser" toRelationship:@"replyUser" withMapping:relationMap];
    relationMap = [FSResource getRelationDataMap];
    [relationMapping mapKeyPath:@"resources" toRelationship:@"resources" withMapping:relationMap];
    
    [relationMapping mapKeyPath:@"resource" toRelationship:@"myResource" withMapping:relationMap];
    
    return relationMapping;
}


@end
