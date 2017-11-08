//
//  ViewController.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/7.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "ViewController.h"
#import "MessageManager.h"

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
    
    CGFloat originX = 20;
    CGFloat originY = 44 + 20 + 20;
    CGFloat buttonWidth = CGRectGetWidth(self.view.bounds) - 2 * originX;
    CGFloat buttonHeight = 30;
    _createButton = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [_createButton setTitle:@"创建数据库" forState:UIControlStateNormal];
    [_createButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_createButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_createButton];
    [_createButton addTarget:self action:@selector(createButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    originY += buttonHeight + 20;
    _insertButton = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [_insertButton setTitle:@"插入数据" forState:UIControlStateNormal];
    [_insertButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_insertButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_insertButton];
    [_insertButton addTarget:self action:@selector(insertButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    originY += buttonHeight + 20;
    _deleteButton = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [_deleteButton setTitle:@"删除数据" forState:UIControlStateNormal];
    [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_deleteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_deleteButton];
    [_deleteButton addTarget:self action:@selector(deleteButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    originY += buttonHeight + 20;
    _selectButton = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [_selectButton setTitle:@"查询数据" forState:UIControlStateNormal];
    [_selectButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_selectButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_selectButton];
    [_selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    originY += buttonHeight + 20;
    _updateButton = [[UIButton alloc] initWithFrame:(CGRect){originX, originY, buttonWidth, buttonHeight}];
    [_updateButton setTitle:@"修改数据" forState:UIControlStateNormal];
    [_updateButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_updateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:_updateButton];
    [_updateButton addTarget:self action:@selector(updateButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)createButtonDidClicked:(id)sender {
    BOOL result = [[MessageManager shareInstance] createDatabaseWithName:@"message"];
    NSLog(@"%@", result ? @"创建数据库成功" : @"创建数据库失败");
}

- (IBAction)insertButtonDidClicked:(id)sender {
    BOOL result = [[MessageManager shareInstance] insertMessage];
    NSLog(@"%@", result ? @"数据插入成功" : @"数据插入失败");
}

- (IBAction)deleteButtonDidClicked:(id)sender {
    BOOL result = [[MessageManager shareInstance] deleteMessage];
    NSLog(@"%@", result ? @"删除数据成功" : @"删除数据失败");
}

- (IBAction)selectButtonDidClicked:(id)sender {
    NSArray *array = [[MessageManager shareInstance] selectMessage];
    NSLog(@"查询结果：%@", array);
}

- (IBAction)updateButtonDidClicked:(id)sender {
    BOOL result = [[MessageManager shareInstance] updateMessage];
    NSLog(@"%@", result ? @"修改数据成功" : @"修改数据失败");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
