//
//  RegisterViewController.m
//  SimpleNote
//
//  Created by v2panda on 16/5/10.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - event response
- (IBAction)registerBtnDidTouched:(UIButton *)sender {
    if ([NSString isBlankString:self.usernameTf.text]) {
        kTipAlert(@"请输入用户名");
        return;
    }
    if ([NSString isBlankString:self.passwordTf.text]) {
        kTipAlert(@"请输入密码");
        return;
    }
    
    if (![self.passwordTf.text isPwd]) {
        kTipAlert(@"密码由6-20位数字、字母等组成");
        return;
    }
    if (![self.emailTf.text isValidEmail]) {
        kTipAlert(@"请输入正确的邮箱");
        return;
    }
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = self.usernameTf.text;// 设置用户名
    user.password =  self.passwordTf.text;// 设置密码
    user.email = self.emailTf.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [AVUser logInWithUsernameInBackground:self.usernameTf.text password:self.passwordTf.text block:^(AVUser *user, NSError *error) {
                if (user != nil) {
                    [SNUserTool getUserInfo];
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&Register" bundle:nil];
                    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterDetailViewControllerID"];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    NSLog(@"登录失败- %ld",error.code);
                }
            }];
        } else {
            NSLog(@"errorcode : %ld",error.code);
            if (error.code == 125) {
                kTipAlert(@"电子邮箱地址无效");
            }
            if (error.code == 202) {
                kTipAlert(@"用户名已经被占用");
            }
            if (error.code == 203) {
                kTipAlert(@"电子邮箱地址已经被占用");
            }
        }
    }];
}

@end
