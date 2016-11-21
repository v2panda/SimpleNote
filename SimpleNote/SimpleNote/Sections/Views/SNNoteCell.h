//
//  SNNoteCell.h
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface SNNoteCell : UITableViewCell

@property (nonatomic, strong) NoteModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
