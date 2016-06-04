//
//  SNRealmHelper.h
//  SimpleNote
//
//  Created by Panda on 16/4/18.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "NoteModel.h"
#import "NoteBookModel.h"

@interface SNRealmHelper : NSObject

+ (void)setDefaultRealmForUser:(NSString *)username;

+ (NSString *)getLocalPath;

+ (void)initDefaultNotebook;

+ (void)addNewNoteBook:(NoteBookModel *)notebook;

+ (void)addNewNote:(NoteModel *)note;

+ (void)updateNoteBook:(NoteBookModel *)notebook;

+ (void)updateNote:(NoteModel *)note;

+ (void)updateDataInRealm:(void(^)())block;

+ (void)deleteNoteBook:(NoteBookModel *)notebook;

+ (void)deleteNote:(NoteModel *)note;

+ (void)deleteAllObjects;

+ (NSMutableArray *)readAllNoteBooks;

+ (NSMutableArray *)readAllNotes;

+ (NSMutableArray *)readAllNotesFromNotebook;

+ (NoteBookModel *)getNowNoteBook;

@end
