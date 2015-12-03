//
//  DRReadBookViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/12/2.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRReadBookViewController.h"

@interface DRReadBookViewController ()
//书籍内容
@property (nonatomic, copy) NSString *bookContent;

@property (nonatomic, strong) UILabel *bookLabel;
@property (nonatomic, assign) NSUInteger currentPosition;

@end

@implementation DRReadBookViewController

static NSUInteger wordNum = 200;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.deskBookModel.bookName;
    self.view.backgroundColor = COLOR_BOOK_ORANGE;
    
    _bookLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _bookLabel.userInteractionEnabled = YES;
    _bookLabel.textColor = [UIColor blackColor];
    _bookLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _bookLabel.adjustsFontSizeToFitWidth = YES;
    _bookLabel.numberOfLines = 0;
    _bookLabel.minimumScaleFactor = 10;
    [self.view addSubview:_bookLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTouchesRequired = 1;
    [_bookLabel addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)];
    [_bookLabel addGestureRecognizer:pan];
    
    
    @weakify(self);
    [BooksManager bookDateForLocatin:self.deskBookModel.bookName completed:^(NSData *data, NSStringEncoding encode, NSError *error) {
        @strongify(self);
        if (data == nil && error == nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此书已被删除" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        NSString *str = [[NSString alloc] initWithData:data encoding:encode];
        [self bookLabelWithContentString:str];
    }];
}

#pragma mark - 初始化内容
- (void)bookLabelWithContentString:(NSString *)str
{
    
    if (IS_IPHONE_6_OR_BIGGER) {
        wordNum = 220;
    }

    self.currentPosition = self.deskBookModel.bookMark;
    self.bookContent = str;
    [self bookLabelShowNextPageWithPosition:self.currentPosition];
}

- (void)bookLabelFont:(UIFont *)font currentPosition:(NSUInteger)position wordNum:(NSUInteger)words
{
    _bookLabel.font = font;
    _bookLabel.text = [self.bookContent substringWithRange:NSMakeRange(position, words)];
    [_bookLabel sizeToFit];
    self.currentPosition = position;
    [self bookShowedNext];
}

- (void)bookLabelShowNextPageWithPosition:(NSUInteger)currentPosition
{
    _bookLabel.text = [self.bookContent substringWithRange:NSMakeRange(currentPosition, wordNum)];
    [_bookLabel sizeToFit];
    self.currentPosition = currentPosition;
    [self bookShowedNext];
}

//显示下一页，会自动增加 当前位置currentPosition
- (void)bookLabelShowNextPage
{
    self.currentPosition = self.currentPosition + wordNum;
    if (self.currentPosition + wordNum > self.bookContent.length) {
        [self bookLabelShowNextPageWithPosition:self.bookContent.length - wordNum];
        return;
    }
    _bookLabel.text = [self.bookContent substringWithRange:NSMakeRange(self.currentPosition, wordNum)];
    [_bookLabel sizeToFit];
    [self bookShowedNext];
}

//显示上一页，会自动减少 当前位置currentPosition
- (void)bookLabelShowLastPage
{
    if (self.currentPosition < wordNum) {
        [self bookLabelShowNextPageWithPosition:0];
        return;
    }
    self.currentPosition = self.currentPosition - wordNum;
    
    _bookLabel.text = [self.bookContent substringWithRange:NSMakeRange(self.currentPosition, wordNum)];
    [_bookLabel sizeToFit];
    [self bookShowedNext];
}

//翻页后存储
- (void)bookShowedNext
{
    self.deskBookModel.bookMark = self.currentPosition;
    [BooksManager storeDeskLog];
}

#pragma mark - UIGesture
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_bookLabel];
    if (tap.state == UIGestureRecognizerStateEnded) {
        if (point.x >= _bookLabel.width/2) {
            [self bookLabelShowNextPage];
        }else {
            [self bookLabelShowLastPage];
        }
    }
}

- (void)panClick:(UIPanGestureRecognizer *)pan
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
