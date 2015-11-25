//
//  HomeViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/10/26.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UIWebViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view showIndicator];
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

@end
