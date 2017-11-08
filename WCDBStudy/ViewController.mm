//
//  ViewController.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/7.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *insertButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *updateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _createButton = [self buttonWithTitle:@"创建数据库" action:@selector(createButtonDidClicked:)];
    [self.view addSubview:_createButton];
    
    _insertButton = [self buttonWithTitle:@"插入数据" action:@selector(insertButtonDidClicked:)];
    [self.view addSubview:_insertButton];
    
    _deleteButton = [self buttonWithTitle:@"删除数据" action:@selector(deleteButtonDidClicked:)];
    [self.view addSubview:_deleteButton];
    
    _selectButton = [self buttonWithTitle:@"查询数据" action:@selector(selectButtonDidClicked:)];
    [self.view addSubview:_selectButton];
    
    _updateButton = [self buttonWithTitle:@"修改数据" action:@selector(updateButtonDidClicked:)];
    [self.view addSubview:_updateButton];
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action {
    CGFloat originX = 20;
    static CGFloat originY = 44 + 20 + 20;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) - 2 * originX;
    CGFloat buttonHeight = 30;
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    originY += buttonHeight + 20;
    
    return button;
}

- (IBAction)createButtonDidClicked:(id)sender {
    NSString *tableName = @"message";
    BOOL result = [[DatabaseManager shareInstance] createDatabaseWithTableName:tableName];
    NSLog(@"创建数据表%@%@", tableName, result ? @"成功" : @"失败");
}

- (IBAction)insertButtonDidClicked:(id)sender {
    static int localID = 1;
    Message *message = [[Message alloc] init];
    message.localID = localID;
    message.content = [@"Hello, WCDB!" stringByAppendingFormat:@"%d", localID];
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    NSString *tableName = @"message";
    BOOL result = [[DatabaseManager shareInstance] insertDatabaseWithObject:message tableName:tableName];
    NSLog(@"表%@中localID为%d的数据插入%@", tableName, localID, result ? @"成功" : @"失败");
    localID++;
}

- (IBAction)deleteButtonDidClicked:(id)sender {
    static int localID = 1;
    //DELETE FROM message WHERE localID>0;
    NSString *tableName = @"message";
    BOOL result = [[DatabaseManager shareInstance] deleteDatabaseWhere:(Message.localID == localID) tableName:tableName];
    NSLog(@"表%@中localID为%d的数据删除%@", tableName, localID, result ? @"成功" : @"失败");
    localID++;
}

- (IBAction)selectButtonDidClicked:(id)sender {
    NSArray *array = [[DatabaseManager shareInstance] selectMessage];
    NSLog(@"查询结果：%@", array);
}

- (IBAction)updateButtonDidClicked:(id)sender {
    BOOL result = [[DatabaseManager shareInstance] updateMessage];
    NSLog(@"%@", result ? @"修改数据成功" : @"修改数据失败");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
