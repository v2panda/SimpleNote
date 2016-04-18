//
//  NoteBookModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteBookModel.h"
#define kNoteBookTitleKey       @"kNoteBookTitle"
#define kCustomCoverImageKey     @"kCustomCoverImage"
#define kNotesArrayKey     @"kNotesArray"
#define kNoteBookIDKey     @"kNoteBookID"

@implementation NoteBookModel

- (NSMutableArray<NoteModel *> *)notesArray {
    if (!_notesArray) {
        NoteModel *model = [NoteModel new];
        model.notebookName = self.noteBookID.stringValue;
        model.noteTitle = @"默认笔记";
        model.noteCreateDate = [NSDate date];
        _notesArray = @[model].mutableCopy;
    }
    return _notesArray;
}

/**
 *   归档一个对象到文件中的时候会调用
 *
 *   在此方法中告诉系统如何保存输入
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.noteBookID forKey:kNoteBookIDKey];
    [encoder encodeObject:self.noteBookTitle forKey:kNoteBookTitleKey];
    [encoder encodeObject:self.notesArray forKey:kNotesArrayKey];
    [encoder encodeObject:self.customCoverImageData forKey:kCustomCoverImageKey];
}
/**
 *  解归档一个数据的时候会调用
 *
 *  告诉系统如何解档数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.noteBookID = [decoder decodeObjectForKey:kNoteBookIDKey];
        self.noteBookTitle = [decoder decodeObjectForKey:kNoteBookTitleKey];
        self.notesArray = [decoder decodeObjectForKey:kNotesArrayKey];
        self.customCoverImageData = [decoder decodeObjectForKey:kCustomCoverImageKey];
    }
    return self;
}


@end
