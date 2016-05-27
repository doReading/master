//
//  GlobalInfoModel.h
//  DoReading
//
//  Created by Wang Huiguang on 16/5/26.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

#import <Mantle/Mantle.h>
@class BookWebInfoModel;

//全局变量
@interface GlobalInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSMutableDictionary *bookWebList;

@property (nonatomic, strong) BookWebInfoModel *defaultBookWeb;

@end

@interface BookWebInfoModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *webName;

@property (nonatomic, copy) NSString *baseUrl;

@property (nonatomic, copy) NSString *param1;

@property (nonatomic, copy) NSString *variableParam;

@property (nonatomic, copy) NSString *param2;

@end


