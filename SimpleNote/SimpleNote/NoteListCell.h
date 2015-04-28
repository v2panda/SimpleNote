//
//  NoteListCell.h
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VNNote.h"

@interface NoteListCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

+ (CGFloat)heightWithNote:(VNNote *)note;
- (void)updateWithNote:(VNNote *)note;

@end
