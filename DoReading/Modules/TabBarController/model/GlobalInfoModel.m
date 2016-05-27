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
    return @{
             @"bookWebList":@"bookWebList",
             @"defaultBookWeb":@"defaultBookWeb"
             };
}

+ (NSValueTransformer *)bookWebListJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSDictionary *dic, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSArray *allKeys = dic.allKeys;
        for (NSUInteger i = 0; i < dic.count; i++) {
            NSDictionary *dict = dic[allKeys[i]];
            BookWebInfoModel *model = [MTLJSONAdapter modelOfClass:BookWebInfoModel.class fromJSONDictionary:dict error:nil];
            [dictionary setValue:model forKey:allKeys[i]];
        }
        return dictionary;
    } reverseBlock:^id(NSDictionary *dic, BOOL *success, NSError *__autoreleasing *error) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSArray *allKeys = dic.allKeys;
        for (NSUInteger i = 0; i < dic.count; i++) {
            BookWebInfoModel *model = dic[allKeys[i]];
            NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
            [dictionary setValue:dict forKey:allKeys[i]];
        }
        return dictionary;
    }];
}

+ (NSValueTransformer *)defaultBookWebTransformer
{
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSValueTransformer mtl_validatingTransformerForClass:BookWebInfoModel.class];
//    } reverseBlock:^id(BookWebInfoModel *model, BOOL *success, NSError *__autoreleasing *error) {
//        return [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
//    }];
}

@end

@implementation BookWebInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"webName":@"webName",
             @"baseUrl":@"baseUrl",
             @"param1":@"param1",
             @"variableParam":@"variableParam",
             @"param2":@"param2",
             };
}

@end