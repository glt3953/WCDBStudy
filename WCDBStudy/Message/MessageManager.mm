//
//  MessageManager.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/8.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "MessageManager.h"
#import "Message+WCTTableCoding.h"

@interface MessageManager ()

@property (nonatomic, strong) WCTDatabase *studyDatabase;

@end

@implementation MessageManager

+ (instancetype)shareInstance {
    static MessageManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MessageManager alloc] init];
    });
    
    return instance;
}

- (BOOL)createDatabaseWithName:(NSString *)tableName {
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
                NSLog(@"表已经存在");
                return NO;
            } else {
                return [_studyDatabase createTableAndIndexesOfName:tableName withClass:Message.class];
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
    return [_studyDatabase insertObject:message into:@"message"];
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

- (BOOL)deleteMessage {
    //删除
    //DELETE FROM message WHERE localID>0;
    return [_studyDatabase deleteObjectsFromTable:@"message" where:Message.localID > 0];
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

//查询
- (NSArray *)selectMessage {
    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> * message = [_studyDatabase getObjectsOfClass:Message.class fromTable:@"message" orderBy:Message.localID.order()];
    
    return message;
}

@end
