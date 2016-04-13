//
//  NSString+PDAdd.m
//  SimpleNote
//
//  Created by v2panda on 16/4/13.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NSString+PDAdd.h"

@implementation NSString (PDAdd)
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
