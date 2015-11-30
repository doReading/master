//
//  DRHomeViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/10/26.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRHomeViewController.h"
#import "DRAddLocationViewController.h"

@interface DRHomeViewController ()

@end

@implementation DRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏添加新书
    [self addRightButton];
}

- (void)addRightButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
}

- (void)rightBarItemClick:(UIBarButtonItem *)item
{
    DRAddLocationViewController *locationVc = [[DRAddLocationViewController alloc] init];
    [self.navigationController pushViewController:locationVc animated:YES];
}

@end
