//
//  SNSettingViewController.m
//  SimpleNote
//
//  Created by Panda on 16/5/17.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNSettingViewController.h"
#import <Realm/Realm.h>
#import "SNRealmHelper.h"
#import "CurrentUserCell.h"
#import <BlocksKit/BlocksKit.h>
#import "SNUserSettingController.h"
#import "SNProgressView.h"

@interface SNSettingViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *fileID;

@property (nonatomic, strong) SNProgressView *progressView;

@end

@implementation SNSettingViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    [self followScrollView:self.tableView withDelay:20.0];
    [self getFileID];

}



#pragma mark - event response

- (void)getFileID {
    __block NSString *fileId = @"";
    
    AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:[AVUser currentUser].objectId block:^(AVObject *object, NSError *error) {
        NSLog(@"realmFileID : %@",[object objectForKey:@"realmFileID"]);
        fileId = [NSString stringWithFormat:@"%@",[object objectForKey:@"realmFileID"]];
        self.fileID = [NSString stringWithFormat:@"%@",[object objectForKey:@"realmFileID"]];
    }];
    NSLog(@"fileId - %@",fileId);

}

#pragma mark - event response
- (IBAction)backItemDidTouched:(UIBarButtonItem *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:kDownLoadAllNote object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1) {
        return 5;
    }else if(section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }else {
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        CurrentUserCell *cell = [CurrentUserCell cellWithTableView:tableView];
        cell.userImageView.image = [UIImage imageNamed:@"SimpleNote"];
        cell.userLabel.text = [AVUser currentUser].username;
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"同步笔记到云端";
            cell.imageView.image = [UIImage imageNamed:@"Upload to Cloud-22"];
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"下载笔记到本地";
            cell.imageView.image = [UIImage imageNamed:@"Download From Cloud-22"];
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"分享App";
            cell.imageView.image = [UIImage imageNamed:@"Upload Filled"];
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"意见反馈";
            cell.imageView.image = [UIImage imageNamed:@"Read Message Filled-22"];
        }else if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"版本信息";
            cell.imageView.image = [UIImage imageNamed:@"Trophy"];
            NSDictionary *md =[NSBundle mainBundle].infoDictionary;
            NSString *currentVersion = md[@"CFBundleShortVersionString"];
            cell.detailTextLabel.text = currentVersion;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 2) {
        UITableViewCell *cell = [UITableViewCell new];
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"退出当前账户";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld行",indexPath.row);
    if (indexPath.section == 0) {
        NSLog(@"个人资料");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SNUserSettingControllerID"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSLog(@"upload default.realm to leancloud");
            NSString *realmPath = [RLMRealmConfiguration defaultConfiguration].fileURL.relativePath;
            
            AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"SimpleNote%@",[AVUser currentUser].objectId] contentsAtPath: realmPath];
            
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"file.url : %@",file.url);//返回一个唯一的 Url 地址
                NSLog(@"objectId : %@",file.objectId);
                [[AVUser currentUser] setObject:file.objectId forKey:@"realmFileID"];
                [[AVUser currentUser] saveInBackground];
                [self getFileID];
            } progressBlock:^(NSInteger percentDone) {
                NSLog(@"percentDone : %ld",percentDone);
                self.progressView.hidden = NO;
                self.progressView.progressValue = percentDone / 100.f;
                if (percentDone == 100) {
                    self.progressView.hidden = YES;
                }
            }];
        }else if (indexPath.row == 1) {
            NSLog(@"downl default.realm from leancloud");
            
            if([NSString isBlankString:self.fileID]) {
                kTipAlert(@"无远端笔记");
            }
            
            //第一步先得到文件实例, 其中会包含文件的地址
            [AVFile getFileWithObjectId:self.fileID withBlock:^(AVFile *file, NSError *error) {
                //文件实例获取成功可以再进一步获取文件内容
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (data) {
                        //获取到了文件内容
                        NSLog(@"获取到了文件内容");
                        
                        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                        
                        NSString *realmPath ;
                        
                        NSString *currentRealm = [[NSUserDefaults standardUserDefaults]stringForKey:kCurrentRealm];
                        
                        if ([currentRealm isEqualToString:[AVUser currentUser].username]) {
                            
                            realmPath = [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
                            
                            [[NSUserDefaults standardUserDefaults]setObject:@"default" forKey:kCurrentRealm];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }else {
                            
                            realmPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.realm",[AVUser currentUser].username]];
                            
                            [[NSUserDefaults standardUserDefaults]setObject:[AVUser currentUser].username forKey:kCurrentRealm];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                        }
                        
                        BOOL success = NO;
                        
                        NSFileManager *manager = [NSFileManager defaultManager];
                        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
                        NSArray<NSURL *> *realmFileURLs = @[
                                                            config.fileURL,
                                                            [config.fileURL URLByAppendingPathExtension:@"lock"],
                                                            [config.fileURL URLByAppendingPathExtension:@"log_a"],
                                                            [config.fileURL URLByAppendingPathExtension:@"log_b"],
                                                            [config.fileURL URLByAppendingPathExtension:@"note"]
                                                            ];
                        for (NSURL *URL in realmFileURLs) {
                            NSError *error = nil;
                            success =  [manager removeItemAtURL:URL error:&error];
                            if (error) {
                                // 处理错误
                            }
                        }
                        
                        if (success) {
                            [data writeToFile:realmPath atomically:YES];
                            
                        }else {
                            kTipAlert(@"删除本地文件失败");
                        }
                    }
                } progressBlock:^(NSInteger percentDone) {
                    NSLog(@"percentDone : %ld",percentDone);
                    self.progressView.hidden = NO;
                    self.progressView.progressValue = percentDone / 100.f;
                    if (percentDone == 100) {
                        self.progressView.hidden = YES;
                    }
                }];
            }];

        }else if (indexPath.row == 2) {
            NSLog(@"分享App");
        }else if (indexPath.row == 3) {
            NSLog(@"意见反馈");
        }else if (indexPath.row == 4) {
            NSLog(@"给App评分");
        }
    }else if (indexPath.section == 2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定退出当前账户" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [AVUser logOut];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&Register" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login&RegisterID"];
            [self presentViewController:vc animated:YES completion:nil];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - getters and setters
- (SNProgressView *)progressView {
    if (!_progressView) {
        _progressView = [SNProgressView viewWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT/2 -80, 80, 80) circlesSize:CGRectMake(30, 5, 30, 5)];
        _progressView.layer.cornerRadius = 10;
        _progressView.progressValue = 0.2;
        _progressView.hidden = YES;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}





@end
