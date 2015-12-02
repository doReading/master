//
//  DRMacros.h
//  DoReading
//
//  Created by Wang Huiguang on 15/10/29.
//  Copyright © 2015年 ForHappy. All rights reserved.
//

#ifndef DRMacros_h
#define DRMacros_h

//单例
#undef IMP_SINGLETON
#define IMP_SINGLETON(_class)\
+(_class *)sharedInstance\
{\
static dispatch_once_t once;\
static _class *cs;\
dispatch_once(&once,^{\
cs = [[_class alloc] init];\
});\
return cs;\
}

//系统版本判断
#define IS_OS_6_OR_EARLIER         ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.99)
#define IS_OS_7_OR_EARLIER         ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.99)
#define IS_OS_7_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define IS_IPHONE                  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5                (IS_IPHONE && ([[UIScreen mainScreen] bounds].size.height == 568.0) &&  ((IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale) || !IS_OS_8_OR_LATER))
#define IS_STANDARD_IPHONE_6       (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0  && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale == [UIScreen mainScreen].scale)
#define IS_ZOOMED_IPHONE_6         (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale > [UIScreen mainScreen].scale)
#define IS_STANDARD_IPHONE_6_PLUS  (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0)
#define IS_ZOOMED_IPHONE_6_PLUS    (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0 && IS_OS_8_OR_LATER && [UIScreen mainScreen].nativeScale < [UIScreen mainScreen].scale)


#define IS_IPHONE_5_OR_BIGGER       (IS_IPHONE_5 || IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS || (SCREEN_HEIGHT >= 568.0))
#define IS_IPHONE_6_OR_BIGGER   (IS_STANDARD_IPHONE_6 || IS_ZOOMED_IPHONE_6 || IS_STANDARD_IPHONE_6_PLUS || IS_ZOOMED_IPHONE_6_PLUS || (SCREEN_HEIGHT >= 568.0 && !IS_IPHONE_5))

//获取屏幕大小
#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

//边缘距离
#define DR_MARGIN 15.f
//字体
//L1字体，例如section的title大小，标题，按钮
#define DR_FONT_L1         [UIFont systemFontOfSize:(IS_IPHONE_6_OR_BIGGER?20.f:19.f)]
#define DR_FONT_L1_BOLD    [UIFont boldSystemFontOfSize:(IS_IPHONE_6_OR_BIGGER?20.f:19.f)]
//L2字体，例如cell的name大小，常规
#define DR_FONT_L2         [UIFont systemFontOfSize:16.f]
#define DR_FONT_L2_BOLD    [UIFont boldSystemFontOfSize:16.f]
//L3字体，例如sectoin的sub title大小，提示
#define DR_FONT_L3         [UIFont systemFontOfSize:15.f]
//L4字体，例如cell的sub title大小，辅助
#define DR_FONT_L4         [UIFont systemFontOfSize:14.f]
//L5字体，最小，辅助
#define DR_FONT_L5         [UIFont systemFontOfSize:13.f]

//颜色
#define  COLOR_LIGHT [UIColor colorWithRed:37/255.0 green:74/255.0 blue:100/255.0 alpha:1]
#define  BACK_COLOR_GRAY [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1]
#define  COM_COLOR_BLUE [UIColor colorWithRed:23/255.0 green:152/255.0 blue:185/255.0 alpha:1]
#define  COLOR_BOOKCOVER_WARM [UIColor colorWithRed:194/255.0 green:117/255.0 blue:32/255.0 alpha:1]

//书本颜色207	140	76
#define  COLOR_BOOK_ORANGE [UIColor colorWithRed:203/255.0 green:165/255.0 blue:120/255.0 alpha:1]

#endif /* DRMacros_h */
