//
//  NoteBookModel.h
//  SimpleNote
//
//  Created by Panda on 16/4/1.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@interface NoteBookModel : NSObject<NSCoding>

@property (nonatomic, strong) NSNumber *noteBookID;
@property (nonatomic, strong) NSString *noteBookTitle;
@property (nonatomic, assign) NSNumber *isNoteBookSeleted;
@property (nonatomic, strong) UIImage *customCoverImage;

@property (nonatomic, strong) NSMutableArray<NoteModel *> *notesArray;

@end
