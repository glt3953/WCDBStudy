//
//  Message.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "Message.h"
#import "Message+WCTTableCoding.h"

@implementation Message

// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(Message)

// 下面四个宏定义绑定到表中的字段
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

// 约束宏定义数据库的主键
WCDB_PRIMARY(Message, localID)

// 定义数据库的索引属性，它直接定义createTime字段为索引
// 同时 WCDB 会将表名 + "_index" 作为该索引的名称
WCDB_INDEX(Message, "_index", createTime)

// 定义非空约束
WCDB_NOT_NULL(Message, localID)

@end
