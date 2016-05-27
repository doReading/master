//
//  DRGlobalInfo.m
//  DoReading
//
//  Created by Wang Huiguang on 16/5/26.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

#import "DRGlobalInfo.h"
#import "GlobalInfoModel.h"

@interface DRGlobalInfo()
@property (nonatomic, copy) NSString *globalDir;
@property (nonatomic, strong) GlobalInfoModel *globalModel;

@end

@implementation DRGlobalInfo

IMP_SINGLETON(DRGlobalInfo)

- (NSString *)globalInfoDirectory
{// 文件存储目录 Document
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = paths.firstObject;
    return document;
}

- (void)initBaseInfo
{
    self.globalDir = [self.globalInfoDirectory stringByAppendingString:@"/globalInfo"];
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:self.globalDir];
    
    if (infoDict.count > 0) {
        NSError *error = nil;
        self.globalModel = [MTLJSONAdapter modelOfClass:GlobalInfoModel.class fromJSONDictionary:infoDict error:&error];
        if (error) {
            NSAssert(NO, @"%@",error);
        }
    }else {
        self.globalModel = [GlobalInfoModel new];
        self.globalModel.bookWebList = [NSMutableDictionary dictionary];
    }
    
    BookWebInfoModel *model = [BookWebInfoModel new];
    model.webName = @"qingkan";
    model.baseUrl = @"http://www.qingkan520.com/";
    model.param1 = @"book/";
    model.variableParam = @"";
    model.param2 = @"txt.html";
    
    BOOL store = NO;
    if (self.globalModel.defaultBookWeb == nil) {
        self.globalModel.defaultBookWeb = model;
        store = YES;
    }
    if(![self.globalModel.bookWebList containKey:model.webName]) {
        [self.globalModel.bookWebList setObject:model forKey:model.webName];
        store = YES;
    }
    
    if (store) {
        [self storeGeneralInfo];
    }
}

- (NSMutableDictionary *)bookWebList
{
    return self.globalModel.bookWebList;
}

- (void)setBookWebList:(NSMutableDictionary *)bookWebList
{
    self.globalModel.bookWebList = bookWebList;
    [self storeGeneralInfo];
}

- (BookWebInfoModel *)defaultBookWeb
{
    return self.globalModel.defaultBookWeb;
}

-(void)setDefaultBookWeb:(BookWebInfoModel *)defaultBookWeb
{
    self.globalModel.defaultBookWeb = defaultBookWeb;
    [self storeGeneralInfo];
}

- (void)storeGeneralInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.globalModel) {
            NSError *error = nil;
            NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:self.globalModel error:&error];
            if (!error) {
                [dict writeToURL:[NSURL fileURLWithPath:self.globalDir] atomically:YES];
            }
        }
    });
}

@end
