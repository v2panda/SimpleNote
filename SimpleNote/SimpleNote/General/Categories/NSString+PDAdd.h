//
//  NSString+PDAdd.h
//  SimpleNote
//
//  Created by v2panda on 16/4/13.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PDAdd)
+ (BOOL) isBlankString:(NSString *)string;

- (BOOL)isValidEmail;

- (BOOL)isPwd;
@end
