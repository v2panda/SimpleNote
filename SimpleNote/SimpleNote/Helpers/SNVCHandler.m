//
//  JumpToOtherVCHandler.m
//  SimpleNote
//
//  Created by Panda on 16/10/27.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNVCHandler.h"

static NSString * const MainStoryBoard = @"Main";
static NSString * const LRStoryBoard = @"Login&Register";

@implementation SNVCHandler

+ (UIViewController *)getRootViewController {
    UIViewController *vc = [[UIStoryboard storyboardWithName:MainStoryBoard bundle:nil] instantiateViewControllerWithIdentifier:@"SNRootVCSBID"];
    return vc;
}

+ (UIViewController *)getLRViewController {
    UIViewController *vc = [[UIStoryboard storyboardWithName:LRStoryBoard bundle:nil] instantiateViewControllerWithIdentifier:@"Login&RegisterID"];
    return vc;
}

@end
