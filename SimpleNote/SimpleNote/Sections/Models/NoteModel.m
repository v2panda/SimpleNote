//
//  NoteModel.m
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

+ (NSString *)primaryKey {
    return @"noteID";
}

- (NSString *)noteCreateTime {
    if (!_noteCreateTime) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _noteCreateTime = [formatter stringFromDate:self.noteCreateDate];
    }
    return _noteCreateTime;
}

- (NSString *)noteID {
    if (!_noteID) {
        _noteID = [NSNumber numberWithDouble:[self.noteCreateDate timeIntervalSince1970]].stringValue;
    }
    return _noteID;
}

@end
