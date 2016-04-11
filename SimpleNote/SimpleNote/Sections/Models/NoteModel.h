//
//  NoteModel.h
//  SimpleNote
//
//  Created by Panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, copy) NSString *noteTitle;

@property (nonatomic, copy) NSString *noteCreateTime;

@property (nonatomic, strong) NSDate *noteCreateDate;

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, strong) NSData *data;

@end
