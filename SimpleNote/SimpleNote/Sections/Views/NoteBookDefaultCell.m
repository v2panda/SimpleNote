//
//  NoteBookDefaultCell.m
//  SimpleNote
//
//  Created by Panda on 16/4/3.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteBookDefaultCell.h"

@interface NoteBookDefaultCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation NoteBookDefaultCell

- (void)setModel:(NoteBookModel *)model {
    _model = model;
    self.titleTextField.text = model.noteBookTitle;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"NoteBookNameID";
    NoteBookDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"NoteBookDefaultCell" owner:self options:nil] firstObject];
    }
    return cell;
}

#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 20) {
        return NO;
    }else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.backNoteTitle) {
        self.backNoteTitle(textField.text);
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context,[SNColor(223,223,223) CGColor]);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}
@end

@interface NoteBookCreateCoverCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailCover;

@end

@implementation NoteBookCreateCoverCell

-  (void)setModel:(NoteBookModel *)model {
    _model = model;
    if (model.customCoverImageData) {
        self.thumbnailCover.image = [UIImage imageWithData:model.customCoverImageData];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"NoteBookCoverID";
    NoteBookCreateCoverCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"NoteBookDefaultCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5f);
    CGContextSetStrokeColorWithColor(context,[SNColor(223,223,223) CGColor]);
    CGContextAddRect(context, rect);
    CGContextStrokePath(context);
}
@end