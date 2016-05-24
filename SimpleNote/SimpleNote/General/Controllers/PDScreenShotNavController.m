//
//  PDScreenShotNavController.m
//  SimpleNote
//
//  Created by v2panda on 16/5/24.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "PDScreenShotNavController.h"
#import "AppDelegate.h"

@interface PDScreenShotNavController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end
#define DISTANCE_TO_POP 80
@implementation PDScreenShotNavController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrayScreenshot = [NSMutableArray array];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //屏蔽系统的手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _panGesture.delegate = self;
    [self.view addGestureRecognizer:_panGesture];
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view) {
        CGPoint translate = [gestureRecognizer translationInView:self.view];
        
        BOOL possible = translate.x != 0 && fabs(translate.y) == 0;
        if (possible)
            return YES;
        else
            return NO;
        return YES;
    }
    return NO;
}

// 返回YES，意味着所有相同类型的手势辨认都会得到处理，可以同时接收两个事件。
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] ) //设置该条件是避免跟tableview的删除，筛选界面展开的左滑事件有冲突
    {
        return NO;
    }
    
    return YES;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVC = appdelegate.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    if (self.viewControllers.count == 1)
    {
        return;
    }
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        appdelegate.screenshotView.hidden = NO;
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point_inView = [panGesture translationInView:self.view];
        
        if (point_inView.x >= 10)
        {
            rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
            presentedVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= DISTANCE_TO_POP)
        {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(320, 0);
                presentedVC.view.transform = CGAffineTransformMakeTranslation(320, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
                appdelegate.screenshotView.hidden = YES;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
                presentedVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                appdelegate.screenshotView.hidden = YES;
            }];
        }
    }
}



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count == 0){
        return [super pushViewController:viewController animated:animated];
    }else if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;//隐藏二级页面的tabbar
    }
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // 创建一个基于位图的透明上下文（context）,并将其设置为当前上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(appdelegate.window.frame.size.width, appdelegate.window.frame.size.height), YES, 0);
    /**
     *  用于处理layer层，并且在layer层添加图片等图层
     如果贸然的添加图片 那么图片的边缘就会和背景图层有种分割感 不够自然
     render的意思是渲染
     所以它会使图片和背景图层在结合的地方更自然
     */
    [appdelegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 在此处截图
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.arrayScreenshot addObject:viewImage];
    appdelegate.screenshotView.imgView.image = viewImage;
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.arrayScreenshot removeLastObject];
    UIImage *image = [self.arrayScreenshot lastObject];
    
    if (image)
        appdelegate.screenshotView.imgView.image = image;
    UIViewController *v = [super popViewControllerAnimated:animated];
    return v;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.arrayScreenshot.count > 2)
    {
        [self.arrayScreenshot removeObjectsInRange:NSMakeRange(1, self.arrayScreenshot.count - 1)];
    }
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        appdelegate.screenshotView.imgView.image = image;
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSArray *arr = [super popToViewController:viewController animated:animated];
    
    if (self.arrayScreenshot.count > arr.count)
    {
        for (int i = 0; i < arr.count; i++) {
            [self.arrayScreenshot removeLastObject];
        }
    }
    return arr;
}


@end
