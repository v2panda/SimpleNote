//
//  NoteBookModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteBookModel.h"
#define kNoteTitleKey       @"kNoteTitle"
#define kNotebookNameKey     @"kNotebookName"
#define kNoteCreateTimeKey     @"kNoteCreateTime"
#define kNoteCreateDateKey     @"kNoteCreateDate"
#define kNoteIDKey     @"kNoteID"
#define kDataKey    @"kData"
@implementation NoteBookModel

- (NSMutableArray<NoteModel *> *)notesArray {
    if (!_notesArray) {
        NoteModel *model = [NoteModel new];
        model.notebookName = self.noteBookTitle;
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
    [encoder encodeObject:self.noteBookID forKey:kNotebookNameKey];
    [encoder encodeObject:self.noteBookTitle forKey:kNoteTitleKey];
    [encoder encodeObject:self.notesArray forKey:kNoteIDKey];
    [encoder encodeObject:self.customCoverImage forKey:kNoteCreateTimeKey];
//    [encoder encodeObject:self.isNoteBookSeleted  forKey:kNoteCreateDateKey];
}
/**
 *  解归档一个数据的时候会调用
 *
 *  告诉系统如何解档数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.noteBookID = [decoder decodeObjectForKey:kNotebookNameKey];
        self.noteBookTitle = [decoder decodeObjectForKey:kNoteTitleKey];
        self.notesArray = [decoder decodeObjectForKey:kNoteIDKey];
        self.customCoverImage = [decoder decodeObjectForKey:kNoteCreateTimeKey];
    }
    return self;
}


@end
