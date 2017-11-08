//
//  People.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "People.h"
#import "People+WCTTableCoding.h"

@implementation People

// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(People)

// 下面四个宏定义绑定到表中的字段
WCDB_SYNTHESIZE(People, localID)
WCDB_SYNTHESIZE(People, name)
WCDB_SYNTHESIZE(People, sex)
WCDB_SYNTHESIZE(People, age)
WCDB_SYNTHESIZE(People, createTime)
WCDB_SYNTHESIZE(People, modifiedTime)

// 约束宏定义数据库的主键
WCDB_PRIMARY(People, localID)

// 定义数据库的索引属性，它直接定义createTime字段为索引
// 同时 WCDB 会将表名 + "_index" 作为该索引的名称
WCDB_INDEX(People, "_index", createTime)

@end
