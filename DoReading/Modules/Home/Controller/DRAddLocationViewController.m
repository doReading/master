//
//  DRAddLocationViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/30.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRAddLocationViewController.h"

@interface DRAddLocationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *booksArray;

@property (nonatomic, strong) NSMutableArray *selectedBooks;

@end

@implementation DRAddLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _booksArray = [NSArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self rightBarItem];
    
    [self getBooks];
}

- (void)rightBarItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
}

- (void)rightBarItemClick:(UIBarButtonItem *)item
{
    if (self.tableView.editing == YES) {
        self.tableView.editing = NO;
        item.title = @"编辑";
    }else {
        self.tableView.editing = YES;
        item.title = @"完成";
    }
}

- (void)getBooks
{
    @weakify(self);
    [BooksManager updateLocationLogWithArray:^(NSArray *array) {
        @strongify(self);
        self.booksArray = array;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.booksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationBook"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"locationBook"];
    }
    
    BookModel *model = self.booksArray[indexPath.row];
    cell.textLabel.text = model.bookName;
    cell.detailTextLabel.text = [NSString stringWithSize:model.bookSize];
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert);
}

@end
