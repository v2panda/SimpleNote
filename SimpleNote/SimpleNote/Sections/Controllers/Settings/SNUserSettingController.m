//
//  SNUserSettingController.m
//  SimpleNote
//
//  Created by Panda on 16/5/19.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNUserSettingController.h"
#import "TZImagePickerController.h"
#import "UIAlertController+PDAdd.h"
#import "SNProgressView.h"

@interface SNUserSettingController () <TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView * titleIMg;
@property (nonatomic, strong) SNProgressView *progressView;


@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userSite;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, strong) AVFile *avatar;

@end

#define MaxIconWH  70.0  //用户头像最大的尺寸
#define MinIconWH  30.0  // 用户头像最小的头像
#define MaxIconCenterY  44 // 头像最大的centerY
#define MinIconCenterY 22
#define maxScrollOff 180


@implementation SNUserSettingController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(userInfoSaved)];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.titleIMg];
    [self getUserInfoData];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleIMg removeFromSuperview];
}

#pragma mark - event response

- (void)userInfoSaved {
    NSLog(@"存储信息");
    
    if (self.avatar) {
        [self uploadToCloud];
    }
    
    if (![self.nickName isEqualToString:[SNUserTool userInfo].nickName]) {
        [[AVUser currentUser] setObject:self.nickName forKey:@"nickName"];
        [[AVUser currentUser] saveInBackground];
        SNUserModel *model = [SNUserTool userInfo];
        model.nickName = self.nickName;
        [SNUserTool saveUserInfo:model];
    }
    if (![self.userSite isEqualToString:[SNUserTool userInfo].userSite]) {
        [[AVUser currentUser] setObject:self.userSite forKey:@"userSite"];
        [[AVUser currentUser] saveInBackground];
        SNUserModel *model = [SNUserTool userInfo];
        model.userSite = self.userSite;
        [SNUserTool saveUserInfo:model];
    }
    if (![self.describe isEqualToString:[SNUserTool userInfo].describe]) {
        [[AVUser currentUser] setObject:self.describe forKey:@"describe"];
        [[AVUser currentUser] saveInBackground];
        SNUserModel *model = [SNUserTool userInfo];
        model.describe = self.describe;
        [SNUserTool saveUserInfo:model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)uploadToCloud {
    
    if(![NSString isBlankString:[SNUserTool userInfo].avatarObjID]) {
        [AVFile getFileWithObjectId:[SNUserTool userInfo].avatarObjID withBlock:^(AVFile *file, NSError *error) {
            [file deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"删除头像成功");
            }];;
        }];
    }
    
    [self.avatar saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"file.url : %@",self.avatar.url);//返回一个唯一的 Url 地址
        NSLog(@"objectId : %@",self.avatar.objectId);
        [[AVUser currentUser] setObject:self.avatar.url forKey:@"avatar"];
        [[AVUser currentUser] saveInBackground];
        
        SNUserModel *model = [SNUserTool userInfo];
        model.avatarUrl = self.avatar.url;
        model.avatarObjID = self.avatar.objectId;
        [SNUserTool saveUserInfo:model];
  
    } progressBlock:^(NSInteger percentDone) {
        NSLog(@"percentDone : %ld",percentDone);
        self.progressView.hidden = NO;
        self.progressView.progressValue = percentDone / 100.f;
        if (percentDone == 100) {
            self.progressView.hidden = YES;
        }
        
    }];
}

- (void)getUserInfoData {
    self.nameLabel.text = [SNUserTool userInfo].nickName;
    self.descriptionLabel.text = [SNUserTool userInfo].describe;
    self.userSite = [SNUserTool userInfo].userSite;
    self.nickName = [SNUserTool userInfo].nickName;
    self.describe = [SNUserTool userInfo].describe;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    UIImage *pickerImage = [photos.firstObject imageByResizeToSize:CGSizeMake(75, 75)];
    
    self.titleIMg.image  = pickerImage;
    
    NSData *imageData = UIImagePNGRepresentation(pickerImage);
    
    self.avatar = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png",[AVUser currentUser].username] data:imageData];
}


#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row == 0) {
        cell.textLabel.text = @"头像";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.nickName;
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"个人网站";
        cell.detailTextLabel.text = self.userSite;
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"个人简介";
        cell.detailTextLabel.text = self.describe;
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"绑定邮箱";
        if ([SNUserTool userInfo].email) {
            cell.detailTextLabel.text = [SNUserTool userInfo].email;
        }
    }else if (indexPath.row == 5) {
        cell.textLabel.text = @"重置密码";
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath : %ld",indexPath.row);
    if(indexPath.row == 0) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        imagePickerVc.navigationBar.barTintColor = SNColor(117, 106, 102);
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }else if (indexPath.row == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = self.nickName;
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textfield = alertController.textFields.firstObject;
            NSLog(@"textfield : %@",textfield.text);
            self.nickName = textfield.text;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alertController addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"请输入个人网站" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = self.userSite;
        }];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textfield = alertController.textFields.firstObject;
            NSLog(@"textfield : %@",textfield.text);
            self.userSite = textfield.text;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        [alertController addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SNUserEditViewControllerID"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
        NSString *email = [SNUserTool userInfo].email;
        kTipAlert(@"邮箱:%@",email);
    }else if (indexPath.row == 5) {
        [AVUser requestPasswordResetForEmailInBackground:[SNUserTool userInfo].email block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                kTipAlert(@"已向注册邮箱发送重置邮件，注意查收！");
            } else {
                NSLog(@"errorcode : %ld",error.code);
            }
        }];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 是scrollview的偏移量
    CGFloat updateY = scrollView.contentOffset.y ;
    
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
        [img sd_setImageWithURL:[NSURL URLWithString:[SNUserTool userInfo].avatarUrl] placeholderImage:[UIImage imageNamed:@"Circled User Male"]];
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
