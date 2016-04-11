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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(NoteModel *)model {
    _model = model;
    self.titleLabel.text = model.noteTitle;
    self.timeLabel.text = model.noteCreateTime;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    SNNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNNoteCellID" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"SNNoteCell" owner:self options:nil] lastObject];
    }
    
//    if (indexPath.row == 2) {
//        cell.titleLabel.text = @"要长长长长长长长长长长长长长长长长长长长长长长长";
//        cell.rightImageView.hidden = YES;
//        cell.titleLabelConstraint.priority = 999;
//    }
    
    return cell;
}

@end
