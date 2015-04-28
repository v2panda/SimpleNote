//
//  VNNote.m
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "VNNote.h"
#import "NoteManager.h"

#define kNoteIDKey      @"NoteID"
#define kTitleKey       @"Title"
#define kContentKey     @"Content"
#define kCreatedDate    @"CreatedDate"
#define kUpdatedDate    @"UpdatedDate"
#define kEncryptStr    @"encryptStr"
@implementation VNNote

@synthesize noteID = _noteID;
@synthesize title = _title;
@synthesize content = _content;
@synthesize createdDate = _createdDate;
@synthesize encryptStr = _encryptStr;


- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate encrypt:(NSString *)encryptStr
{
    self = [super init];
    if (self) {
        _noteID = [NSNumber numberWithDouble:[createdDate timeIntervalSince1970]].stringValue;
        _title = title;
        _content = content;
        _createdDate = createdDate;
        _updatedDate = updatedDate;
        _encryptStr = encryptStr;
        if (_title == nil || _title.length == 0) {
            _title = VNNOTE_DEFAULT_TITLE;
        }
        if (_content == nil || _content.length == 0) {
            _content = @"";
        }
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_noteID forKey:kNoteIDKey];
    [encoder encodeObject:_title forKey:kTitleKey];
    [encoder encodeObject:_content forKey:kContentKey];
    [encoder encodeObject:_createdDate forKey:kCreatedDate];
    [encoder encodeObject:_encryptStr forKey:kEncryptStr];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSString *title = [decoder decodeObjectForKey:kTitleKey];
    NSString *content = [decoder decodeObjectForKey:kContentKey];
    NSDate *createDate = [decoder decodeObjectForKey:kCreatedDate];
    NSDate *updateDate = [decoder decodeObjectForKey:kUpdatedDate];
    NSString *encryptStr = [decoder decodeObjectForKey:kEncryptStr];
    return [self initWithTitle:title
                       content:content
                   createdDate:createDate
                    updateDate:updateDate encrypt:encryptStr];
}

- (BOOL)Persistence
{
    return [[NoteManager sharedManager] storeNote:self];
}

- (NSInteger)index
{
    if (!_index) {
        _index = (int)[self.createdDate timeIntervalSince1970];
    }
    return _index;
}
@end
