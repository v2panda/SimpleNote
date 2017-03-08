//
//  SNFeedbackController.m
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNFeedbackController.h"
#import "UIAlertController+PDAdd.h"

@interface SNFeedbackController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SNFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.clearsContextBeforeDrawing=YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(feedbackUpload)];
}

- (void)feedbackUpload {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"感谢您的反馈！" preferredStyle:UIAlertControllerStyleAlert okActionBlock:^{
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            
            AVObject *feedback = [[AVObject alloc] initWithClassName:@"SNFeedbackData"];// 构建对象
            [feedback setObject:[AVUser currentUser].username forKey:@"name"];// 设置名称
            [feedback setObject:self.textView.text forKey:@"feedback"];
            [feedback setObject:@1 forKey:@"priority"];// 设置优先级
            [feedback saveInBackground];// 保存到服务端
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    } cancelActionShow:NO];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
