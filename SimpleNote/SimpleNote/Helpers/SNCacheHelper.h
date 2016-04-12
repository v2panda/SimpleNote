//
//  SNCacheHelper.h
//  SimpleNote
//
//  Created by Panda on 16/4/12.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@interface SNCacheHelper : NSObject

+ (instancetype)sharedManager;

- (BOOL)storeNoteBook:(NoteModel *)note;

@end
