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

@end


@implementation SNMainViewController
@synthesize dataArray = _dataArray;

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openNoteBook:) name:kOpenNoteBook object:nil];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[SNRealmHelper getLocalPath]);
    self.notesTableView.tableFooterView = [UIView new];
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
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNNoteCell *cell = [SNNoteCell cellWithTableView:tableView atIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ToEditNoteSegue" sender:@(indexPath.row)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  {
    if ([sender isKindOfClass:[UIButton class]]) {
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"添加笔记";
        vc.delegate = self;
    }else {
        NSNumber *index = sender;
        EditNoteViewController *vc = [segue destinationViewController];
        vc.title = @"编辑笔记";
        vc.noteModel = self.dataArray[index.integerValue];
        vc.delegate = self;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSLog(@"Delete");
        
        if (self.dataArray.count == 1) {
            kTipAlert(@"删除笔记失败，不能删除唯一的笔记");
            return;
        }
        
        [SNRealmHelper deleteNote:self.dataArray[indexPath.row]];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
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
        for (NoteModel *model in dataArray) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月"];
            NSString *sectionHeader = [formatter stringFromDate:model.noteCreateDate];
            [temp addObject:sectionHeader];
        }
        self.headers = [temp valueForKeyPath:@"@distinctUnionOfObjects.self"];
    }
    _dataArray = dataArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        self.dataArray = [SNRealmHelper readAllNotesFromNotebook];
    }
    return _dataArray;
}

- (NSMutableArray *)headers {
    if (!_headers) {
        _headers = @[@""].mutableCopy;
    }
    return _headers;
}

@end
