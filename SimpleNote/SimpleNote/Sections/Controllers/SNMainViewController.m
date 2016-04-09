//
//  SNMainViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNMainViewController.h"
#import "SNNoteCell.h"
#import "NoteModel.h"
#import "RESideMenu.h"
#import "EditNoteViewController.h"

@interface SNMainViewController ()<
UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notesTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation SNMainViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.notesTableView registerNib:[UINib nibWithNibName:@"SNNoteCell" bundle:nil] forCellReuseIdentifier:@"SNNoteCellID"];
}

#pragma mark - UIScrollViewDelegate
CGFloat oldY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    oldY = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(scrollView.contentOffset.y > oldY) {
        self.bottomView.hidden = YES;
    }else {
        self.bottomView.hidden = NO;
    }
}

#pragma mark - event response
- (IBAction)leftBtnDidTouched:(UIBarButtonItem *)sender {
    if ([self respondsToSelector:@selector(presentLeftMenuViewController:)]) {
        [self presentLeftMenuViewController:nil];
    }
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNNoteCell *cell = [SNNoteCell cellWithTableView:tableView atIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第%@行笔记被点击了",@(indexPath.row));

    [self performSegueWithIdentifier:@"ToEditNoteSegue" sender:@(indexPath.row)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    if ([sender isKindOfClass:[UIButton class]]) {
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"添加笔记";
    }else {
        NSNumber *index = sender;
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"编辑笔记";
        vc.noteModel = self.dataArray[index.integerValue];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Delete");
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.notesTableView reloadData];
        
    }];
    deleteAction.backgroundColor = SNColor(0, 180, 87);
    
    return @[deleteAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    label.text = @"测试标题";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    return label;
}


#pragma mark - getters and setters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 2; i ++) {
            NoteModel *model = [NoteModel new];
            model.noteTitle = [NSString stringWithFormat:@"测试测试标题标题%@",@(i)];
            model.noteCreateTime = [NSString stringWithFormat:@"%@/%@/%@",@(i+10),@(i+2),@(i+5)];
            [_dataArray addObject:model];
        }
        
    }
    return _dataArray;
}


@end
