//
//  SNRealmHelper.h
//  RealmDemo
//
//  Created by Panda on 16/4/18.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "NoteModel.h"
#import "NoteBookModel.h"

@interface SNRealmHelper : NSObject

+ (NSString *)getLocalPath;

+ (void)initDefaultNotebook;

+ (void)addNewNoteBook:(NoteBookModel *)notebook;

+ (void)addNewNote:(NoteModel *)note;

+ (void)deleteNoteBook:(NoteBookModel *)notebook;

+ (void)deleteNote:(NoteModel *)note;

+ (NSMutableArray *)readAllNoteBooks;

+ (NSMutableArray *)readAllNotesFromNotebook:(NoteBookModel *)notebook;
@end
