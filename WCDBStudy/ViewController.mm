//
//  ViewController.m
//  WCDBStudy
//
//  Created by guoliting on 2017/11/7.
//  Copyright © 2017年 NingXia. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
#import "RadioButton.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *createButton;
@property (nonatomic, strong) UIButton *insertButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSArray *tableManagers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _tableManagers = @[@{@"table":@"message", @"manager":@"MessageManager"}, @{@"table":@"people", @"manager":@"PeopleManager"}];
    CGFloat originX = 20;
    static CGFloat originY = 44 + 20 + 20;
    CGFloat subviewWidth = 100;
    CGFloat subviewHeight = 30;
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:_tableManagers.count];
    CGRect btnRect = (CGRect){originX, originY, subviewWidth, subviewHeight};
    for (NSDictionary *tableManager in _tableManagers) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += subviewWidth + 20;
        [btn setTitle:tableManager ? tableManager[@"table"] : @"无" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.view addSubview:btn];
        [buttons addObject:btn];
    }
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    _tableName = _tableManagers[0][@"table"];
    
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

- (IBAction)onRadioButtonValueChanged:(RadioButton *)sender {
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if (sender.selected) {
        _tableName = sender.titleLabel.text;
        NSLog(@"Selected text: %@", sender.titleLabel.text);
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title action:(SEL)action {
    CGFloat originX = 20;
    static CGFloat originY = 44 + 20 + 20 + 30 + 20;
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

- (NSString *)managerName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"table=%@", _tableName]; //实现数组的快速查询
    if (predicate) {
        NSArray *filteredArray = [_tableManagers filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            return filteredArray[0][@"manager"];
        }
    }
    
    return @"";
}

- (IBAction)createButtonDidClicked:(id)sender {
    BOOL result = [[DatabaseManager shareInstance] createDatabaseWithTableName:_tableName];
    NSLog(@"创建数据表%@%@", _tableName, result ? @"成功" : @"失败");
}

- (IBAction)insertButtonDidClicked:(id)sender {
    WCTObject *object;
    int index = 0;
    if ([_tableName isEqualToString:@"message"]) {
        static int localID = 1;
        /*
         INSERT INTO message(localID, content, createTime, modifiedTime)
         VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
         */
        Message *message = [[Message alloc] init];
        message.localID = localID;
        message.content = [@"Hello, WCDB!" stringByAppendingFormat:@"%d", localID];
        message.createTime = [NSDate date];
        message.modifiedTime = [NSDate date];
        object = message;
        index = localID;
        localID++;
    } else if ([_tableName isEqualToString:@"people"]) {
        static int localID = 1;
        /*
         INSERT INTO people(localID, name, sex, age, createTime, modifiedTime)
         VALUES(1, "people", 1, 21, 1496396165, 1496396165);
         */
        People *people = [[People alloc] init];
        people.localID = localID;
        people.name = [@"people" stringByAppendingFormat:@"%d", localID];
        people.sex = localID % 2;
        people.age = 20 + localID;
        people.createTime = [NSDate date];
        people.modifiedTime = [NSDate date];
        object = people;
        index = localID;
        localID++;
    }
    BOOL result = [[DatabaseManager shareInstance] insertDatabaseWithObject:object tableName:_tableName];
    NSLog(@"表%@中localID为%d的数据插入%@", _tableName, index, result ? @"成功" : @"失败");
}

- (IBAction)deleteButtonDidClicked:(id)sender {
    int index = 0;
    if ([_tableName isEqualToString:@"message"]) {
        static int localID = 1;
        //DELETE FROM message WHERE localID=1;
        index = localID;
        localID++;
    } else if ([_tableName isEqualToString:@"people"]) {
        static int localID = 1;
        //DELETE FROM people WHERE localID=1;
        index = localID;
        localID++;
    }
    BOOL result = [[DatabaseManager shareInstance] deleteDatabaseWhere:[_tableName isEqualToString:@"message"] ? Message.localID : People.localID == index tableName:_tableName];
    NSLog(@"表%@中localID为%d的数据删除%@", _tableName, index, result ? @"成功" : @"失败");
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
