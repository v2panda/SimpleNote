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
- (void)noteEditBtnTouched:(NSInteger)noteBookID;

@end


@interface NoteBookViewCell : UICollectionViewCell

@property (nonatomic, weak) id <NoteBookViewCellBtnDelegate>  delegate;
@property (nonatomic, strong) NoteBookModel *model;
@property (nonatomic, assign) BOOL isNoteBookEditing;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;

@end
