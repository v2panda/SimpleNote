//
//  SNMainViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNMainViewController.h"
#import "NoteCell.h"
#import "AMScrollingNavbar.h"

@interface SNMainViewController ()<
UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notesTableView;

@end

@implementation SNMainViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self followScrollView:self.notesTableView withDelay:20.0];
}


#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [NoteCell cellWithTableView:tableView atIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"第%@行",@(indexPath.row)];
    if (indexPath.row == 2) {
        
    }
    
    return cell;
}


@end
