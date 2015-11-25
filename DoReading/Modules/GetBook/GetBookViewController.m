//
//  GetBookViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "GetBookViewController.h"

@interface GetBookViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *currentRequestString;

@end

@implementation GetBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str = @"http://www.qingkan.net/book/rudaozhisheng/txt.html";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [webView loadRequest:request];
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.currentRequestString = [[request URL] absoluteString];
    NSArray *components = [self.currentRequestString componentsSeparatedByString:@"/"];
    
    if ([components count] > 1 && [(NSString *)components.lastObject isStringForGrep:@"^.*[.]{1}txt$"]) {
        NSString *fileName = (NSString *)components.lastObject;
        NSLog(@"fileName = %@",fileName);
        
        if([[fileName getExtendName] isEqualToString:@"txt"])
        {
            DownLoadAlertViewController *alert = [[DownLoadAlertViewController alloc] initWithURL:[request URL] useCache:NO allowResume:YES];
            [alert showIn:self.navigationController];
        }
        return NO;
    }
    return YES;
}


@end
