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
    }
    
    if(self.globalModel.bookWebList.count == 0) {
        BookWebInfoModel *model = [BookWebInfoModel new];
        model.baseUrl = @"http://www.qingkan520.com/";
        model.param1 = @"book/";
        model.param2 = @"txt.html";
        self.globalModel.bookWebList = [NSMutableArray arrayWithObject:model];
    }
}

- (NSMutableArray *)bookWebList
{
    return self.globalModel.bookWebList;
}

- (void)setBookWebList:(NSMutableArray *)bookWebList
{
    self.globalModel.bookWebList = bookWebList;
}

@end
