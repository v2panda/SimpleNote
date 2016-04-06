//
//  SNBasicViewController.m
//  SimpleNote
//
//  Created by Panda on 16/4/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNBasicViewController.h"

@interface SNBasicViewController ()

@end

@implementation SNBasicViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
