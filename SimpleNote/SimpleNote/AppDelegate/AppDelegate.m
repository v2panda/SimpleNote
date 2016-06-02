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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self reLaunching];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString* prefix = @"SimpleNoteWidget://action=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
        NSString* action = [[url absoluteString] substringFromIndex:prefix.length];
        if ([action isEqualToString:@"GotoAddNote"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;

            [window.rootViewController.childViewControllers.lastObject.childViewControllers.firstObject performSegueWithIdentifier:@"ToEditNoteSegue" sender:[UIButton new]];
        }
    }
    
    return  YES;
}


- (void)reLaunching {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NSString *currentRealm = (NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:kCurrentRealm];
    [SNRealmHelper setDefaultRealmForUser:currentRealm];
    
    [self InitFileIfNeeded];
    
    [AVOSCloud setApplicationId:@"bKlBx1uLlzqzmozQmyLVPYeo-gzGzoHsz"
                      clientKey:@"eXMjUwHcsnw8t1G96XHpvQHI"];
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        // 跳转到首页
        NSLog(@"已登录");
        [SNUserTool getUserInfo];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SNRootVCSBID"];
        self.window.rootViewController = vc;
        
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
        NSLog(@"未登录");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&Register" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login&RegisterID"];
        self.window.rootViewController = vc;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

- (void)InitFileIfNeeded {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (!(BOOL)[userDefaults objectForKey:@"FileIfNeeded"]) {
        
        NoteBookModel *model = [NoteBookModel new];
        model.noteBookTitle = @"默认标题";
        model.customCoverImageData = UIImagePNGRepresentation([UIImage imageNamed:@"AccountBookCover3"]);
        model.noteBookID = [CreateNoteBookID getNoteBookID];
        
        [userDefaults setObject:model.noteBookID forKey:@"isNoteBookSeleted"];
        [userDefaults synchronize];
        
        [SNRealmHelper addNewNoteBook:model];

        [userDefaults setBool:YES forKey:@"FileIfNeeded"];
        [userDefaults synchronize];
    }
}

@end
