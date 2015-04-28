//
//  VNNoteManager.h
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

@import Foundation;

@class VNNote;
@interface NoteManager : NSObject

@property (nonatomic, strong) NSString *docPath;

- (NSMutableArray *)readAllNotes;

- (VNNote *)readNoteWithID:(NSString *)noteID;
- (BOOL)storeNote:(VNNote *)note;
- (void)deleteNote:(VNNote *)note;

- (VNNote *)todayNote;

+ (instancetype)sharedManager;

@end
