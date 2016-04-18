//
//  NoteModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteModel.h"

#define kNoteTitleKey       @"kNoteTitle"
#define kNotebookNameKey     @"kNotebookName"
#define kNoteCreateTimeKey     @"kNoteCreateTime"
#define kNoteCreateDateKey     @"kNoteCreateDate"
#define kNoteIDKey     @"kNoteID"
#define kDataKey    @"kData"
#define kNoteThumbnailKey    @"kNoteThumbnail"

@implementation NoteModel

- (NSString *)noteCreateTime {
    if (!_noteCreateTime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _noteCreateTime = [formatter stringFromDate:self.noteCreateDate];
    }
    return _noteCreateTime;
}

- (NSString *)noteID {
    if (!_noteID) {
        _noteID = [NSNumber numberWithDouble:[self.noteCreateDate timeIntervalSince1970]].stringValue;
    }
    return _noteID;
}

/**
 *   归档一个对象到文件中的时候会调用
 *
 *   在此方法中告诉系统如何保存输入
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.notebookName forKey:kNotebookNameKey];
    [encoder encodeObject:self.noteTitle forKey:kNoteTitleKey];
    [encoder encodeObject:self.noteID forKey:kNoteIDKey];
    [encoder encodeObject:self.noteCreateTime forKey:kNoteCreateTimeKey];
    [encoder encodeObject:self.noteCreateDate forKey:kNoteCreateDateKey];
    [encoder encodeObject:self.data forKey:kDataKey];
    [encoder encodeObject:self.noteThumbnailData forKey:kNoteThumbnailKey];
}
/**
 *  解归档一个数据的时候会调用
 *
 *  告诉系统如何解档数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.notebookName = [decoder decodeObjectForKey:kNotebookNameKey];
        self.noteTitle = [decoder decodeObjectForKey:kNoteTitleKey];
        self.noteID = [decoder decodeObjectForKey:kNoteIDKey];
        self.noteCreateDate = [decoder decodeObjectForKey:kNoteCreateDateKey];
        self.noteCreateTime = [decoder decodeObjectForKey:kNoteCreateTimeKey];
        self.data = [decoder decodeObjectForKey:kDataKey];
        self.noteThumbnailData = [decoder decodeObjectForKey:kNoteThumbnailKey];
    }
    return self;
}
@end
