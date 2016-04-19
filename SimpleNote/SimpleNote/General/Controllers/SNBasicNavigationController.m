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

+ (void)initialize
{
    //设置导航条主题
    [self setupNavTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate =(id)self;
}
/**
 *  设置导航条主题
 */
+ (void)setupNavTheme {
    
    // 1.1.拿到appearance主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //设置导航栏底部线条
    [navBar setBarStyle:UIBarStyleBlack];
    
    // 2.设置导航条标题的属性
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    // 文字颜色
    md[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // 文字偏移位
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset  = CGSizeMake(0, 0);
    md[NSShadowAttributeName]= shadow;
    // 文字字体大小
    md[NSFontAttributeName] = [UIFont systemFontOfSize:20.f];
    [navBar setTitleTextAttributes:md];

}

@end
