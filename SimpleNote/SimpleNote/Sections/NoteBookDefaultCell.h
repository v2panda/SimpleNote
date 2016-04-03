//
//  NoteBookDefaultCell.h
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBookModel.h"

@interface NoteBookDefaultCell : UITableViewCell
@property (nonatomic, strong) NoteBookModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end


@interface NoteBookCreateCoverCell : UITableViewCell
@property (nonatomic, strong) NoteBookModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end