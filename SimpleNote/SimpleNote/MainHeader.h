//
//  MainHeader.h
//  SimpleNote
//
//  Created by 徐臻 on 15/3/10.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#ifndef SimpleNote_MainHeader_h
#define SimpleNote_MainHeader_h


#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
//默认颜色
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DefaultColor RGB(22, 191, 255)
#define DefaultRed RGB(224, 51, 51)
#define DefaultYellow RGB(133 , 132, 116)
#define DefaultGreen RGB(34, 181, 115)
#define DefaultBlack RGB(0, 0, 0)


//导入头文件
#import "NoteListController.h"
#import "SCLAlertView.h"
#import "KWPopoverView.h"


#endif
