//
//  SNUserModel.h
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNUserModel : NSObject

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *describe;

@property (nonatomic, copy) NSString *userSite;

@property (nonatomic, copy) NSString *realmFileID;

@property (nonatomic, copy) NSString *avatarUrl;

@property (nonatomic, copy) NSString *avatarObjID;

@end
