//
//  AppDelegate.m
//  SimpleNote
//
//  Created by Panda on 16/3/31.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "AppDelegate.h"
#import "SNCacheHelper.h"
#import "NoteBookModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self InitFileIfNeeded];
    return YES;
}

- (void)InitFileIfNeeded {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"FileIfNeeded"]) {
        
        NoteBookModel *model = [NoteBookModel new];
        model.noteBookTitle = @"默认标题";
        model.customCoverImageData = UIImagePNGRepresentation([UIImage imageNamed:@"AccountBookCover3"]);
        model.noteBookID = [CreateNoteBookID getNoteBookID];
        
        [[NSUserDefaults standardUserDefaults]setObject:model.noteBookID forKey:@"isNoteBookSeleted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[SNCacheHelper sharedManager]storeNoteBook:model];

        [userDefaults setBool:YES forKey:@"FileIfNeeded"];
        [userDefaults synchronize];
    }
}

@end
