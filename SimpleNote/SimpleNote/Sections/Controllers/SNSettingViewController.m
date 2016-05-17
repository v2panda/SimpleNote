//
//  SNSettingViewController.m
//  SimpleNote
//
//  Created by Panda on 16/5/17.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNSettingViewController.h"

@interface SNSettingViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *fileID;

@end

@implementation SNSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getFileID];
}

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellID" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"通用设置";
        cell.imageView.image = [UIImage imageNamed:@"Settings"];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"黑夜模式";
        cell.imageView.image = [UIImage imageNamed:@"Bright Moon"];
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"分享APP";
        cell.imageView.image = [UIImage imageNamed:@"Upload Filled"];
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"评分";
        cell.imageView.image = [UIImage imageNamed:@"Trophy"];
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"退出";
        cell.imageView.image = [UIImage imageNamed:@"Export Filled"];
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"上传";
        cell.imageView.image = [UIImage imageNamed:@"Export Filled"];
    }else if(indexPath.row == 6) {
        cell.textLabel.text = @"upload default.realm to leancloud";
    }else if(indexPath.row == 7) {
        cell.textLabel.text = @"downl default.realm from leancloud";
    }else if(indexPath.row == 8) {
        cell.textLabel.text = @"delete default.realm from leancloud";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld行",indexPath.row);
   if (indexPath.row == 5) {
       NSLog(@"上传");
    }
    if(indexPath.row == 6) {
        NSLog(@"upload default.realm to leancloud");
        
        NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *realmPath = [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
        AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"SimpleNote%@",[AVUser currentUser].objectId] contentsAtPath: realmPath];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"file.url : %@",file.url);//返回一个唯一的 Url 地址
            NSLog(@"objectId : %@",file.objectId);
            [[AVUser currentUser] setObject:file.objectId forKey:@"realmFileID"];
            [[AVUser currentUser] saveInBackground];
        }];

        
    }else if(indexPath.row == 7) {
        NSLog(@"downl default.realm from leancloud");
        
        //第一步先得到文件实例, 其中会包含文件的地址
        [AVFile getFileWithObjectId:self.fileID withBlock:^(AVFile *file, NSError *error) {
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

        
    }else if(indexPath.row == 8) {
        NSLog(@"delete default.realm from leancloud");

        //第一步先得到文件实例, 其中会包含文件的地址
        [AVFile getFileWithObjectId:self.fileID withBlock:^(AVFile *file, NSError *error) {
            NSLog(@"删除中file.url : %@",file.url);//返回一个唯一的 Url 地址
            NSLog(@"objectId : %@",file.objectId);
            [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"删除成功");
            }];;
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
