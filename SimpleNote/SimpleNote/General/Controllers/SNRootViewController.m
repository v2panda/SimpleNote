//
//  SNRootViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNRootViewController.h"

static CGFloat const kLeftPadding = 60.0;

@interface SNRootViewController ()

@end

@implementation SNRootViewController

- (void)awakeFromNib {
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    
    self.scaleContentView = NO;
    self.scaleBackgroundImageView = NO;
    self.scaleMenuView = NO;
    self.parallaxEnabled = NO;
    self.contentViewInPortraitOffsetCenterX = CGRectGetWidth([UIScreen mainScreen].bounds)/2.0 - kLeftPadding;
    self.bouncesHorizontally = NO;
    self.fadeMenuView = NO;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainBasicNavID"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SNLeftVCSBID"];
    self.delegate = self;
    
    
}

#pragma mark RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
    self.panGestureEnabled = NO;
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
    self.panGestureEnabled = YES;
}



@end
