//
//  UIColor+VNHex.m
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "UIColor+VNHex.h"
#import "Colours.h"

@implementation UIColor (VNHex)

+ (UIColor *) colorWithHex:(NSInteger)rgbHexValue {
  return [UIColor colorWithHex:rgbHexValue alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)rgbHexValue
                    alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:((float)((rgbHexValue & 0xFF0000) >> 16))/255.0
                         green:((float)((rgbHexValue & 0xFF00) >> 8))/255.0
                          blue:((float)(rgbHexValue & 0xFF))/255.0
                         alpha:alpha];
}

+ (UIColor *)systemColor
{
  return [UIColor emeraldColor];
}

+ (UIColor *)systemDarkColor
{
  return [UIColor hollyGreenColor];
}

+ (UIColor *)grayBackgroudColor
{
  return [UIColor colorWithHex:0xF9FFFF];
}


@end