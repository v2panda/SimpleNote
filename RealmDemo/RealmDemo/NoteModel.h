//
//  NoteModel.h
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import "NoteBookModel.h"

@interface NoteModel : RLMObject

@property (nonatomic, strong) NoteBookModel *owner;

@property (nonatomic, copy) NSString *notebookName;

@property (nonatomic, copy) NSString *noteTitle;

@property (nonatomic, copy) NSString *noteID;

@property (nonatomic, copy) NSString *noteCreateTime;

@property (nonatomic, strong) NSDate *noteCreateDate;

@property (nonatomic, strong) NSData *noteThumbnailData;

@property (nonatomic, strong) NSData *data;

@end

