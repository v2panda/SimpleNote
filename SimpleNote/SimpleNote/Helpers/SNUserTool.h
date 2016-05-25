//
//  SNUserTool.h
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNUserModel.h"

@interface SNUserTool : NSObject

+ (void)getUserInfo;

+ (BOOL)saveUserInfo:(SNUserModel *)userInfo;

+ (SNUserModel *)userInfo;

+ (void)logOut;
@end
