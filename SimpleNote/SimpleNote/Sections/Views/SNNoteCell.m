//
//  SNNoteCell.m
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNNoteCell.h"

@interface SNNoteCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelConstraint;

@end

@implementation SNNoteCell

- (void)setModel:(NoteModel *)model {
    _model = model;
    self.titleLabel.text = model.noteTitle;
    self.timeLabel.text = model.noteCreateTime;
    if (model.noteThumbnailData) {
        self.rightImageView.image = [UIImage imageWithData:model.noteThumbnailData];
    }else {
        self.rightImageView.image = nil;
        self.titleLabelConstraint.priority = 999;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    SNNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNNoteCellID" forIndexPath:indexPath];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"SNNoteCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
