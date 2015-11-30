//
//  BooksManager.h
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookModel.h"

typedef void (^Completed)(BookModel *completed);

@interface BooksManager : NSObject

+(void)instanceSignalManager;

+ (NSArray *)getAllBooksName;

+ (void)bookModelFor:(NSString *)name completed:(Completed)completed;
+ (void)bookDateFor:(NSString *)name completed:(void(^)(NSData *data,NSStringEncoding encode, NSError *error))completed;
+ (void)bookModelsForAll:(void(^)(NSArray *modelArray))completed;
+ (void)updateLocationLogWithArray:(void(^)(NSArray *array))complete;
@end
