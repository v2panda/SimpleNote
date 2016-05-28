//
//  SNUserTool.m
//  SimpleNote
//
//  Created by Panda on 16/5/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNUserTool.h"

@implementation SNUserTool

+ (void)getUserInfo {
    
    SNUserModel *model = [SNUserModel new];
    
    AVUser * currentUser = [AVUser currentUser];
    model.userName = currentUser.username;
    model.email = [currentUser objectForKey:@"email"];
    model.nickName = [currentUser objectForKey:@"nickName"];
    model.describe = [currentUser objectForKey:@"describe"];
    model.userSite = [currentUser objectForKey:@"userSite"];
    model.realmFileID = [currentUser objectForKey:@"realmFileID"];
    model.avatarUrl = [currentUser objectForKey:@"avatar"];
    [SNUserTool saveUserInfo:model];
    
}

+ (BOOL)saveUserInfo:(SNUserModel *)userInfo
{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *filePath = [docPath stringByAppendingPathComponent:@"OAuth.data"];
    
    return  [NSKeyedArchiver archiveRootObject:userInfo toFile:filePath];
}

+ (SNUserModel *)userInfo
{
    // 获取doc的目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接保存的路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"OAuth.data"];
    // 获取用户存储的授权信息
    SNUserModel *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!userInfo) {
        userInfo = [[SNUserModel alloc]init];
    }
    
    return userInfo;
}

+ (void)logOut
{
    // 获取doc的目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接保存的路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"OAuth.data"];
    
    //删除路径。data文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePath error:nil];
}

@end
