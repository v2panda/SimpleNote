//
//  EditNoteBookViewController.m
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "EditNoteBookViewController.h"
#import "NoteBookDefaultCell.h"
#import "NoteCoverCell.h"
#import "NoteCoverModel.h"
#import "NoteBookModel.h"
#import "TZImagePickerController.h"
#import "ChooseCoverReusableView.h"
#import "SNRealmHelper.h"


@interface EditNoteBookViewController () <
UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
ChooseCoverReusableViewDelegate,
TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *createTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *createCollectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (nonatomic, strong) NSMutableArray<NoteCoverModel *> *covers;
@property (nonatomic, strong) NoteBookModel *noteBookModel;
@property (nonatomic, strong) UIImage *pickerImage;
@end

@implementation EditNoteBookViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNoteBookModel:) name:kNoteEditBtnTouched object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - event response
- (void)getNoteBookModel:(NSNotification *)noteBookInfo {
    self.noteBookModel = (NoteBookModel *)noteBookInfo.object;
    if (self.noteBookModel.noteBookID) {
        self.navigationItem.rightBarButtonItem.title = @"保存";
        self.title = @"编辑笔记本";
    }
    [self.createTableView reloadData];
}

- (IBAction)saveBtnDidTouched:(UIBarButtonItem *)sender {
    NSLog(@"Save & Add");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNoteBookAddedSaved object:self.noteBookModel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backBtnDidTouched:(UIBarButtonItem *)sender {
    NSLog(@"Back");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NoteBookDefaultCell *cell = [NoteBookDefaultCell cellWithTableView:tableView];
        NoteBookModel *model = self.noteBookModel;
        cell.backNoteTitle = ^(NSString *title) {
            model.noteBookTitle = title;
        };
        cell.model = self.noteBookModel;
        return cell;
        
    }else if (indexPath.row == 1) {
        NoteBookCreateCoverCell *cell = [NoteBookCreateCoverCell cellWithTableView:tableView];
        if (self.pickerImage) {
            NoteBookModel *model = self.noteBookModel;
            [SNRealmHelper updateDataInRealm:^{
                model.customCoverImageData = UIImagePNGRepresentation(self.pickerImage);
            }];
        }
        cell.model = self.noteBookModel;
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.covers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NoteCoverCell *cell = [NoteCoverCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    
    cell.model = self.covers[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        ChooseCoverReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ChooseCoverReusableViewID" forIndexPath:indexPath];
        footerview.delegate = self;
        reusableview = footerview;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NoteCoverModel *model in self.covers) {
        model.isNoteCoverSeleted = NO;
    }
    
    NoteCoverModel *model = self.covers[indexPath.row];
    model.isNoteCoverSeleted = YES;
    self.pickerImage = model.noteCoverImage;
    
    [self.createCollectionView reloadData];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = self.view.width / 3.0;
    
    return CGSizeMake(width, width + 20);
}

#pragma mark - ChooseCoverReusableViewDelegate
- (void)ChooseCoverBtnDidTouched {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = SNColor(117, 106, 102);
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    self.pickerImage  = photos.firstObject;
}

#pragma mark - getters and setters
- (NoteBookModel *)noteBookModel {
    if (!_noteBookModel) {
        _noteBookModel = [NoteBookModel new];
        _noteBookModel.customCoverImageData = UIImagePNGRepresentation([UIImage imageNamed:@"AccountBookCover0"]);
        _noteBookModel.noteBookID = [CreateNoteBookID getNoteBookID];
    }
    return _noteBookModel;
}

- (NSMutableArray *)covers{
    if (!_covers) {
        _covers = [NSMutableArray array];
        for (int i = 0; i < 6; i ++) {
            NoteCoverModel *model = [NoteCoverModel new];
            model.noteCoverImage = [UIImage imageNamed:[NSString stringWithFormat:@"AccountBookCover%d",i]];
            [_covers addObject:model];
        }
    }
    return _covers;
}

- (void)setPickerImage:(UIImage *)pickerImage {
    if (pickerImage) {
        if (pickerImage.size.width > self.view.width && pickerImage.size.height > self.view.height) {
            pickerImage = [pickerImage imageByScalingAndCroppingForSize:CGSizeMake(self.view.width - 20, self.view.height - 100)];
        }else if (pickerImage.size.width > self.view.width || pickerImage.size.height > self.view.height) {
            pickerImage = [pickerImage imageByResizeToSize:CGSizeMake(200, 200)];
        }
        [self.createTableView reloadData];
    }
    _pickerImage = pickerImage;
}

@end
