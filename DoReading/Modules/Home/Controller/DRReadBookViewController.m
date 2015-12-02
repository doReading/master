//
//  DRReadBookViewController.m
//  DoReading
//
//  Created by Wang Huiguang on 15/12/2.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "DRReadBookViewController.h"

@interface DRReadBookViewController ()

@property (nonatomic, copy) NSString *bookContent;

@property (nonatomic, strong) UILabel *bookLabel;

@end

@implementation DRReadBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.deskBookModel.bookName;
    self.view.backgroundColor = COLOR_BOOK_ORANGE;
    
    _bookLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _bookLabel.textColor = [UIColor blackColor];
    _bookLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _bookLabel.adjustsFontSizeToFitWidth = YES;
    _bookLabel.numberOfLines = 0;
    _bookLabel.minimumScaleFactor = 10;
    [self.view addSubview:_bookLabel];
    
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
        [self bookLabelTextWithFont:self.bookLabel.font withContentString:str];
    }];
}

- (void)bookLabelTextWithFont:(UIFont *)font withContentString:(NSString *)str
{
    static NSInteger num = 190;
    num += 10;
    self.bookLabel.text = [str substringToIndex:num];
    self.bookContent = str;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
