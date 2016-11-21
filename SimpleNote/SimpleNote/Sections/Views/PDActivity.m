//
//  PDActivity.m
//  AlertController
//
//  Created by Panda on 16/5/24.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "PDActivity.h"

@implementation PDActivity

-(instancetype)initWithImage:(UIImage *)shareImage atURL:(NSString *)URL atTitle:(NSString *)title atShareContentArray:(NSArray *)shareContentArray {
    if(self = [super init]){
        _shareImage = shareImage;
        _URL = URL;
        _title = title;
        _getShareArray = [[NSArray alloc]initWithArray:shareContentArray];
    }
    return self;
}
// 以下方法都是自定义UiActivity需要重写的方法
+(UIActivityCategory)activityCategory {
    return UIActivityCategoryShare;
}
// 设置类型
-(NSString *)activityType {
    return _title;
}
// 设置现实的标题
-(NSString *)activityTitle {
    return _title;
}
// 图片
-(UIImage *)activityImage {
    return _shareImage;
}
// 返回yes就行，这个表示该分享是不是在controller中显示
-(BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}
// 是不是自定义的controller，如果为空，则调用performActivity方法
- (UIViewController *)activityViewController {
    return nil;
}
// 点击分享图标之后触发的方法
-(void)performActivity {
    if(nil == _title) {
        return;
    }
    NSLog(@"要分享的内容-----%@",_getShareArray);
    NSLog(@"分享的类型------ %@",_title);
    if([_title isEqualToString:@"v2panda.com"]){
        NSURL *URL = [NSURL URLWithString:kDefaultURL];
        [[UIApplication sharedApplication] openURL:URL];
    }
}
@end
