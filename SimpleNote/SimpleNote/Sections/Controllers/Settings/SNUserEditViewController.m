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
    
    self.title = @"个人简介";
    
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.clearsContextBeforeDrawing=YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(userInfoSaved)];
}

- (void)userInfoSaved {
    [[AVUser currentUser] setObject:self.textView.text forKey:@"describe"];
    [[AVUser currentUser] saveInBackground];
    SNUserModel *model = [SNUserTool userInfo];
    model.describe = self.textView.text;
    [SNUserTool saveUserInfo:model];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
