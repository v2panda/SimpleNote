
//
//  UIImage+PDAdd.m
//  SimpleNote
//
//  Created by Panda on 16/4/11.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "UIImage+PDAdd.h"

@implementation UIImage (PDAdd)
- (UIImage *)imageByResizeToSize:(CGSize)size {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    CGSize size = self.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    float scaleW = targetSize.width / width;
    float scaleH = targetSize.height / height;
    float scale = (scaleW>scaleH)?scaleH:scaleW;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    [self drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
@end
