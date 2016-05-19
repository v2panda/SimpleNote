//
//  CurrentUserCell.m
//  SimpleNote
//
//  Created by Panda on 16/5/19.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "CurrentUserCell.h"

@interface CurrentUserCell ()


@end

@implementation CurrentUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImageView.layer.cornerRadius = self.userImageView.width / 2;
    self.userImageView.layer.masksToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    CurrentUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrentUserCellID"];
    
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"CurrentUserCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
