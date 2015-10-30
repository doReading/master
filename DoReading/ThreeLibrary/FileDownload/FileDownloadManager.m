//
//  FileDownloadManager.m
//  pyd
//
//  Created by Wang Huiguang on 15/10/29.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "FileDownloadManager.h"
#import "DownloadLog.h"

// 超时时间
#define DEAULT_DOWNLOADER_TIMEOUT 12.f
// 最大并发数
#define DEAULT_DOWNLOADER_MAX_CONCURRENT 5



@interface FileDownloadManager ()

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *requestQueue;
@property (nonatomic, strong) NSMutableDictionary *waitingQueue;

//- (void)startFileDownloadRequest:(FileDownloadRequest *)request withURL:(NSURL *)url;
- (void)finishFileDownloadWithURL:(NSURL *)url;
- (BOOL)isDownloadingFileWithURL:(NSURL *)url;

@end

@implementation FileDownloadManager

+ (FileDownloadManager *)sharedInstance
{
    static dispatch_once_t once;
    static FileDownloadManager *singleManager;
    dispatch_once(&once, ^{
        singleManager = [[FileDownloadManager alloc] init];
    });
    return singleManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.timeout = DEAULT_DOWNLOADER_TIMEOUT;
        self.maxConCurrent = DEAULT_DOWNLOADER_MAX_CONCURRENT;
        
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.operationQueue.maxConcurrentOperationCount = self.maxConCurrent;
        self.requestQueue = [NSMutableDictionary dictionary];
        self.waitingQueue = [NSMutableDictionary dictionary];
    }
    return self;
}
#pragma mark - 设置最大链接数
- (void)setMaxConCurrent:(NSUInteger)maxConCurrent
{
    if (_maxConCurrent != maxConCurrent) {
        _maxConCurrent = maxConCurrent;
        self.operationQueue.maxConcurrentOperationCount = self.maxConCurrent;
    }
}

#pragma mark - 下载方法
- (void)downloadFileWithURL:(NSURL *)url
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    //默认使用缓存
    [self downloadFileWithURL:url
                         name:[[url absoluteString] getTotalName]
              completionBlock:completionBlock];
}


- (void)downloadFileWithURL:(NSURL *)url
                       name:(NSString *)name
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    //默认使用缓存
    [self downloadFileWithURL:url
                         name:(NSString *)name
                     useCache:NO
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                       name:(NSString *)name
                   useCache:(BOOL)useCache
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    //默认不设置进度
    [self downloadFileWithURL:url
                         name:name
                     useCache:useCache
                progressBlock:NULL
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                       name:(NSString *)name
                   useCache:(BOOL)useCache
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    //默认不重新下载
    [self downloadFileWithURL:url
                         name:name
                     priority:NSOperationQueuePriorityNormal
                     useCache:useCache
                  allowResume:YES
                progressBlock:progresBlock
              completionBlock:completionBlock];
}

- (void)downloadFileWithURL:(NSURL *)url
                       name:(NSString *)name
                   priority:(NSOperationQueuePriority)priority
                   useCache:(BOOL)useCache
                allowResume:(BOOL)allowResume
              progressBlock:(FileDownloadProgressBlock)progresBlock
            completionBlock:(FileDownloadCompletionBlock)completionBlock
{
    FileDownloadRequest *request = [FileDownloadRequest downloadRequestWithURL:url
                                                                          name:name
                                                                       timeout:self.timeout
                                                                      priority:priority
                                                                      useCache:useCache
                                                                   allowResume:allowResume
                                                                 progressBlock:^(NSURL *url, CGFloat progress) {
                                                                     if (progresBlock) {
                                                                         progresBlock(url, progress);
                                                                     }
                                                                 } completionBlock:^(NSURL *url, NSURL *filePath, BOOL hitCache, NSError *error) {
                                                                     //存储到日志：下载完成
                                                                     [[DownloadLog sharedInstance] addStateToDownLog:filePath.path state:DownOperationFinishedState];
                                                                     
                                                                     if (completionBlock) {
                                                                         completionBlock(url, filePath, error);
                                                                     }
                                                                     if (!hitCache) {
                                                                         [self finishFileDownloadWithURL:url];
                                                                     }
                                                                 }];
    if (request) {
        // 相同文件的下载请求需排队
        if ([self isDownloadingFileWithURL:url]) {
            NSMutableArray *queue = self.waitingQueue[url];
            if (!queue) {
                queue = [NSMutableArray array];
                self.waitingQueue[url] = queue;
            }
            [queue addObject:request];
        } else {
            [self startFileDownloadRequest:request withURL:url];
        }
    }
}

- (void)startFileDownloadRequest:(FileDownloadRequest *)request withURL:(NSURL *)url
{
    [self.requestQueue setObject:request forKey:url];
    if (request.operation) {
        [self.operationQueue addOperation:request.operation];
        DownloadLog *downlog = [DownloadLog sharedInstance];
        //存储到下载日志
        [downlog addToDownLog:request];
    }
}

- (void)finishFileDownloadWithURL:(NSURL *)url
{
    [self.requestQueue removeObjectForKey:url];
    //
    NSMutableArray *queue = self.waitingQueue[url];
    if ([queue count]) {
        FileDownloadRequest *nextRequest = [queue firstObject];
        [queue removeObjectAtIndex:0];
        if (![queue count]) {
            [self.waitingQueue removeObjectForKey:url];
        }
        [self startFileDownloadRequest:nextRequest withURL:url];
    }
}

- (void)cancelDownloadFileWithURL:(NSURL *)url
{
    FileDownloadRequest *request = self.requestQueue[url];
    if (request) {
        [request.operation cancel];
    }
}

- (BOOL)isDownloadingFileWithURL:(NSURL *)url
{
    if (!url) {
        return NO;
    }
    return (BOOL)[self.requestQueue objectForKey:url];
}
@end
