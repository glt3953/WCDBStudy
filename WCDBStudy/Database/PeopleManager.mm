//
//  PeopleManager.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "PeopleManager.h"

@interface PeopleManager ()

@property (nonatomic, strong) WCTDatabase *studyDatabase;

@end

@implementation PeopleManager

+ (instancetype)shareInstance {
    static PeopleManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PeopleManager alloc] init];
        [instance createTable];
    });
    
    return instance;
}

- (BOOL)createTable {
    //获取沙盒根目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    NSLog(@"数据库路径：%@", filePath);
    _studyDatabase = [[WCTDatabase alloc] initWithPath:filePath];
    // 数据库加密
    //NSData *password = [@"MyPassword" dataUsingEncoding:NSASCIIStringEncoding];
    //[_database setCipherKey:password];
    //测试数据库是否能够打开
    if ([_studyDatabase canOpen]) {
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([_studyDatabase isOpened]) {
            if ([_studyDatabase isTableExists:@"people"]) {
                NSLog(@"people表已经存在");
                return NO;
            } else {
                return [_studyDatabase createTableAndIndexesOfName:@"people" withClass:People.class];
            }
        }
    }
    
    return NO;
}

- (BOOL)insertPeople {
    //插入
    People *people = [[People alloc] init];
    people.localID = 1;
    people.name = @"People, WCDB!";
    people.sex = 1;
    people.age = 21;
    people.createTime = [NSDate date];
    people.modifiedTime = [NSDate date];
    /*
     INSERT INTO people(localID, name, sex, age, createTime, modifiedTime)
     VALUES(1, "People, WCDB!", 1, 21, 1496396165, 1496396165);
     */
    return [self insertObject:people];
}

- (BOOL)insertObject:(WCTObject *)object {
    return [_studyDatabase insertObject:object into:@"people"];
}

// WCTDatabase 事务操作，利用WCTTransaction
- (BOOL)insertPeopleWithTransaction {
    BOOL ret = [_studyDatabase beginTransaction];
    ret = [self insertPeople];
    if (ret) {
        [_studyDatabase commitTransaction];
    } else {
        [_studyDatabase rollbackTransaction];
    }
    
    return ret;
}

// 另一种事务处理方法Block
- (BOOL)insertPeopleWithBlock {
    BOOL commit = [_studyDatabase runTransaction:^BOOL{
        BOOL ret = [self insertPeople];
        return ret;
    } event:^(WCTTransactionEvent event) {
        NSLog(@"Event %d", event);
    }];
    
    return commit;
}

- (BOOL)deleteObjectWhere:(const WCTCondition &)condition {
    return [_studyDatabase deleteObjectsFromTable:@"people" where:condition];
}

- (BOOL)updatePeople {
    //修改
    //UPDATE people SET content="Hello, Wechat!";
    People *people = [[People alloc] init];
    people.name = @"People, Wechat!";
    
    //下面这句在17号的时候和微信团队的人在学习群里面沟通过，这个方法确实是不存在的，使用教程应该会更新，要是没更新注意这个方法
    //BOOL result = [_database updateTable:@"people" onProperties:People.content withObject:people];
    return [_studyDatabase updateAllRowsInTable:@"people" onProperty:People.name withObject:people];
}

- (BOOL)updateObjectOnProperties:(const WCTPropertyList &)propertyList
                         withRow:(WCTOneRow *)row
                           where:(const WCTCondition &)condition {
    return [_studyDatabase updateRowsInTable:@"people" onProperties:propertyList withRow:row where:condition];
}

//查询
- (NSArray *)selectObjects {
    //SELECT * FROM people ORDER BY localID
    NSArray<People *> * people = [_studyDatabase getObjectsOfClass:People.class fromTable:@"people" orderBy:People.localID.order()];
    
    return people;
}

@end

