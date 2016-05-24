//
//  RegisterDetailViewController.m
//  SimpleNote
//
//  Created by Panda on 16/5/24.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "RegisterDetailViewController.h"

@interface RegisterDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nicknameTf;
@property (weak, nonatomic) IBOutlet UITextField *describeTf;


@end

@implementation RegisterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)nextBtnDidTouched:(UIButton *)sender {
    if ([NSString isBlankString:self.nicknameTf.text]) {
        kTipAlert(@"请输入昵称");
        return;
    }

    [[AVUser currentUser] setObject:self.nicknameTf.text forKey:@"nickName"];
    [[AVUser currentUser] saveInBackground];
    
    SNUserModel *model = [SNUserTool userInfo];
    model.nickName = self.nicknameTf.text;
    [SNUserTool saveUserInfo:model];
    
    if (![NSString isBlankString:self.describeTf.text]) {
        [[AVUser currentUser] setObject:self.describeTf.text forKey:@"describe"];
        [[AVUser currentUser] saveInBackground];
        SNUserModel *model = [SNUserTool userInfo];
        model.describe = self.describeTf.text;
        [SNUserTool saveUserInfo:model];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SNRootVCSBID"];
    [self presentViewController:vc animated:YES completion:nil];
    
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
