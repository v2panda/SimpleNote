//
//  SNRealmHelper.m
//  RealmDemo
//
//  Created by Panda on 16/4/18.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNRealmHelper.h"
#import "CreateNoteBookID.h"



@implementation SNRealmHelper

+ (NSString *)getLocalPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return documentsDirectory;
}

+ (void)initDefaultNotebook {
    NoteBookModel *notebook = [NoteBookModel new];
    notebook.noteBookID = [CreateNoteBookID getNoteBookID];
    notebook.noteBookTitle = @"Default NoteBook Title";
    notebook.customCoverImageData = [NSData data];
    
    NoteModel *note = [NoteModel new];
    note.noteTitle = @"Default Note Title";
    note.noteID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].stringValue;
    note.owner = notebook;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm addObject:notebook];
    [realm commitWriteTransaction];
}

+ (void)addNewNoteBook:(NoteBookModel *)notebook {
    NoteModel *note = [NoteModel new];
    note.noteTitle = @"Default Note Title";
    note.noteID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].stringValue;
    note.owner = notebook;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm addObject:notebook];
    [realm commitWriteTransaction];
}

+ (void)addNewNote:(NoteModel *)note {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:note];
    [realm commitWriteTransaction];
}

+ (void)deleteNoteBook:(NoteBookModel *)notebook {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:notebook];
    [realm commitWriteTransaction];
}

+ (void)deleteNote:(NoteModel *)note {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:note];
    [realm commitWriteTransaction];
}

+ (NSMutableArray *)readAllNoteBooks {
    RLMResults *result = [NoteBookModel allObjects];
    NSMutableArray *notes = [@[] mutableCopy];
    for (NoteBookModel *model in result) {
        [notes addObject:model];
    }
    return notes;
}

+ (NSMutableArray *)readAllNotesFromNotebook:(NoteBookModel *)notebook {
    RLMResults *result = [NoteModel objectsWhere:@"owner = %@",notebook];
    NSMutableArray *notes = [@[] mutableCopy];
    for (NoteModel *model in result) {
        [notes addObject:model];
    }
    return notes;
}



@end
