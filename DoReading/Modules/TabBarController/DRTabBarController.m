//
//  DRTabBarController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRTabBarController.h"

#import "HomeViewController.h"
#import "GetBookViewController.h"

@interface DRTabBarController ()

@end

@implementation DRTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    homeVc.title = @"读";
    DRNavigationController *homeNc = [[DRNavigationController alloc] initWithRootViewController:homeVc];
    
    GetBookViewController *getVc = [[GetBookViewController alloc] init];
    getVc.title = @"行";
    DRNavigationController *getNc = [[DRNavigationController alloc] initWithRootViewController:getVc];
    
    self.viewControllers = @[homeNc, getNc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
