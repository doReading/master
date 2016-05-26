//
//  DRGlobalInfo.h
//  DoReading
//
//  Created by Wang Huiguang on 16/5/26.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

@interface DRGlobalInfo : NSObject

@property (nonatomic, strong) NSMutableArray *bookWebList;

+ (DRGlobalInfo *)sharedInstance;

- (void)initBaseInfo;

@end
