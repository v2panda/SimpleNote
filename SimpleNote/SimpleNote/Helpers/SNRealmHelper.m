//
//  SNRealmHelper.m
//  SimpleNote
//
//  Created by Panda on 16/4/18.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNRealmHelper.h"
#import "CreateNoteBookID.h"

@implementation SNRealmHelper

+ (void)setDefaultRealmForUser:(NSString *)username {
    
    if ([NSString isBlankString:username]) {
        username = @"default";
    }
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:username]
                      URLByAppendingPathExtension:@"realm"];
    
    // 将这个配置应用到默认的 Realm 数据库当中
    [RLMRealmConfiguration setDefaultConfiguration:config];
}


+ (NSString *)getLocalPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return documentsDirectory;
}

+ (void)initDefaultNotebook {
    NoteBookModel *notebook = [NoteBookModel new];
    notebook.noteBookID = [CreateNoteBookID getNoteBookID];
    notebook.noteBookTitle = kDefaultTitle;
    notebook.customCoverImageData = kDefaultImageData;
    
    NoteModel *note = [NoteModel new];
    note.noteTitle = @"默认笔记";
    note.noteID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].stringValue;
    note.owner = notebook;
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm addObject:notebook];
    [realm commitWriteTransaction];
    }
}

+ (void)addNewNoteBook:(NoteBookModel *)notebook {
    NoteModel *note = [NoteModel new];
    note.noteTitle = @"默认笔记";
    note.noteID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].stringValue;
    note.noteCreateDate = [NSDate date];
    note.owner = notebook;
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm addObject:notebook];
    [realm commitWriteTransaction];
    }
}

+ (void)addNewNote:(NoteModel *)note {
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm commitWriteTransaction];
    }
}

+ (void)updateNoteBook:(NoteBookModel *)notebook {
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [NoteBookModel createOrUpdateInRealm:realm withValue:notebook];
    [realm commitWriteTransaction];
    }
}

+ (void)updateNote:(NoteModel *)note {
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [NoteModel createOrUpdateInRealm:realm withValue:note];
    [realm commitWriteTransaction];
    }
}

+ (void)updateDataInRealm:(void(^)())block {
    @autoreleasepool {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (block) {
        block();
    }
    [realm commitWriteTransaction];
    }
}

+ (void)deleteNoteBook:(NoteBookModel *)notebook {
    @autoreleasepool {
    RLMResults *result = [NoteModel objectsWhere:@"owner = %@",notebook];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    for (NoteModel *model in result) {
        [realm deleteObject:model];
    }
    [realm deleteObject:notebook];
    [realm commitWriteTransaction];
    }
}

+ (void)deleteNote:(NoteModel *)note {
    @autoreleasepool {
        // 所有 Realm 的使用操作
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:note];
        [realm commitWriteTransaction];
    }
    
}

+ (void)deleteAllObjects {
    @autoreleasepool {
    // 从 Realm 中删除所有数据
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    }
}

+ (NSMutableArray *)readAllNoteBooks {
    RLMResults *result = [NoteBookModel allObjects];
    NSMutableArray *notes = [@[] mutableCopy];
    for (NoteBookModel *model in result) {
        [notes addObject:model];
    }
    return notes;
}

+ (NSMutableArray *)readAllNotes {
    RLMResults *result = [NoteModel allObjects];
    NSMutableArray *notes = [@[] mutableCopy];
    for (NoteModel *model in result) {
        [notes addObject:model];
    }
    return notes;
}

+ (NSMutableArray *)readAllNotesFromNotebook {
    RLMResults *result = [NoteModel objectsWhere:@"owner = %@",[self getNowNoteBook]];
    NSMutableArray *notes = [@[] mutableCopy];
    for (NoteModel *model in result) {
        [notes addObject:model];
    }
    NSArray* reversedArray = [[notes reverseObjectEnumerator] allObjects];
    return reversedArray.mutableCopy;
}

+ (NoteBookModel *)getNowNoteBook {
    NSNumber *nowNotebook =  (NSNumber *)[[NSUserDefaults standardUserDefaults]objectForKey:kIsNoteBookSeleted];
    RLMResults *notebookResult = [NoteBookModel objectsWhere:@"noteBookID = %d",nowNotebook.integerValue];
    if (!notebookResult.count) {
        notebookResult = [NoteBookModel allObjects];
    }
    NoteBookModel *notebook = (NoteBookModel *)notebookResult.firstObject;
    return notebook;
}


@end
