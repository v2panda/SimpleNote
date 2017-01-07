//
//  ForgetPWViewController.m
//  SimpleNote
//
//  Created by v2panda on 2017/1/6.
//  Copyright © 2017年 v2panda. All rights reserved.
//

#import "ForgetPWViewController.h"

@interface ForgetPWViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UIButton *findButton;

@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - event response
- (IBAction)findButtonDidTouched:(UIButton *)sender {
    if (!self.emailTextfield.text.length) {
        kTipAlert(@"请先输入邮箱");
        return;
    }
    if (![self isValidEmail:self.emailTextfield.text]) {
        self.emailTextfield.text = @"";
        kTipAlert(@"请输入正确的邮箱地址");
        return;
    }
    [AVUser requestPasswordResetForEmailInBackground:self.emailTextfield.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            kTipAlert(@"已向该邮箱发送重置邮件，注意查收！");
        } else {
            NSLog(@"errorcode : %ld",error.code);
            if (error.code == 205) {
                kTipAlert(@"该用户尚未注册");
            }
        }
    }];
}

- (BOOL)isValidEmail:(NSString *)email {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:email];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self isValidEmail:textField.text]) {
        textField.text = @"";
        kTipAlert(@"请输入正确的邮箱地址");
    }
}


@end
