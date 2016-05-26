//
//  GlobalInfoModel.m
//  DoReading
//
//  Created by Wang Huiguang on 16/5/26.
//  Copyright © 2016年 ForHappy. All rights reserved.
//

#import "GlobalInfoModel.h"

@implementation GlobalInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (NSValueTransformer *)bookWebListJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *arr, BOOL *success, NSError *__autoreleasing *error) {
        if (*success) {
            return [NSMutableArray arrayWithArray:[MTLJSONAdapter modelsOfClass:BookWebInfoModel.class fromJSONArray:arr error:error]];
        }else {
            return nil;
        }
    }];
}

@end

@implementation BookWebInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

@end