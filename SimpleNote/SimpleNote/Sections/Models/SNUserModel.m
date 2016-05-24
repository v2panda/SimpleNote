//
//  SNUserModel.m
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNUserModel.h"
#import <objc/runtime.h>

@interface SNUserModel () <NSCoding>

@end
@implementation SNUserModel
//归档与解归档的方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        //获取所有属性
        NSArray * porpertyArray = [self getAllPropertys];
        for (NSString * name in porpertyArray) {
            //去掉属性名前面的_
            NSString * key = [name substringFromIndex:1];
            //约定好的键值对 c+key
            [self setValue:[coder decodeObjectForKey:[NSString stringWithFormat:@"c%@",key]] forKey:key];
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder
{
    
    //获取所有属性
    NSArray * porpertyArray = [self getAllPropertys];
    for (NSString * name in porpertyArray) {
        //去掉属性名前面的_
        NSString * key = [name substringFromIndex:1];
        //约定好的键值对 c+key
        [coder encodeObject:[self valueForKey:key] forKey:[NSString stringWithFormat:@"c%@",key]];
    }
}
//获取model所有属性
- (NSArray *)getAllPropertys{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    unsigned int * count = malloc(sizeof(unsigned int));
    //调用runtime的方法
    //Ivar：方法返回的对象内容对象，这里将返回一个Ivar类型的指针
    //class_copyIvarList方法可以捕获到类的所有变量，将变量的数量存在一个unsigned int的指针中
    Ivar * mem = class_copyIvarList([self class], count);
    //进行遍历
    for (int i=0; i< *count ; i++) {
        //通过移动指针进行遍历
        Ivar var = * (mem+i);
        //获取变量的名称
        const char * name = ivar_getName(var);
        NSString * str = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        [array addObject:str];
    }
    //释放内存
    free(count);
    //注意处理野指针
    count=nil;
    return array;
}
@end
