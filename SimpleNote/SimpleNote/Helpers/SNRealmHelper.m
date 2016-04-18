//
//  SNRealmHelper.m
//  SimpleNote
//
//  Created by Panda on 16/4/18.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNRealmHelper.h"

@implementation SNRealmHelper

+ (NSString *)getLocalPath {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return documentsDirectory;
}


@end
