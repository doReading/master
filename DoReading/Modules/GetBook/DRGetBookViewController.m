//
//  DRGetBookViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRGetBookViewController.h"
#import "DRShowTitleView.h"

@interface DRGetBookViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *currentRequestString;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) DownLoadAlertViewController *alertDownView;

@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIButton *forwordBtn;

@end

@implementation DRGetBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.keyBoardWillShow = YES;
//    
//    NSString *str = @"http://www.qingkan520.com";
//    CGRect rect = self.view.bounds;
//    rect.size.height -= 30.f;
//    _webView = [[UIWebView alloc] initWithFrame:rect];
//    
//    [self.view addSubview:_webView];
//    _webView.delegate = self;
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:str]];
//    [_webView loadRequest:request];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"主页" style:UIBarButtonItemStyleDone target:self action:@selector(homeItemClick)];
//    
//    UIView *bootomView = [self createBottomView];
//    bootomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bootomView];
//    @weakify(self);
//    [bootomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
//        make.left.right.equalTo(_webView);
//        make.height.equalTo(@30);
//    }];
    
    [self createTitleView];
    [self createRightItem];
}

- (void)createTitleView
{
    DRShowTitleView *titleView = [DRShowTitleView new];
    titleView.title = self.title;
    [titleView addTarget:self action:@selector(titleViewClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleView;
}

- (void)titleViewClick:(DRShowTitleView *)control
{
    [control upOrDown];
}

- (void)createRightItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
}

- (void)rightItemClick
{
    
}

/*
- (UIView *)createBottomView
{
    UIView *bottom = [UIView new];
    
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lastBtn setImage:[UIImage imageNamed:@"arrow_left_no"] forState:UIControlStateNormal];
    [_lastBtn setImage:[UIImage imageNamed:@"arrow_left"] forState:UIControlStateSelected];
    [_lastBtn addTarget:self action:@selector(lastWebRequest) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_lastBtn];
    
    _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _stopBtn.hidden = NO;
    [_stopBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_stopBtn addTarget:self action:@selector(stopWebRequest) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_stopBtn];
    
    _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshBtn.hidden = YES;
    [_refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [_refreshBtn addTarget:self action:@selector(refreshWebRequest) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_refreshBtn];
    
    _forwordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forwordBtn setImage:[UIImage imageNamed:@"arrow_right_no"] forState:UIControlStateNormal];
    [_forwordBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateSelected];
    [_forwordBtn addTarget:self action:@selector(forwordWebRequest) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:_forwordBtn];
    
    [_lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.left.equalTo(bottom);
        make.width.equalTo(bottom).dividedBy(3);
    }];
    
    [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.equalTo(bottom);
        make.left.equalTo(_lastBtn.mas_right);
        make.width.equalTo(bottom).dividedBy(3);
    }];
    
    [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_stopBtn);
    }];
    
    [_forwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.right.equalTo(bottom);
        make.width.equalTo(bottom).dividedBy(3);
    }];
    
    return bottom;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *currentUrlString = [[request URL] absoluteString];
    NSArray *components = [currentUrlString componentsSeparatedByString:@"/"];
    
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
    self.currentRequestString = currentUrlString;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.stopBtn.hidden = NO;
    self.refreshBtn.hidden = YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.stopBtn.hidden = YES;
    self.refreshBtn.hidden = NO;
    [self resetBottomState];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.stopBtn.hidden = YES;
    self.refreshBtn.hidden = NO;
    [self resetBottomState];
}

- (void)resetBottomState
{
    if (_webView.canGoBack) {
        self.lastBtn.selected = YES;
        self.lastBtn.enabled = YES;
    }else {
        self.lastBtn.selected = NO;
        self.lastBtn.enabled = NO;
    }
    
    if (_webView.canGoForward) {
        self.forwordBtn.selected = YES;
        self.forwordBtn.enabled = YES;
    }else {
        self.forwordBtn.selected = NO;
        self.forwordBtn.enabled = NO;
    }
}

- (void)homeItemClick
{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (self.currentRequestString.length > 0) {
        NSURL *url = [NSURL URLWithString:@"http://www.qingkan.net"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [_webView loadRequest:request];
    }
}

//停止
- (void)stopWebRequest
{
    [self.webView stopLoading];
}
//刷新
- (void)refreshWebRequest
{
//    if (self.currentRequestString.length > 0) {
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.currentRequestString]];
//        [_webView loadRequest:request];
//    }
    [self.webView reload];
}
//后退
- (void)lastWebRequest
{
    [self.webView goBack];
}
//前进
- (void)forwordWebRequest
{
    [self.webView goForward];
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
*/
@end
