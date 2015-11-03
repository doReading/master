//
//  DownloadLog.m
//  pyd
//
//  Created by Wang Huiguang on 15/10/29.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "DownloadLog.h"
#import "FileDownloadRequest.h"

@interface DownloadLog()

@property (nonatomic, copy) NSString *downHistoryDirectory;
//下载日志
@property (nonatomic, strong) NSMutableDictionary *downLogDict;
@end


@implementation DownloadLog

- (NSString *)downHistoryDirectory
{// 文件存储目录 Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths.firstObject;
    return document;
}

- (instancetype)init
{
    if (self = [super init]) {
        _downHistoryPath = [self.downHistoryDirectory stringByAppendingString:@"/downLog"];

        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:_downHistoryPath];
        if (dict == nil) {
            NSLog(@"读取数据不成功!!!");
            dict = [NSMutableDictionary dictionary];
        }
        
        _downLogDict = [NSMutableDictionary dictionary];
        
        for (NSString *key in dict.allKeys) {
            NSDictionary *d = [dict objectForKey:key];
            NSError *error = nil;
            DownLogModel *model = [MTLJSONAdapter modelOfClass:[DownLogModel class] fromJSONDictionary:d error:&error];
            [_downLogDict setObject:model forKey:key];
        }
        
    }
    return self;
}

#pragma mark - 单例
+ (DownloadLog *)sharedInstance
{
    static dispatch_once_t once;
    static DownloadLog *singleManager;
    dispatch_once(&once, ^{
        singleManager = [[DownloadLog alloc] init];
    });
    return singleManager;
}

#pragma mark - 设置下载目录
-(NSString *)fileDownloaderDirectory
{// 文件下载临时目录 Document/FileDownload
    static NSString *_fileDownloadDirectory;
    static dispatch_once_t onceToken;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths.firstObject;
    _fileDownloadDirectory = [document stringByAppendingString:@"/FileDownload/"];
    
    dispatch_once(&onceToken, ^{
        [CFileHandle createDirectoryAtPath:_fileDownloadDirectory];
    });
    return _fileDownloadDirectory;
}

- (NSString *)fileStoreDirectory
{// 文件存储目录 Document/FileStore
    static NSString *_fileStoreDirectory;
    static dispatch_once_t onceToken;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths.firstObject;
    _fileStoreDirectory = [document stringByAppendingString:@"/FileStore/"];
    
    dispatch_once(&onceToken, ^{
        [CFileHandle createDirectoryAtPath:_fileStoreDirectory];
    });
    return _fileStoreDirectory;
}

- (NSString *)getCachePathWith:(NSString *)name
{
    return [self.fileDownloaderDirectory stringByAppendingFormat:@"%@.downDR",name];
}

- (NSString *)getDownPathWith:(NSString *)name
{
    return [self.fileStoreDirectory stringByAppendingString:name];
}
#pragma mark - 存储信息到日志
- (BOOL)addToDownLog:(FileDownloadRequest *)request
{
    if (nil == request) {
        return NO;
    }
    
    if (![CFileHandle containFileAtPath:request.fileDownloadPath]) {
        DownLogModel *model = [[DownLogModel alloc] init];
        model.url = request.url;
        model.fileCachePath = request.fileCachePath;
        model.fileDownloadPath = request.fileDownloadPath;
        model.time = [NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]];
        model.state = DownOperationReadyState;
        
        if (model.fileDownloadPath.length > 0) {
            [self.downLogDict setObject:model forKey:[request getFileDownName]];
        }
        //存入本地
        [self storeDownLog];
        return YES;
    }
    
    return NO;
}

#pragma mark - 存储状态到日志
- (BOOL)addStateToDownLog:(NSString *)name state:(DownOperationState)state
{
    if (name.length > 0) {
        DownLogModel *model = [self.downLogDict objectForKey:name];
        if (nil != model) {
            model.state = state;
        }else {
            NSLog(@"error:%@对应模型解析失败",name);
        }
        [self storeDownLog];
    }
    return YES;
}

#pragma mark - 存储到本地
- (BOOL)storeDownLog
{
    if (self.downLogDict.count > 0) {
        if (self.downHistoryPath.length > 0) {
            NSMutableDictionary *writeLog = [NSMutableDictionary dictionary];
            for (NSString *key in self.downLogDict.allKeys) {
                NSError *error = nil;
                DownLogModel *model = self.downLogDict[key];
                NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
                if (!error && dict) {
                    [writeLog setObject:dict forKey:key];
                }else {
                    NSLog(@"model转化dict-->%@",error);
                }
            }
            
            if (writeLog.count > 0) {
                [writeLog writeToURL:[NSURL fileURLWithPath:self.downHistoryPath] atomically:YES];
                return YES;
            }
            return NO;
        }
    }
    return NO;
}

@end
