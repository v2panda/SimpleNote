//
//  AppDelegate.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "AppDelegate.h"
#import "SNRealmHelper.h"
#import "NoteBookModel.h"
#import "SNVCHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self reLaunching];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[url absoluteString] rangeOfString:kWidgetPrefix].location != NSNotFound) {
        NSString* action = [[url absoluteString] substringFromIndex:kWidgetPrefix.length];
        if ([action isEqualToString:kWidgetAdd]) {
            [[UIApplication sharedApplication].keyWindow.rootViewController.childViewControllers.lastObject.childViewControllers.firstObject performSegueWithIdentifier:kSegueEditNote sender:[UIButton new]];
        }
    }
    return  YES;
}

- (void)reLaunching {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *currentRealm = (NSString *)USER_DEFAULT_VALUEFOR(kCurrentRealm);
    [SNRealmHelper setDefaultRealmForUser:currentRealm];
    [self InitFileIfNeeded];
    [AVOSCloud setApplicationId:kAVOSCloudApplicationId
                      clientKey:kAVOSCloudclientKey];
    if ([AVUser currentUser] != nil) {
        [SNUserTool getUserInfo];
        self.window.rootViewController = [SNVCHandler getRootViewController];
    } else {
        self.window.rootViewController = [SNVCHandler getLRViewController];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)InitFileIfNeeded {
    BOOL ifNeeded = (BOOL)USER_DEFAULT_VALUEFOR(kFileIfNeeded);
    if (!ifNeeded) {
        NoteBookModel *model = [NoteBookModel new];
        model.noteBookTitle = kDefaultTitle;
        model.customCoverImageData = kDefaultImageData;
        model.noteBookID = [CreateNoteBookID getNoteBookID];
        [SNRealmHelper addNewNoteBook:model];
        USER_DEFAULT_SET(model.noteBookID, kIsNoteBookSeleted);
        USER_DEFAULT_SET(@1, kFileIfNeeded);
        USER_DEFAULT_SYNCHRONIZE;
    }
}

@end
