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
#import "NoteBookModel.h"
#import "SNRealmHelper.h"



@interface SNMainViewController ()<
UITableViewDataSource,
UITableViewDelegate,
EditNoteEndedDelegate>

@property (weak, nonatomic) IBOutlet UITableView *notesTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *headers;
@property (nonatomic, strong) NSMutableArray *totalArray;

@end


@implementation SNMainViewController
@synthesize dataArray = _dataArray;

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openNoteBook:) name:kOpenNoteBook object:nil];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.notesTableView.tableFooterView = [UIView new];
    [self.notesTableView registerNib:[UINib nibWithNibName:@"SNNoteCell" bundle:nil] forCellReuseIdentifier:@"SNNoteCellID"];
}


#pragma mark - UIScrollViewDelegate
CGFloat contentOffsetY = 0;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        if (scrollView.contentOffset.y - contentOffsetY > 5.0) {
            // 向上拖拽 隐藏
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.transform = CGAffineTransformMakeTranslation(0, self.bottomView.height);
            }];
        } else if (contentOffsetY - scrollView.contentOffset.y > 5.0) {
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 滚动到底部后 显示
    CGFloat space = scrollView.contentOffset.y + SCREEN_HEIGHT - scrollView.contentSize.height;
    if (space > -5 && space < 5 ){
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.transform = CGAffineTransformIdentity;
        }];
    }
}


#pragma mark - EditNoteEndedDelegate
- (void)reloadNotes {
    self.dataArray = [SNRealmHelper readAllNotesFromNotebook];
    [self.notesTableView reloadData];
}

#pragma mark - event response
- (void)openNoteBook:(NSNotification *)notification {
    self.dataArray = [SNRealmHelper readAllNotesFromNotebook];
    
    [self.notesTableView reloadData];
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        NSArray *array = (NSArray *)self.totalArray[section];
        return array.count;
    }
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = (NSArray *)self.totalArray[indexPath.section];
    SNNoteCell *cell = [SNNoteCell cellWithTableView:tableView atIndexPath:indexPath];
    cell.model = array[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"ToEditNoteSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    if ([sender isKindOfClass:[UIButton class]]) {
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"添加笔记";
        vc.delegate = self;
    }else {
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        NSArray *array = (NSArray *)self.totalArray[indexPath.section];
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"编辑笔记";
        vc.noteModel = array[indexPath.row];
        vc.delegate = self;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        if (self.dataArray.count == 1) {
            kTipAlert(@"删除笔记失败，不能删除唯一的笔记");
            return;
        }
        NSMutableArray *array = (NSMutableArray *)self.totalArray[indexPath.section];
        [SNRealmHelper deleteNote:array[indexPath.row]];
        [array removeObjectAtIndex:indexPath.row];
        
        [self.notesTableView reloadData];
        
    }];
    deleteAction.backgroundColor = SNColor(0, 180, 87);
    
    return @[deleteAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    
    label.text = [NSString stringWithFormat:@"  %@",self.headers[section]];
    label.backgroundColor = SNColor(246, 246, 246);
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor darkGrayColor];
    return label;
}


#pragma mark - getters and setters

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    if (dataArray) {
        NSMutableArray *temp = @[].mutableCopy;
        NSMutableArray *totalArray = @[].mutableCopy;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月"];
        for (NoteModel *model in dataArray) {
            NSString *sectionHeader = [formatter stringFromDate:model.noteCreateDate];
            [temp addObject:sectionHeader];
        }
        temp = [temp valueForKeyPath:@"@distinctUnionOfObjects.self"];
        temp = [[temp reverseObjectEnumerator] allObjects].mutableCopy;
        for (int i = 0 ; i < temp.count ; i ++) {
            NSMutableArray *tempArray = @[].mutableCopy;
            for (NoteModel *model in dataArray) {
                NSString *sectionHeader = [formatter stringFromDate:model.noteCreateDate];
                if ([sectionHeader isEqualToString:temp[i]]) {
                    [tempArray addObject:model];
                }
            }
            [totalArray addObject:tempArray];
        }
        self.headers = temp;
        self.totalArray = totalArray;
    }
    _dataArray = dataArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        self.dataArray = [SNRealmHelper readAllNotesFromNotebook] ;
    }
    return _dataArray;
}

- (NSMutableArray *)headers {
    if (!_headers) {
        _headers = @[@""].mutableCopy;
    }
    return _headers;
}

- (NSMutableArray *)totalArray {
    if (!_totalArray) {
        _totalArray = @[@""].mutableCopy;
    }
    return _totalArray;
}



@end
