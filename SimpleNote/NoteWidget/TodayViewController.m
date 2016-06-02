//
//  TodayViewController.m
//  NoteWidget
//
//  Created by v2panda on 16/6/2.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addNoteButton.layer.cornerRadius = 5;
    self.addNoteButton.layer.masksToBounds  = YES;
    
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.simplenote.v2panda"];
    NSString* allNotebooks = [userDefault objectForKey:@"group.simplenote.v2panda.allNotebooks"];
    if (allNotebooks) {
        self.titleLabel.text = [NSString stringWithFormat:@"已记录了30条笔记在%@个笔记本上。",allNotebooks];
    }

}

- (IBAction)addNoteButtonDidTouched:(UIButton *)sender {
    
    [self.extensionContext openURL:[NSURL URLWithString:@"SimpleNoteWidget://action=GotoAddNote"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
    
}



- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
