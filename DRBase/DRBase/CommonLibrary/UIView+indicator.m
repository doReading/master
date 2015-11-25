//
//  UIView+indicator.m
//  DRBase
//
//  Created by Wang Huiguang on 15/11/25.
//  Copyright © 2015年 forHappy. All rights reserved.
//

#import "UIView+indicator.h"
#import "DRIndicator.h"

@implementation UIView (indicator)

// 展示转标（立即展现）
- (void)showIndicator
{
    
}

// 关闭转标（同时清除placeholder）
- (void)dismissIndicator
{
    
}

// 展示Placeholder（独立接口）
- (void)showPlaceholder:(NSString *)title
{
    
}

// 清除Placeholder（独立接口）
- (void)removePlaceholder
{
    
}

#pragma mark - objc_setAssociatedObject & objc_getAssociatedObject

- (id)indicator
{
    return objc_getAssociatedObject(self, @selector(indicator));
}

- (void)setIndicator:(UIView *)indicator
{
    objc_setAssociatedObject(self, @selector(indicator), indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
