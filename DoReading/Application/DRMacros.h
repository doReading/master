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
-(_class *)sharedInstance\
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

#endif /* DRMacros_h */
