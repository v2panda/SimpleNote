//
//  UIColor+VNHex.h
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (VNHex)

+ (UIColor *) colorWithHex:(NSInteger)rgbHexValue;

+ (UIColor *) colorWithHex:(NSInteger)rgbHexValue alpha:(CGFloat)alpha;

+ (UIColor *)systemColor;

+ (UIColor *)systemDarkColor;

+ (UIColor *)grayBackgroudColor;

@end
