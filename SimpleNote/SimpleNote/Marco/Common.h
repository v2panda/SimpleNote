//
//  Common.h
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Common_h
#define Common_h

#ifdef DEBUG
#define NSLog(...)          NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

/**是否3.5寸屏*/
#define is4s_Inch    ([UIScreen mainScreen].bounds.size.height == 480.0)
/**是否4寸屏 */
#define is5s_Inch    ([UIScreen mainScreen].bounds.size.height == 568.0)
/**是否4.7寸屏 */
#define is6_Inch     ([UIScreen mainScreen].bounds.size.height == 667.0)
/**是否5.5寸屏*/
#define is6plus_Inch    ([UIScreen mainScreen].bounds.size.height == 736)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**自定义颜色*/
#define SNColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255/255.0]


/**NSUserDefaults 实例化*/
#define USER_DEFAULT [NSUserDefaults standardUserDefaults];
/**NSUserDefaults 读取设置*/
#define USER_DEFAULT_VALUEFOR(key) [[NSUserDefaults standardUserDefaults] valueForKey:(key)]
/**NSUserDefaults 写入设置*/
#define USER_DEFAULT_SET(value,key) [[NSUserDefaults standardUserDefaults] setObject:(value) forKey:(key)];
/**NSUserDefaults*/
#define USER_DEFAULT_SYNCHRONIZE [[NSUserDefaults standardUserDefaults] synchronize];


/** weakify - strongify **/
//#define weakify(var) __weak typeof(var) SNWeak_##var = var;
//#define strongify(var) \
//_Pragma("clang diagnostic push") \
//_Pragma("clang diagnostic ignored \"-Wshadow\"") \
//__strong typeof(var) var = SNWeak_##var; \
//_Pragma("clang diagnostic pop")



/**kTipAlert**/
#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#endif /* Common_h */
