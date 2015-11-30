//
//  bookModel.m
//  DoReading
//
//  Created by Wang Huiguang on 15/11/27.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#import "BookModel.h"

@implementation BookModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bookName":@"bookName",
             @"lastOpenTime":@"lastOpenTime",
             @"bookMark":@"bookMark",
             @"state":@"state",
             @"bookSize":@"bookSize"
             };
}

+ (NSValueTransformer *)stateJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                               @0:@(DRBookPositionNone),
                                               @1:@(DRBookPositionReading),
                                               @2:@(DRBookPositionLayDown)} defaultValue:DRBookPositionNone reverseDefaultValue:DRBookPositionNone];
}

@end
