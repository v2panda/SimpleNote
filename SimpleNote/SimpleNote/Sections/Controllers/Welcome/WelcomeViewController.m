//
//  WelcomeViewController.m
//  SimpleNote
//
//  Created by Panda on 16/4/20.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "WelcomeViewController.h"
#import "StepOneViewController.h"
#import "StepTwoViewController.h"
#import "StepThreeViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) NSArray<UIViewController *> *steps;
@end

@implementation WelcomeViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.scrollView.alpha = 0;
    self.pageControl.alpha = 0;
    self.loginBtn.alpha = 0;
    self.registerBtn.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.scrollView.alpha = 1;
        self.pageControl.alpha = 1;
        self.loginBtn.alpha = 1;
        self.registerBtn.alpha = 1;
    } completion:nil];
}

#pragma mark - privatemethod 
- (void)makeUI {
    
    self.steps = @[[self stepOne],[self stepTwo],[self stepThree]];
    
    self.pageControl.numberOfPages = self.steps.count;
    self.pageControl.pageIndicatorTintColor = SNColor(229, 229, 299);
    self.pageControl.currentPageIndicatorTintColor = SNColor(50, 167, 255);

    self.scrollView.contentSize = CGSizeMake(self.view.width * self.steps.count, 0);

}

- (StepOneViewController *)stepOne {
    StepOneViewController *step = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateViewControllerWithIdentifier:@"StepOneViewController"];
    step.view.x = 0;
    [self.scrollView addSubview:step.view];
    
    return step;
}

- (StepTwoViewController *)stepTwo {
    StepTwoViewController *step = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateViewControllerWithIdentifier:@"StepTwoViewController"];
    step.view.x = step.view.width;
    [self.scrollView addSubview:step.view];
    return step;
}

- (StepThreeViewController *)stepThree {
    StepThreeViewController *step = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateViewControllerWithIdentifier:@"StepThreeViewController"];
    step.view.x = step.view.width * 2;
    [self.scrollView addSubview:step.view];
    return step;
}


#pragma mark - event response
- (IBAction)loginBtnDidTouched:(UIButton *)sender {
    NSLog(@"loginBtnDidTouched");
}

- (IBAction)registerBtnDidTouched:(UIButton *)sender {
    NSLog(@"registerBtnDidTouched");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.bounds);
    CGFloat pageFraction = scrollView.contentOffset.x / pageWidth;
    
    CGFloat page = (int)round(pageFraction);
    
    self.pageControl.currentPage = page;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
