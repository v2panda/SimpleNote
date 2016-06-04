//
//  CreateNoteBookID.m
//  SimpleNote
//
//  Created by v2panda on 16/4/5.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "CreateNoteBookID.h"

#define UserDefaults [NSUserDefaults standardUserDefaults]
static NSString *const kNoteBookIDKey = @"kNoteBookID";

@implementation CreateNoteBookID
+ (void)initialize
{
    NSString *timeInterval = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    if (![UserDefaults objectForKey:kNoteBookIDKey]) {
        [UserDefaults setInteger:timeInterval.integerValue forKey:kNoteBookIDKey];
    }
}

+ (NSNumber *)getNoteBookID {
    
    NSString *idString = [UserDefaults objectForKey:kNoteBookIDKey];
    
    if (idString) {
        [UserDefaults setInteger:([idString integerValue] + 1) forKey:kNoteBookIDKey];
        return  @([idString integerValue] + 1);
    }else {
        return @((NSInteger)[UserDefaults objectForKey:kNoteBookIDKey]);
    }
    
}
@end
