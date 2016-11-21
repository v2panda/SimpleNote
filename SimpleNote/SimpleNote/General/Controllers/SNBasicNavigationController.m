//
//  SNBasicNavigationController.m
//  SimpleNote
//
//  Created by Panda on 16/4/6.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNBasicNavigationController.h"

@interface SNBasicNavigationController ()

@end

@implementation SNBasicNavigationController

+ (void)initialize {
    //设置导航条主题
    [self setupNavTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)setupNavTheme {
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarStyle:UIBarStyleBlack];
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];

    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset  = CGSizeMake(0, 0);
    md[NSShadowAttributeName]= shadow;

    md[NSFontAttributeName] = [UIFont systemFontOfSize:20.f];
    [navBar setTitleTextAttributes:md];
}

@end
