//
//  MessageManager.h
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"
#import "Message+WCTTableCoding.h"

@interface MessageManager : Manager

+ (instancetype)shareInstance;

/**
 创建数据库
 @return 是否创建成功
 */
- (BOOL)createTable;

- (BOOL)insertObject:(WCTObject *)object;

- (BOOL)deleteObjectWhere:(const WCTCondition &)condition;

- (BOOL)updateObjectOnProperties:(const WCTPropertyList &)propertyList
                          withRow:(WCTOneRow *)row
                            where:(const WCTCondition &)condition;

- (NSArray *)selectObjects;

@end
