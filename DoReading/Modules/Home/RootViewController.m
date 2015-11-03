//
//  ViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/10/26.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *currentRequest;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"http://www.qingkan.net/book/rudaozhisheng/txt.html";
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [self.view addSubview:webView];
    webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.currentRequest = [[request URL] absoluteString];
    NSArray *components = [self.currentRequest componentsSeparatedByString:@"/"];
    if ([components count] > 1 && [(NSString *)components.lastObject isStringForGrep:@"^.+[.]{1}txt$"]) {
        NSString *fileName = (NSString *)components.lastObject;
        NSLog(@"fileName = %@",fileName);
        
        if([[fileName getExtendName] isEqualToString:@"txt"])
        {
            NSURL *url = [NSURL URLWithString:[self.currentRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            DownLoadAlertViewController *alert = [[DownLoadAlertViewController alloc] initWithURL:url useCache:NO allowResume:YES];
            [alert showIn:self];
        }
        return NO;
    }
    return YES;
}

@end
