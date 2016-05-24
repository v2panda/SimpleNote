//
//  SNUserEditViewController.m
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNUserEditViewController.h"

@interface SNUserEditViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SNUserEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"描述";
    
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.clearsContextBeforeDrawing=YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(userInfoSaved)];
}

- (void)userInfoSaved {
    NSLog(@"存储信息");
    
    [[AVUser currentUser] setObject:self.textView.text forKey:@"describe"];
    [[AVUser currentUser] saveInBackground];
    SNUserModel *model = [SNUserTool userInfo];
    model.describe = self.textView.text;
    [SNUserTool saveUserInfo:model];
    
    [self.navigationController popViewControllerAnimated:YES];
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
