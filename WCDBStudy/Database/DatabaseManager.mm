//
//  DatabaseManager.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager ()

@property (nonatomic, strong) WCTDatabase *studyDatabase;

@end

@implementation DatabaseManager

+ (instancetype)shareInstance {
    static DatabaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DatabaseManager alloc] init];
        [instance createDatabaseWithTableName:@"people"];
        [instance createDatabaseWithTableName:@"message"];
    });
    
    return instance;
}

- (BOOL)createDatabaseWithTableName:(NSString *)tableName {
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
            if ([_studyDatabase isTableExists:tableName]) {
                NSLog(@"%@表已经存在", tableName);
                return NO;
            } else {
                if ([tableName isEqualToString:@"message"]) {
                    return [_studyDatabase createTableAndIndexesOfName:tableName withClass:Message.class];
                } else if ([tableName isEqualToString:@"people"]) {
                    return [_studyDatabase createTableAndIndexesOfName:tableName withClass:People.class];
                }
            }
        }
    }
    
    return NO;
}

- (BOOL)insertMessage {
    //插入
    Message *message = [[Message alloc] init];
    message.localID = 1;
    message.content = @"Hello, WCDB!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    return [self insertDatabaseWithObject:message tableName:@"message"];
}

- (BOOL)insertDatabaseWithObject:(WCTObject *)object tableName:(NSString *)tableName {
    return [_studyDatabase insertObject:object into:tableName];
}

// WCTDatabase 事务操作，利用WCTTransaction
- (BOOL)insertMessageWithTransaction {
    BOOL ret = [_studyDatabase beginTransaction];
    ret = [self insertMessage];
    if (ret) {
        [_studyDatabase commitTransaction];
    } else {
        [_studyDatabase rollbackTransaction];
    }
    
    return ret;
}

// 另一种事务处理方法Block
- (BOOL)insertMessageWithBlock {
    BOOL commit = [_studyDatabase runTransaction:^BOOL{
        BOOL ret = [self insertMessage];
        return ret;
    } event:^(WCTTransactionEvent event) {
        NSLog(@"Event %d", event);
    }];
    
    return commit;
}

- (BOOL)deleteMessageWhere:(const WCTCondition &)condition {
    
    return [_studyDatabase deleteObjectsFromTable:@"message" where:condition];
}

- (BOOL)deleteDatabaseWhere:(const WCTCondition &)condition tableName:(NSString *)tableName {
    return [_studyDatabase deleteObjectsFromTable:tableName where:condition];
}

- (BOOL)updateMessage {
    //修改
    //UPDATE message SET content="Hello, Wechat!";
    Message *message = [[Message alloc] init];
    message.content = @"Hello, Wechat!";
    
    //下面这句在17号的时候和微信团队的人在学习群里面沟通过，这个方法确实是不存在的，使用教程应该会更新，要是没更新注意这个方法
    //BOOL result = [_database updateTable:@"message" onProperties:Message.content withObject:message];
    return [_studyDatabase updateAllRowsInTable:@"message" onProperty:Message.content withObject:message];
}

- (BOOL)updateDatabaseWithTableName:(NSString *)tableName onProperties:(const WCTPropertyList &)properties withObject:(WCTObject *)object where:(const WCTCondition &)condition {
    return [_studyDatabase updateRowsInTable:tableName onProperties:properties withObject:object where:condition];
}

//查询
- (NSArray *)selectDatabaseWithTableName:(NSString *)tableName {
    NSArray<WCTObject *> *objects;
    if ([tableName isEqualToString:@"message"]) {
        //SELECT * FROM message ORDER BY localID
        objects = [_studyDatabase getObjectsOfClass:Message.class fromTable:tableName orderBy:Message.localID.order()];
    } else if ([tableName isEqualToString:@"people"]) {
        //SELECT * FROM people ORDER BY localID
        objects = [_studyDatabase getObjectsOfClass:People.class fromTable:tableName orderBy:People.localID.order()];
    }
    
    return objects;
}

@end
