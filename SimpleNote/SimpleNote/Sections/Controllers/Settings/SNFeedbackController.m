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
    NSLog(@"存储信息");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"感谢您的反馈！" preferredStyle:UIAlertControllerStyleAlert okActionBlock:^{
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } cancelActionShow:NO];
    [self presentViewController:alertController animated:YES completion:nil];
    
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
