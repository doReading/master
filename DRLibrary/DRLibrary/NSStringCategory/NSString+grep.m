//
//  NSString+grep.m
//  pyd
//
//  Created by Wang Huiguang on 15/10/27.
//  Copyright © 2015年 iOS. All rights reserved.
//

#import "NSString+grep.h"

@implementation NSString (grep)
- (BOOL)isStringForGrep:(NSString *)grep
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", grep];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)getTotalName
{
    return [self componentsSeparatedByString:@"/"].lastObject;
}

- (NSString *)getName
{
    NSRange range = [self rangeOfString:@"." options:NSBackwardsSearch];
    if (range.length > 0 && range.location > 0){
        return [self substringToIndex:range.location];
    } else {
        return self;
    }
}

- (NSString *)getExtendName
{
    return [self componentsSeparatedByString:@"."].lastObject;
}

@end
