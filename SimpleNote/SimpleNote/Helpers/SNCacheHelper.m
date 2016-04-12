//
//  SNCacheHelper.m
//  SimpleNote
//
//  Created by Panda on 16/4/12.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNCacheHelper.h"
#import <YYCache.h>

@implementation SNCacheHelper

+ (instancetype)sharedManager {
    static SNCacheHelper *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedManager) {
            sharedManager = [[SNCacheHelper alloc]init];
        }
    });
    return sharedManager;
}

- (BOOL)storeNoteBook:(NoteModel *)note {
    
    NSString *basePath = [self basePath];
    YYDiskCache *yy = [[YYDiskCache alloc] initWithPath:[basePath stringByAppendingPathComponent:note.notebookName]];
    
    [yy setObject:note forKey:note.noteID];
    
    return YES;
}


- (NSString *)basePath {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) firstObject];
    basePath = [basePath stringByAppendingPathComponent:@"SimpleNotes"];
    return basePath;
}


@end
