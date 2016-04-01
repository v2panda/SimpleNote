//
//  NoteBookViewCell.h
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBookModel.h"

@protocol NoteBookViewCellBtnDelegate <NSObject>

@optional
- (void)noteDeleteBtnTouched:(NSInteger)noteBookID;
- (void)noteEditBtnTouched;

@end


@interface NoteBookViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteCheckImageView;
@property (weak, nonatomic) IBOutlet UIImageView *editBGView;
@property (weak, nonatomic) IBOutlet UIButton *noteDeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *noteEditBtn;
@property (nonatomic, weak) id <NoteBookViewCellBtnDelegate>  delegate;
@property (nonatomic, strong) NoteBookModel *model;
@property (nonatomic, assign) BOOL isNoteBookEditing;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
