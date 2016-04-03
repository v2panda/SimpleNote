//
//  SNLeftViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNLeftViewController.h"
#import "SNLeftFlowlayout.h"
#import "NoteBookViewCell.h"
#import "NoteBookModel.h"

@interface SNLeftViewController () <UICollectionViewDelegate,UICollectionViewDataSource,NoteBookViewCellBtnDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avataImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *noteCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *noteEditButton;
@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) NSMutableArray<NoteBookModel *> *notebooksArray;
@end

@implementation SNLeftViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.noteCollectionView.dataSource = self;
    self.noteCollectionView.delegate = self;
    self.isEditing = YES;
    self.avataImageView.layer.cornerRadius = self.avataImageView.width / 2;
    self.avataImageView.layer.masksToBounds = YES;
    
    
    [self simulateData];
}

- (void)simulateData {
    
    for (int i = 0; i < 10; i ++) {
        NoteBookModel *model = [NoteBookModel new];
        model.noteBookTitle = [NSString stringWithFormat:@"标题%@",@(i)];
        model.noteBookCoverString = [NSString stringWithFormat:@"AccountBookCover%@",@(i%6)];
        if (i == 0) {
            model.isNoteBookSeleted = YES;
        }else {
            model.isNoteBookSeleted = NO;
        }
        
        [self.notebooksArray addObject:model];
    }
}

#pragma mark - event response

- (IBAction)noteEditButtonDidTouched:(UIButton *)sender {
    self.isEditing = !self.isEditing;
    if (self.isEditing) {
        [self.noteEditButton setImage:[UIImage imageNamed:@"finish_edit_account_book_btn_normal"] forState:UIControlStateNormal];
        [self.noteEditButton setImage:[UIImage imageNamed:@"finish_edit_account_book_btn_highlighted"] forState:UIControlStateHighlighted];
    }else {
        [self.noteEditButton setImage:[UIImage imageNamed:@"edit_account_book_btn_normal"] forState:UIControlStateNormal];
        [self.noteEditButton setImage:[UIImage imageNamed:@"edit_account_book_btn_highlighted"] forState:UIControlStateHighlighted];
    }
    
    [self.noteCollectionView reloadData];
    
}
- (IBAction)addNoteButtonDidTouched:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NAID"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.notebooksArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NoteBookViewCell *cell = [NoteBookViewCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    
    cell.model = self.notebooksArray[indexPath.row];
    cell.isNoteBookEditing = self.isEditing;
    
    cell.delegate = self;
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath - %@",@(indexPath.row));
    
    for (NoteBookModel *model in self.notebooksArray) {
        model.isNoteBookSeleted = NO;
    }
    NoteBookModel *model = self.notebooksArray[indexPath.row];
    model.isNoteBookSeleted = YES;
    
    [self.noteCollectionView reloadData];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (is6_Inch){
        return CGSizeMake(100, 120);
    }else {
        return CGSizeMake(120, 140);
    }
}

#pragma mark - NoteBookViewCellBtnDelegate

- (void)noteEditBtnTouched:(NSInteger)noteBookID {
    NSLog(@"Edit");

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"NAID"];
    
    NoteBookModel *model = self.notebooksArray[noteBookID];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"noteEditBtnTouched" object:model];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)noteDeleteBtnTouched:(NSInteger)noteBookID {
    NSLog(@"Delete");
    
    if (self.notebooksArray.count == 1) {
        // 不让删
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除笔记本失败，不能删除正在使用的笔记本" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    NoteBookModel *model = self.notebooksArray[noteBookID];
    if (model.isNoteBookSeleted) {
        [self.notebooksArray removeObjectAtIndex:noteBookID];
        NoteBookModel *firstModel = [self.notebooksArray firstObject];
        firstModel.isNoteBookSeleted = YES;
    }else {
        [self.notebooksArray removeObjectAtIndex:noteBookID];
    }

    [self.noteCollectionView reloadData];
    
    
}

#pragma mark - getters and setters
- (NSMutableArray<NoteBookModel *> *)notebooksArray
{
    if (!_notebooksArray) {
        _notebooksArray = [NSMutableArray array];
    }
    return _notebooksArray;
}


@end
