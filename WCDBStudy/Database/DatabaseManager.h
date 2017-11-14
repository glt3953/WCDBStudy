//
//  DatabaseManager.h
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Message+WCTTableCoding.h"
#import "People+WCTTableCoding.h"

@interface DatabaseManager : NSObject

+ (instancetype)shareInstance;

/**
 创建数据库
 
 @param tableName 表名称
 @return 是否创建成功
 */
- (BOOL)createDatabaseWithTableName:(NSString *)tableName;

- (BOOL)insertDatabaseWithObject:(WCTObject *)object tableName:(NSString *)tableName;

- (BOOL)deleteDatabaseWhere:(const WCTCondition &)condition tableName:(NSString *)tableName;

- (BOOL)updateDatabaseWithTableName:(NSString *)tableName onProperties:(const WCTPropertyList &)properties withObject:(WCTObject *)object where:(const WCTCondition &)condition;

- (NSArray *)selectDatabaseWithTableName:(NSString *)tableName;

@end
