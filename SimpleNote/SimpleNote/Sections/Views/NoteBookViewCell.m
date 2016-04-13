//
//  NoteBookViewCell.m
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteBookViewCell.h"

#define kTitleFont

@interface NoteBookViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *noteBookCover;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *editBGView;
@property (weak, nonatomic) IBOutlet UIButton *noteDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteEditBtn;

@property (nonatomic, assign) NSInteger notebookID;

@end


@implementation NoteBookViewCell

- (void)setModel:(NoteBookModel *)model
{
    _model = model;
    NSNumber *isShow = (NSNumber *)[[NSUserDefaults standardUserDefaults]objectForKey:@"isNoteBookSeleted"];
    if (isShow) {
        if ([model.noteBookID isEqualToNumber:isShow]) {
            self.noteCheckImageView.hidden = NO;
        }else {
            self.noteCheckImageView.hidden = YES;
        }
    }
    
    self.noteTitleLabel.text = model.noteBookTitle;
    self.noteBookCover.image = model.customCoverImage;
}

- (void)setIsNoteBookEditing:(BOOL)isNoteBookEditing {
    _isNoteBookEditing = isNoteBookEditing;
    self.editBGView.hidden = self.isNoteBookEditing;
    self.noteEditBtn.hidden = self.isNoteBookEditing;
    self.noteDeleteBtn.hidden = self.isNoteBookEditing;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoteCellID";
    NoteBookViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.notebookID = indexPath.row;
    return cell;
}

- (IBAction)noteDeleteBtnDidTouched:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(noteDeleteBtnTouched:)]) {
            [self.delegate noteDeleteBtnTouched:self.notebookID];
        }
    });
}

- (IBAction)noteEditBtnDidTouched:(UIButton *)sender {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(noteEditBtnTouched:)]) {
            [self.delegate noteEditBtnTouched:self.notebookID];
        }
    });
}

@end
