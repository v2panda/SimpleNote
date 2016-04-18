//
//  ViewController.m
//  RealmDemo
//
//  Created by Panda on 16/4/15.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "ViewController.h"
#import "NoteBookModel.h"
#import "NoteModel.h"
#import "SNRealmHelper.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CreateNoteBookID.h"

@interface ViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[SNRealmHelper getLocalPath]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"sign in leancloud";
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"init notebook and an default note";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"add new note to default notebook";
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"add new notebook";
    }else if(indexPath.row == 4) {
        cell.textLabel.text = @"upload default.realm to leancloud";
    }else if(indexPath.row == 5) {
        cell.textLabel.text = @"downl default.realm from leancloud";
    }else if(indexPath.row == 6) {
        cell.textLabel.text = @"delete default.realm from leancloud";
    }else if(indexPath.row == 7) {
        cell.textLabel.text = @"delete notebook";
    }else if(indexPath.row == 8) {
        cell.textLabel.text = @"read all notes for notebook";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第%ld行被点击了",indexPath.row);
    if (indexPath.row == 0) {
        [AVUser logInWithUsernameInBackground:@"Tom" password:@"cat!@#123" block:^(AVUser *user, NSError *error) {
            if (user != nil) {
                NSLog(@"登录成功");
                
            } else {
                NSLog(@"登录失败");
            }
        }];
    }
    if (indexPath.row == 1) {
        [SNRealmHelper initDefaultNotebook];
    }else if (indexPath.row == 2) {
        NoteModel *note = [NoteModel new];
        note.noteTitle = @"Add Note Title";
        note.noteID = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]].stringValue;
        
        RLMResults *result = [NoteBookModel objectsWhere:@"noteBookID = %d",1002];
        NoteBookModel *notebook = (NoteBookModel *)result.firstObject;
        note.owner = notebook;
        [SNRealmHelper addNewNote:note];
    }else if (indexPath.row == 3) {
        NoteBookModel *notebook = [NoteBookModel new];
        notebook.noteBookID = [CreateNoteBookID getNoteBookID];
        notebook.noteBookTitle = @"New NoteBook Title";
        notebook.customCoverImageData = [NSData data];
        [SNRealmHelper addNewNoteBook:notebook];
    }else if (indexPath.row == 4) {
        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *realmPath = [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
        AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"SimpleNote%@",[AVUser currentUser].objectId] contentsAtPath: realmPath];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"file.url : %@",file.url);//返回一个唯一的 Url 地址
            NSLog(@"objectId : %@",file.objectId);
            [[AVUser currentUser] setObject:file.objectId forKey:@"realmFileID"];
            [[AVUser currentUser] saveInBackground];
        }];
    }else if (indexPath.row == 5) {
        __block NSString *fileId = @"";
        
        AVQuery *query = [AVQuery queryWithClassName:@"_User"];
        [query getObjectInBackgroundWithId:[AVUser currentUser].objectId block:^(AVObject *object, NSError *error) {
            NSLog(@"realmFileID : %@",[object objectForKey:@"realmFileID"]);
            fileId = [NSString stringWithFormat:@"%@",[object objectForKey:@"realmFileID"]];
        }];
        
        //第一步先得到文件实例, 其中会包含文件的地址
        [AVFile getFileWithObjectId:fileId withBlock:^(AVFile *file, NSError *error) {
            //文件实例获取成功可以再进一步获取文件内容
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) {
                    //获取到了文件内容
                    NSLog(@"获取到了文件内容");
                    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                    NSString *realmPath = [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
                     [data writeToFile:realmPath atomically:YES];
                }
            } progressBlock:^(NSInteger percentDone) {
                
            }];
        }];
    }else if(indexPath.row == 6) {
        NSString *fileId = @"571498f7ebcb7d0055c794b5";
        //第一步先得到文件实例, 其中会包含文件的地址
        [AVFile getFileWithObjectId:fileId withBlock:^(AVFile *file, NSError *error) {
            
            [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"删除成功");
            }];;
        }];
    }else if(indexPath.row == 7) {
        RLMResults *result = [NoteBookModel objectsWhere:@"noteBookID = %d",1001];
        NoteBookModel *notebook = (NoteBookModel *)result.firstObject;
        [SNRealmHelper deleteNoteBook:notebook];
    }else if(indexPath.row == 8) {
        RLMResults *result = [NoteBookModel objectsWhere:@"noteBookID = %d",1002];
        NoteBookModel *notebook = (NoteBookModel *)result.firstObject;
        NSLog(@"readAllNotesFromNotebook : %@",[SNRealmHelper readAllNotesFromNotebook:notebook]);
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([@"sd" isEqualToString:@"222"]) {
        NoteModel *note2 = [NoteModel new];
        note2.noteTitle = @"testtitle22315";
        note2.noteID = @"22315";
        NoteModel *note3 = [NoteModel new];
        note3.noteTitle = @"testtitle233";
        note3.noteID = @"2323";
        NoteModel *note4 = [NoteModel new];
        note4.noteTitle = @"testtitle234";
        note4.noteID = @"2324";
        
        //    NoteBookModel *noteBook = [NoteBookModel new];
        //    noteBook.noteBookID = @(10003);
        //    noteBook.noteBookTitle = @"AlphaGo";
        RLMResults *tanDogs = [NoteBookModel allObjects];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"owner = %@",
                             tanDogs.firstObject];
        tanDogs = [NoteModel objectsWithPredicate:pred];
        
        //    note2.owner = tanDogs.firstObject;
        //    note3.owner = noteBook;
        //    note4.owner = noteBook;
        
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        //    [NoteModel createOrUpdateInRealm:realm withValue:note2];
        //    [realm addObject:note2];
        //    [realm addObject:note3];
        //    [realm addObject:note4];
        [realm commitWriteTransaction];
        NSString *str = NSHomeDirectory();
        NSLog(@"%@",str);
    }
}

@end
