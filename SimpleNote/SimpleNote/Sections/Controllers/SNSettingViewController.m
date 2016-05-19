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
#import "AMScrollingNavbar.h"

#define MaxIconWH  70.0  //用户头像最大的尺寸
#define MinIconWH  30.0  // 用户头像最小的头像
#define MaxIconCenterY  44 // 头像最大的centerY
#define MinIconCenterY 22
#define maxScrollOff 180

@interface SNSettingViewController ()<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *fileID;

@property (strong, nonatomic) UIImageView * titleIMg;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar addSubview:self.titleIMg];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleIMg removeFromSuperview];
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
        return 6;
    }else if(section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCellID" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"SimpleNote"];
        cell.textLabel.text = [AVUser currentUser].username;
    }else if (indexPath.section == 1){
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

    }else if (indexPath.section == 2) {
        cell.textLabel.text = @"退出";
        
    }
    
    
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld行",indexPath.row);
    if (indexPath.row == 1) {
        NSLog(@"黑夜");

    }
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
            [self getFileID];
        } progressBlock:^(NSInteger percentDone) {
            NSLog(@"percentDone : %ld",percentDone);
        }];

        
    }else if(indexPath.row == 7) {
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
//                    NSString *realmPath = [documentsDirectory stringByAppendingPathComponent:@"default.realm"];
                    
                    NSString *realmPath ;//= [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.realm",[AVUser currentUser].username]];
                    
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
                    
                    
                    
//                    if ([[NSFileManager defaultManager] fileExistsAtPath:realmPath]) {
                        BOOL success = NO;//= [[NSFileManager defaultManager] removeItemAtPath:realmPath error:nil];
                        
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
                    
//                    NSString *asd = [RLMRealmConfiguration defaultConfiguration].fileURL.absoluteString;
                    
                    
                        
                        if (YES) {
                            [data writeToFile:realmPath atomically:YES];
                            
                        }else {
                            kTipAlert(@"删除本地文件失败");
                        }
                    
                    
                }
            } progressBlock:^(NSInteger percentDone) {
                NSLog(@"percentDone : %ld",percentDone);
            }];
        }];

        
    }else if(indexPath.row == 8) {
        NSLog(@"delete default.realm from leancloud");

        if([NSString isBlankString:self.fileID]) {
            kTipAlert(@"无远端笔记，无法删除");
        }
        
        //第一步先得到文件实例, 其中会包含文件的地址
        [AVFile getFileWithObjectId:self.fileID withBlock:^(AVFile *file, NSError *error) {
            NSLog(@"删除中file.url : %@",file.url);//返回一个唯一的 Url 地址
            NSLog(@"objectId : %@",file.objectId);
            [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"删除成功");
                    [[AVUser currentUser] setObject:@"" forKey:@"realmFileID"];
                    [[AVUser currentUser] saveInBackground];
                    [self getFileID];
                }
                
            }];
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    // 是scrollview的偏移量
    CGFloat updateY = scrollView.contentOffset.y ;
    NSLog(@"%f",scrollView.contentOffset.y);
    
    
    //  随着scrollview 的滚动， 改变bounds
    CGRect bound = _titleIMg.bounds;
    // 随着滚动缩减的头像的尺寸
    CGFloat reduceW =  updateY  *(MaxIconWH - MinIconWH)/(maxScrollOff - 64);
    reduceW = reduceW < 0 ? 0 : reduceW;
    // 宽度缩小的幅度要和headview偏移的幅度成比例，但是最小的宽度不能小于MinIconWH
    CGFloat yuanw =  MAX(MinIconWH, MaxIconWH - reduceW);
    _titleIMg.layer.cornerRadius = yuanw/2.0;
    bound.size.height = yuanw;
    bound.size.width  = yuanw;
    _titleIMg.bounds = bound;
    
    
    // 改变center  max - min 是滚动 center y值 最大的偏差
    CGPoint center = _titleIMg.center;
    CGFloat yuany =  MAX(MinIconCenterY, MaxIconCenterY - updateY * (MaxIconCenterY - MinIconCenterY)/(maxScrollOff - 64) ) ;
    yuany = yuany > MaxIconCenterY ? MaxIconCenterY : yuany;
    
    center.y = yuany;
    _titleIMg.center = center;
    
}


#pragma mark - getters and setters
- (UIImageView *)titleIMg{
    if(_titleIMg == nil){
        UIImageView * img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:@"SimpleNote"];
        img.bounds = CGRectMake(0, 0, MaxIconWH, MaxIconWH);
        img.center = CGPointMake(SCREEN_WIDTH*0.5, MaxIconCenterY);
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.borderColor = [UIColor whiteColor].CGColor;
        img.layer.borderWidth = 1.2;
        img.layer.cornerRadius = MaxIconWH/2.0;
        img.layer.masksToBounds = YES;
        _titleIMg = img;
    }
    return _titleIMg;
}



@end
