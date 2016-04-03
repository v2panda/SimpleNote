//
//  Common.h
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#ifndef Common_h
#define Common_h

/**是否3.5寸屏*/
#define is4s_Inch    ([UIScreen mainScreen].bounds.size.height == 480.0)
/**是否4寸屏 */
#define is5s_Inch    ([UIScreen mainScreen].bounds.size.height == 568.0)
/**是否4.7寸屏 */
#define is6_Inch     ([UIScreen mainScreen].bounds.size.height == 667.0)
/**是否5.5寸屏*/
#define is6plus_Inch    ([UIScreen mainScreen].bounds.size.height == 736)

/**自定义颜色*/
#define SNColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:255/255.0]

#endif /* Common_h */
