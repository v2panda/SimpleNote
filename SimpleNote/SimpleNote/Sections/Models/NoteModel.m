//
//  NoteModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteModel.h"

#define kNoteIDKey      @"kNoteID"
#define kNoteTitleKey       @"kNoteTitle"
#define kNotebookNameKey     @"kNotebookName"
#define kDataKey    @"kData"


@implementation NoteModel
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
    [encoder encodeObject:self.data forKey:kDataKey];
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
        self.data = [decoder decodeObjectForKey:kDataKey];
        
    }
    return self;
}
@end
