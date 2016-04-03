//
//  NoteCoverCell.m
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteCoverCell.h"

@interface NoteCoverCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *coverCheckImageView;

@end

@implementation NoteCoverCell

- (void)setModel:(NoteCoverModel *)model {
    _model = model;
    
    self.coverImageView.image = [UIImage imageNamed:model.noteCoverString];
    self.coverCheckImageView.hidden = !model.isNoteCoverSeleted;
}

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"NoteBookCoverID";
    NoteCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.layer.borderColor=[SNColor(223,223,223) CGColor];
    cell.layer.borderWidth=0.3;

    return cell;
}
@end
