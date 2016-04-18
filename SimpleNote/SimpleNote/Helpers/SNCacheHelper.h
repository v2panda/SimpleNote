//
//  SNCacheHelper.h
//  SimpleNote
//
//  Created by Panda on 16/4/12.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
#import "NoteBookModel.h"

@interface SNCacheHelper : NSObject

+ (instancetype)sharedManager;

- (BOOL)storeNoteBook:(NoteBookModel *)notebook;

- (NSMutableArray<NoteBookModel *> *)readAllNoteBooks;

- (NoteBookModel *)readNoteBook:(NSString *)notebookID;

@end
