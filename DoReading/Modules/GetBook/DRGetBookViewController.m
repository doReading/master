//
//  DRGetBookViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRGetBookViewController.h"

@interface DRGetBookViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *currentRequestString;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) DownLoadAlertViewController *alertDownView;
@end

@implementation DRGetBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyBoardWillShow = YES;
    
    NSString *str = @"http://www.qingkan.net";
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_webView];
    _webView.delegate = self;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(refreshItemClick:)];
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
            self.alertDownView = alert;
        }
        return NO;
    }
    return YES;
}

- (void)refreshItemClick:(UIBarButtonItem *)item
{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSString *str = @"http://www.qingkan.net/book/rudaozhisheng/txt.html";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
    [_webView loadRequest:request];
}

#pragma mark - shouldDoForKeyBoard

-(void)shouldDoForKeyBoardWillShow:(CGFloat)height
{
    [self.alertDownView rasieWhenKeyboardShow:height];
}

- (void)shouldDoForKeyBoardWillHide:(CGFloat)height
{
    [self.alertDownView downWhenKeyboardHide:height];
}

@end
