//
//  NoteBookModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteBookModel.h"

@implementation NoteBookModel

- (NSMutableArray<NoteModel *> *)notesArray {
    if (!_notesArray) {
        
        NoteModel *model = [NoteModel new];
        model.notebookName = self.noteBookTitle;
        model.noteTitle = @"默认笔记";
        
        _notesArray = @[model].mutableCopy;
    }
    return _notesArray;
}

@end
