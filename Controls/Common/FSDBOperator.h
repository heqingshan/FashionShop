//
//  FSDBOperator.h
//  FashionShop
//
//  Created by HeQingshan on 13-7-5.
//  Copyright (c) 2013年 Fashion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface FSDBOperator : NSObject{
    sqlite3 *m_sql;
    NSString *m_dbName;
}
@property(nonatomic)sqlite3*    m_sql;
@property(nonatomic,retain) NSString*    m_dbName;

-(id)initWithDbName:(NSString*)dbname;
-(BOOL)openOrCreateDatabase:(NSString*)DbName;
-(BOOL)createTable:(NSString*)sqlCreateTable;
-(void)closeDatabase;
-(BOOL)InsertTable:(NSString*)sqlInsert;
-(BOOL)UpdataTable:(NSString*)sqlUpdata;
-(NSArray*)querryTable:(NSString*)sqlQuerry;
-(NSArray*)querryTableByCallBack:(NSString*)sqlQuerry;

+ (FSDBOperator *)sharedManager;

@end
