//
//  DownLogModel.h
//  DoReading
//
//  Created by Wang Huiguang on 15/10/30.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "MTLModel.h"
typedef NS_ENUM(NSInteger, DownOperationState) {
    DownOperationPausedState      = -1,
    DownOperationUnkown           = 0,
    DownOperationReadyState       = 1,
    DownOperationExecutingState   = 2,
    DownOperationFinishedState    = 3,
};
@class DownLogInfoModel;

@interface DownLogModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, copy) NSString *fileCachePath;
@property (nonatomic, copy) NSString *fileDownloadPath;
@property (nonatomic, assign) DownOperationState state;

@end