//
//  VNNote.h
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#define VNNOTE_DEFAULT_TITLE @"无标题笔记"
@interface VNNote : NSObject<NSCoding>

@property (nonatomic, strong) NSString *noteID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *encryptStr;

- (id)initWithTitle:(NSString *)title
            content:(NSString *)content
        createdDate:(NSDate *)createdDate
         updateDate:(NSDate *)updatedDate encrypt:(NSString *)encryptStr;

- (BOOL)Persistence;

@end
