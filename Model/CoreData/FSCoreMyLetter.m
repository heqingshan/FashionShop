//
//  FSMyLetter.m
//  FashionShop
//
//  Created by HeQingshan on 13-7-4.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import "FSCoreMyLetter.h"

@implementation FSCoreMyLetter
@dynamic touser,fromuser,isauto,id,isvoice,msg,createdate;

+(RKObjectMapping *)getRelationDataMap:(Class)type withParentMap:(RKObjectMapping *)parentMap
{
    RKManagedObjectStore *objectStore = [FSModelManager sharedManager].objectStore;
    RKManagedObjectMapping *relationMapping = [RKManagedObjectMapping mappingForClass:[self class] inManagedObjectStore:objectStore];
    relationMapping.primaryKeyAttribute = @"id";
    [relationMapping mapKeyPath:@"id" toAttribute:@"id"];
    [relationMapping mapKeyPath:@"isauto" toAttribute:@"isauto"];
    [relationMapping mapKeyPath:@"isvoice" toAttribute:@"isvoice"];
    [relationMapping mapKeyPath:@"msg" toAttribute:@"msg"];
    [relationMapping mapKeyPath:@"createdate" toAttribute:@"createdate"];
    
    RKObjectMapping *map = [FSCoreUser getRelationDataMap:[FSCoreUser class] withParentMap:relationMapping];
    [relationMapping mapKeyPath:@"touser" toRelationship:@"touser" withMapping:map];
    [relationMapping mapKeyPath:@"fromuser" toRelationship:@"fromuser" withMapping:map];
    
    return relationMapping;
}

-(void)show
{
    NSLog(@"----------------------------------------------------------------------");
    NSLog(@"id:%d,msg:%@,fromuserid:%d,touserid:%d",self.id, self.msg,self.fromuser.uid,self.touser.uid);
    [self.fromuser show];
    [self.touser show];
    NSLog(@"----------------------------------------------------------------------");
}

+ (NSArray *) allLettersLocal
{
    return [self findAllSortedBy:@"id" ascending:TRUE];
}

+ (NSArray*) fetchData:(int)latestId one:(int)oneId two:(int)twoId length:(int)length ascending:(BOOL)flag
{
    /*
    NSString *str = [NSString stringWithFormat:@"((fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)) AND (id < %d)", oneId, twoId, twoId, oneId, latestId];
    if (flag) {
        str = [NSString stringWithFormat:@"((fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)) AND (id > %d)", oneId, twoId, twoId, oneId, latestId];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [FSCoreMyLetter findAllSortedBy:@"id" ascending:true withPredicate:predicate];
    if (array.count <= length) {
        return array;
    }
    NSArray *_toSub = [array subarrayWithRange:NSMakeRange(array.count - length, length)];
    return _toSub;
     */
    NSArray *__array = [self allLettersLocal];
    NSString *str = [NSString stringWithFormat:@"((fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)) AND (id < %d)", oneId, twoId, twoId, oneId, latestId];
    if (flag) {
        str = [NSString stringWithFormat:@"((fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)) AND (id > %d)", oneId, twoId, twoId, oneId, latestId];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [__array filteredArrayUsingPredicate:predicate];
    if (array.count <= length) {
        return array;
    }
    NSArray *_toSub = [array subarrayWithRange:NSMakeRange(array.count - length, length)];
    return _toSub;
}

+(NSArray*) fetchLatestLetters:(int)length one:(int)oneId two:(int)twoId
{
    /*
    NSString *str = [NSString stringWithFormat:@"(fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)", oneId, twoId, twoId, oneId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray* array = [FSCoreMyLetter findAllSortedBy:@"id" ascending:true withPredicate:predicate];
    if (array.count <= length) {
        return array;
    }
    NSArray *_toSub = [array subarrayWithRange:NSMakeRange(array.count - length, length)];
    return _toSub;
     */
    NSArray *__array = [self allLettersLocal];
    NSString *str = [NSString stringWithFormat:@"(fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)", oneId, twoId, twoId, oneId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray* array = [__array filteredArrayUsingPredicate:predicate];
    if (array.count <= length) {
        return array;
    }
    NSArray *_toSub = [array subarrayWithRange:NSMakeRange(array.count - length, length)];
    return _toSub;
}

+(int) lastConversationId:(int)oneId two:(int)twoId
{
    /*
    NSString *str = [NSString stringWithFormat:@"(fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)", oneId, twoId, twoId, oneId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [FSCoreMyLetter findAllSortedBy:@"id" ascending:true withPredicate:predicate];
    if (array.count > 0) {
        FSCoreMyLetter *letter = array[array.count - 1];
        return letter.id;
    }
    return -1;
     */
    NSArray *__array = [self allLettersLocal];
    NSString *str = [NSString stringWithFormat:@"(fromuser.uid == %d AND touser.uid == %d) OR (fromuser.uid == %d AND touser.uid == %d)", oneId, twoId, twoId, oneId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [__array filteredArrayUsingPredicate:predicate];
    if (array.count > 0) {
        FSCoreMyLetter *letter = array[array.count - 1];
        return letter.id;
    }
    return -1;
}

+(FSCoreMyLetter*)findLetterByConversationId:(int)id
{
    /*
    NSString *str = [NSString stringWithFormat:@"id == %d", id];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [FSCoreMyLetter findAllWithPredicate:predicate];
    if(array.count > 0) {
        return array[0];
    }
    else{
        return nil;
    }
     */
    NSArray *__array = [self allLettersLocal];
    NSString *str = [NSString stringWithFormat:@"id == %d", id];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
    NSArray *array = [__array filteredArrayUsingPredicate:predicate];
    if(array.count > 0) {
        return array[0];
    }
    else{
        return nil;
    }
}

+(void) cleanMessage
{
    //保留100条数据
    NSArray *array = [FSCoreMyLetter findAllSortedBy:@"id" ascending:true];
    if (array.count <= 100) {
        return;
    }
    NSManagedObjectContext *context = [FSCoreMyLetter currentContext];
    for (int i = 0; i < array.count - 100; i++) {
        id item = array[i];
        [context deleteObject:item];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@ %@", error, [error userInfo]);
    }
}

@end
