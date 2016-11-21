//
//  NSData+PDAdd.m
//  SimpleNote
//
//  Created by Panda on 16/4/11.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "NSData+PDAdd.h"

@implementation NSData (PDAdd)

+ (NSData *)dataNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

@end
