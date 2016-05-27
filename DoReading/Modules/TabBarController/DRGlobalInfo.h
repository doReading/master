//
//  DRGlobalInfo.h
//  DoReading
//
//  Created by Wang Huiguang on 16/5/26.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

@class BookWebInfoModel;

@interface DRGlobalInfo : NSObject

@property (nonatomic, strong) NSMutableDictionary *bookWebList;
@property (nonatomic, strong) BookWebInfoModel *defaultBookWeb;

+ (DRGlobalInfo *)sharedInstance;

- (void)initBaseInfo;

@end
