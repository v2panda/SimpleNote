//
//  AppDelegate.h
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDScreenShotView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PDScreenShotView *screenshotView;
- (void)reLaunching;
@end

