//
//  MessageManager.h
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageManager : NSObject

+ (instancetype)shareInstance;

/**
 创建数据库
 
 @param tableName 表名称
 @return 是否创建成功
 */
- (BOOL)createDatabaseWithName:(NSString *)tableName;

- (BOOL)insertMessage;

- (BOOL)deleteMessage;

- (BOOL)updateMessage;

- (NSArray *)selectMessage;

@end