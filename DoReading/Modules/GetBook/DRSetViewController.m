//
//  DRSetViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 16/5/27.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

#import "DRSetViewController.h"
#import "DRBookSchemeUrl.h"

@interface DRSetViewController()

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *urlArray;

@end

@implementation DRSetViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keyBoardWillShow = YES;
    
    [self initUrlArray];
}

- (void)initUrlArray
{
    _titleArray = [NSMutableArray array];
    _urlArray = [NSMutableArray array];
    
    NSMutableDictionary *dict = [share(DRBookSchemeUrl).bookWebList mutableCopy];
    for (NSString *title in dict.allKeys) {
        [self.titleArray addObject:title];
        [self.urlArray addObject:dict[title]];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return MIN(self.urlArray.count, self.titleArray.count);
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setViewControllerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setViewControllerCell"];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.detailTextLabel.text = self.urlArray[indexPath.row];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setViewControllerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setViewControllerCell"];
        }
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.detailTextLabel.text = self.urlArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (self.setBookSchemeUrlBlock) {
            self.setBookSchemeUrlBlock(self.urlArray[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
