//
//  CurrentUserCell.h
//  SimpleNote
//
//  Created by Panda on 16/5/19.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
