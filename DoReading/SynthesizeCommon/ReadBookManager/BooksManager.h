//
//  BooksManager.h
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BooksManager : NSObject

@property (nonatomic, copy, readonly) NSString *bookStoreDirectory;

+ (instancetype)sharedInstance;

- (NSArray *)allBooksInfo;

@end
