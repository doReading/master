//
//  BooksManager.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "BooksManager.h"

@interface BooksManager()

@property (nonatomic, copy, readonly) NSString *bookStoreDirectory;
@property (nonatomic, copy) NSString *booksLogPath;
@property (nonatomic, strong) NSMutableDictionary *booksLogDict;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation BooksManager

- (instancetype)instance
{
    self.lock = [[NSLock alloc] init];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    _bookStoreDirectory = [arr.firstObject stringByAppendingString:@"/FileStore/"];
    _booksLogPath = [arr.firstObject stringByAppendingString:@"/booksLog"];
    
    _booksLogDict = [self updateLocationLogNotAsyn];
    return self;
}

+ (instancetype)manager
{
    static BooksManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[[BooksManager alloc] init] instance];
        
    });
    return manager;
}

+(void)instanceSignalManager
{
    [BooksManager manager];
}

#pragma mark - 类方法，获得数据
+ (NSArray *)getAllBooksName
{
    BooksManager *manager = [BooksManager manager];
    return manager.booksLogDict.allKeys;
}

+ (void)bookModelFor:(NSString *)name completed:(Completed)completed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BooksManager *manager = [BooksManager manager];
        BookModel *model = manager.booksLogDict[name];
        completed(model);
    });
}

#pragma mark - 解码

+ (NSStringEncoding)encodingForData:(NSData *)data
{
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    if (data.length >= 2) {
        NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:2 encoding:gbkEncoding];
        if (str.length > 0) {
            return gbkEncoding;
        }
    }
    return 0;
}
#pragma mark - 输出
+ (void)bookDateFor:(NSString *)name completed:(void(^)(NSData *data,NSStringEncoding encode, NSError *error))completed
{
    BooksManager *manager = [BooksManager manager];
    NSString *path = [manager.bookStoreDirectory stringByAppendingPathComponent:name];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSStringEncoding encode;
    NSError *error = nil;
    [NSString stringWithContentsOfFile:path usedEncoding:&encode error:&error];
    if (error) {
        encode = [BooksManager encodingForData:data];
        if (encode == 0) {
            error = [[NSError alloc] initWithDomain:@"the file can't be encoded" code:566 userInfo:@{@"path":path}];
        }else {
           error = nil;
        }
    }

    completed(data,encode,error);
}

+ (void)bookModelsForAll:(void(^)(NSArray *modelArray))completed
{
    dispatch_async(dispatch_get_main_queue(), ^{
        BooksManager *manager = [BooksManager manager];
        if(manager.booksLogDict.count > 0) {
            completed(manager.booksLogDict.allValues);
        } else {
            completed(@[]);
        }
    });
}

#pragma mark - 获得所有书籍文件名
-(NSArray *)allBooksName
{
    NSArray *arr = [CFileHandle getContentsbyDir:self.bookStoreDirectory];
    if (arr == nil) {
        return [NSArray array];
    }
    return arr;
}

- (BookModel *)modelByName:(NSString *)name
{
    NSString *path = [_bookStoreDirectory stringByAppendingPathComponent:name];
    
    BookModel *model = [[BookModel alloc] init];
    model.bookName = name;
    model.state = DRBookPositionNone;
    model.bookSize = [CFileHandle getFileSize:path];
    return model;
}


- (BookModel *)modelByPath:(NSString *)path
{
    
    BookModel *model = [[BookModel alloc] init];
    model.bookName = [path getTotalName];
    model.state = DRBookPositionNone;
    model.bookSize = [CFileHandle getFileSize:path];

    return model;
}

- (NSMutableDictionary *)updateLocationLogNotAsyn
{
    NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
    //根据本地文件获取数据
    for (NSString *name in [self allBooksName]) {
        BookModel *model = [self modelByName:name];
        [updateDict setValue:model forKey:name];
    }
    
    //读取本地log
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_booksLogPath];
    if (dict == nil) {
        NSLog(@"读取数据不成功!!!");
        dict = [NSMutableDictionary dictionary];
    }
    for (NSString *key in dict.allKeys) {
        NSDictionary *d = dict[key];
        BookModel *model = updateDict[key];
        if (nil == model) {
            continue;
        }
        
        NSError *error = nil;
        BookModel *bookModel = [MTLJSONAdapter modelOfClass:[BookModel class] fromJSONDictionary:d error:&error];
        if (error) {
            NSLog(@"%@",error);
        }else {
            model.lastOpenTime = bookModel.lastOpenTime;
            model.bookMark = bookModel.bookMark;
            if (bookModel.encode > 0) {
                model.encode = bookModel.encode;
            }
            model.state = bookModel.state;
        }
    }
    
    [self store];
    return updateDict;
}

- (void)updateLocationLogWithDict:(void(^)(NSMutableDictionary *dictionary))complete
{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.booksLogDict = [self updateLocationLogNotAsyn];
        complete(self.booksLogDict);
    });
}

+ (void)updateLocationLogWithArray:(void(^)(NSArray *array))complete
{
    BooksManager *manager = [BooksManager manager];
    [manager updateLocationLogWithDict:^(NSMutableDictionary *dictionary) {
        if (dictionary.count > 0) {
            complete(dictionary.allValues);
        } else {
            complete(@[]);
        }
        
    }];
}

- (void)store
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);

        if (self.booksLogDict.count > 0) {
            if (self.booksLogPath.length > 0) {
                NSMutableDictionary *writeLog = [NSMutableDictionary dictionary];
                for (NSString *key in self.booksLogDict.allKeys) {
                    NSError *error = nil;
                    DownLogModel *model = self.booksLogDict[key];
                    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
                    if (!error && dict) {
                        [writeLog setObject:dict forKey:key];
                    }else {
                        NSLog(@"%@",error);
                    }
                }
                
                if (writeLog.count > 0) {
                    [self.lock lock];
                    [writeLog writeToURL:[NSURL fileURLWithPath:self.booksLogPath] atomically:YES];
                    [self.lock unlock];
                }
            }
        }
    });
}


@end
