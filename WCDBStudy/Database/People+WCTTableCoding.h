//
//  People+WCTTableCoding.h
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "People.h"
#import <WCDB/WCDB.h>

@interface People (WCTTableCoding) <WCTTableCoding>

// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(localID)
WCDB_PROPERTY(name)
WCDB_PROPERTY(sex)
WCDB_PROPERTY(age)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)

@end
