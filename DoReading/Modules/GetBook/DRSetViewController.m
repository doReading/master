//
//  DRSetViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 16/5/27.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

#import "DRSetViewController.h"

@implementation DRSetViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.keyBoardWillShow = YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setViewControllerCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setViewControllerCell"];
    }
    return cell;
}

@end
