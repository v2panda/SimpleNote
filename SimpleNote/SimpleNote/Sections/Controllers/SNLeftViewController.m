//
//  SNLeftViewController.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNLeftViewController.h"
#import "NoteBookViewCell.h"
#import "NoteBookModel.h"
#import "EditNoteBookViewController.h"
#import "TZImagePickerController.h"
#import "RESideMenu.h"
#import "SNRealmHelper.h"

@interface SNLeftViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
NoteBookViewCellBtnDelegate,
TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avataImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *noteCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *noteEditButton;
@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, copy) NSMutableArray<NoteBookModel *> *notebooksArray;
@end

@implementation SNLeftViewController

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noteCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    self.noteCollectionView.dataSource = self;
    self.noteCollectionView.delegate = self;
    self.isEditing = YES;
    self.avataImageView.layer.cornerRadius = self.avataImageView.width / 2;
    self.avataImageView.layer.masksToBounds = YES;
    
    if ([AVUser currentUser]) {
        self.topLabel.text = [AVUser currentUser].username;
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveNoteBookModel:) name:kNoteBookAddedSaved object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - event response

- (void)saveNoteBookModel:(NSNotification *)noteBookInfo {
    NoteBookModel *model = (NoteBookModel *)noteBookInfo.object;
    
    BOOL isAdd = NO;
    for (__strong NoteBookModel *tempModel in self.notebooksArray) {
        if ( [model.noteBookID isEqualToNumber:tempModel.noteBookID]) {
            tempModel = model;
            isAdd = NO;
             [SNRealmHelper updateNoteBook:model];
            [self.noteCollectionView reloadData];
            return;
        }else {
            isAdd = YES;
        }
    }
    if (isAdd) {
        [SNRealmHelper addNewNoteBook:model];
        [self.notebooksArray addObject:model];
        [self.noteCollectionView reloadData];
    }
    
}
- (IBAction)settingButtonDidTouched:(UIButton *)sender {
    NSLog(@"settingButtonDidTouched");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingNAID"];
    [self presentViewController:vc animated:YES completion:nil];
}

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

- (IBAction)avataImageTapped:(UITapGestureRecognizer *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = SNColor(117, 106, 102);
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    self.avataImageView.image  = photos.firstObject;
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
    
    NoteBookModel *model = self.notebooksArray[indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:model.noteBookID forKey:@"isNoteBookSeleted"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.noteCollectionView reloadData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kOpenNoteBook object:nil];
    
    [self.sideMenuViewController hideMenuViewController];
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
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoteEditBtnTouched object:model];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)noteDeleteBtnTouched:(NSInteger)noteBookID {
    NSLog(@"Delete");
    
    if (self.notebooksArray.count == 1) {
        kTipAlert(@"删除笔记本失败，不能删除正在使用的笔记本");
        return;
    }
    
    NoteBookModel *model = self.notebooksArray[noteBookID];
    NSNumber *isShow = (NSNumber *)[[NSUserDefaults standardUserDefaults]objectForKey:@"isNoteBookSeleted"];
    if (isShow && [model.noteBookID isEqualToNumber:isShow]) {
        [SNRealmHelper deleteNoteBook:model];
        [self.notebooksArray removeObjectAtIndex:noteBookID];
        NoteBookModel *firstModel = [self.notebooksArray firstObject];
        [[NSUserDefaults standardUserDefaults]setObject:firstModel.noteBookID forKey:@"isNoteBookSeleted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter]postNotificationName:kOpenNoteBook object:nil];
    }else {
        [SNRealmHelper deleteNoteBook:model];
        [self.notebooksArray removeObjectAtIndex:noteBookID];
    }

    [self.noteCollectionView reloadData];
}

#pragma mark - getters and setters

- (NSMutableArray<NoteBookModel *> *)notebooksArray
{
    if (!_notebooksArray) {
        _notebooksArray = @[].mutableCopy;
        _notebooksArray = [SNRealmHelper readAllNoteBooks];
    }
    return _notebooksArray;
}


@end
