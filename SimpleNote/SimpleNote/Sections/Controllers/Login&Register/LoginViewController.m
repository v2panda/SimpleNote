//
//  LoginViewController.m
//  SimpleNote
//
//  Created by v2panda on 16/5/10.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@end

@implementation LoginViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - event response
- (IBAction)loginBtnDidTouched:(UIButton *)sender {
    
    if ([NSString isBlankString:self.userNameTf.text]) {
        kTipAlert(@"请输入用户名");
        return;
    }
    if ([NSString isBlankString:self.passwordTf.text]) {
        kTipAlert(@"请输入密码");
        return;
    }
    
    [AVUser logInWithUsernameInBackground:self.userNameTf.text password:self.passwordTf.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [SNUserTool getUserInfo];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SNRootVCSBID"];
            [self presentViewController:vc animated:YES completion:nil];
        } else {
            NSLog(@"errorcode : %ld",error.code);
            if (error.code == 210) {
                kTipAlert(@"用户名和密码不匹配");
            }
            if (error.code == 211) {
                kTipAlert(@"此用户不存在");
            }
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
