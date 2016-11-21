//
//  UIImage+PDAdd.h
//  SimpleNote
//
//  Created by Panda on 16/4/11.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PDAdd)

- (UIImage *)imageByResizeToSize:(CGSize)size;

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end

