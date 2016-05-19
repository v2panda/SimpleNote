//
//  SNUserSettingController.m
//  SimpleNote
//
//  Created by Panda on 16/5/19.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SNUserSettingController.h"

@interface SNUserSettingController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) UIImageView * titleIMg;
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
    self.nameLabel.text = [AVUser currentUser].username;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:self.titleIMg];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleIMg removeFromSuperview];
}


- (IBAction)editButtonDidTouched:(UIButton *)sender {
    NSLog(@"editButtonDidTouched");
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.row == 0) {
        cell.textLabel.text = @"头像";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"个人网站";
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"描述";
    }else if (indexPath.row == 4) {
        cell.textLabel.text = @"重置密码";
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath : %ld",indexPath.row);
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
