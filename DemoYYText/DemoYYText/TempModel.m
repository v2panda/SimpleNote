//
//  TempModel.m
//  DemoYYText
//
//  Created by Panda on 16/4/10.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "TempModel.h"

@implementation TempModel
/**
 *   归档一个对象到文件中的时候会调用
 *
 *   在此方法中告诉系统如何保存输入
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.tempStr forKey:@"tempStr"];
}
/**
 *  解归档一个数据的时候会调用
 *
 *  告诉系统如何解档数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.tempStr = [decoder decodeObjectForKey:@"tempStr"];
    }
    return self;
}

@end
