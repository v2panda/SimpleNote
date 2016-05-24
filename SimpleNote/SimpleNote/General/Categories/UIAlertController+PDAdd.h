//
//  UIAlertController+PDAdd.h
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (PDAdd)
+ (UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle okActionBlock:(void (^)())actionBlock cancelActionShow:(BOOL)show;

@end
