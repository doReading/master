//
//  BooksManager.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "BooksManager.h"

@implementation BooksManager

+(instancetype)sharedInstance
{
    static BooksManager *manager;
    static NSString *directory;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[BooksManager alloc] init];
        NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        directory = [arr.firstObject stringByAppendingString:@"/FileStore/"];
        [manager setStoreDirectory:directory];
    });
    return manager;
}

+ (instancetype)manager
{
    return [BooksManager sharedInstance];
}

- (void)setStoreDirectory:(NSString *)path
{
    _bookStoreDirectory = path;
}

-(NSArray *)allBooksInfo
{
    NSArray *arr = [CFileHandle getContentsbyDir:self.bookStoreDirectory];
    if (arr == nil) {
        return [NSArray array];
    }
    return arr;
}

@end
