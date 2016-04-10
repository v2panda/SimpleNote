//
//  SeViewController.m
//  DemoYYText
//
//  Created by Panda on 16/4/8.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "SeViewController.h"
#import "YYText.h"
#import "YYCategories.h"
#import "YYTextExampleHelper.h"
#import "TempModel.h"


@interface SeViewController ()<YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, assign) YYTextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISwitch *verticalSwitch;
@property (nonatomic, strong) UISwitch *debugSwitch;
@property (nonatomic, strong) UISwitch *exclusionSwitch;

@property (nonatomic, strong) NSMutableAttributedString *archiveStr;


@end

@implementation SeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"self.str :%@",self.attributedString);
    
    NSData *data = [self.attributedString yy_archiveToData];
    
    self.archiveStr = [NSMutableAttributedString yy_unarchiveFromData:data];
    
    __block UIImage *tempImage;
    NSMutableArray<UIImage *> *tempArray = @[].mutableCopy;
    [self.attributedString enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, self.attributedString.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[YYTextAttachment class]]) {
                          //替换
                          YYTextAttachment *tt = (YYTextAttachment *)value;
                          tempImage = tt.content;
                          NSLog(@"value - %@-%@",value,tempImage);
                          [tempArray addObject:tempImage];
                      }
    }];
    __block int i = 0;
    [self.archiveStr enumerateAttribute:YYTextAttachmentAttributeName inRange:NSMakeRange(0, self.archiveStr.length)
                                      options:0
                                   usingBlock:^(id value, NSRange range, BOOL *stop) {
                                       //检查类型是否是自定义NSTextAttachment类
                                       if (value && [value isKindOfClass:[YYTextAttachment class]]) {
                                           
                                           
                                           YYTextAttachment *tt = (YYTextAttachment *)value;
                                           
                                           UIImage *ima = tempArray[i++];
                                           [ima imageByResizeToSize:CGSizeMake(128, 128)];
                                           
                                           tt.content = ima;
                                           NSLog(@"archiveStrvalue - %@ - %@ - %@",value,tt.content,ima);
                                       }
                                   }];
    NSLog(@"archiveStr :%@",self.archiveStr);
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initImageView];
    __weak typeof(self) _self = self;
    
    UIView *toolbar;
    if ([UIVisualEffectView class]) {
        toolbar = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    } else {
        toolbar = [UIToolbar new];
    }
    toolbar.size = CGSizeMake(kScreenWidth, 40);
    toolbar.top = kiOS7Later ? 64 : 0;
    [self.view addSubview:toolbar];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.str];
    text.yy_font = [UIFont fontWithName:@"Times New Roman" size:20];
    text.yy_lineSpacing = 4;
    text.yy_firstLineHeadIndent = 20;
    
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = self.archiveStr;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        textView.height -= 64;
    }
    textView.contentInset = UIEdgeInsetsMake(toolbar.bottom, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    [self.view insertSubview:textView belowSubview:toolbar];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    /*------------------------------ Toolbar ---------------------------------*/
    UILabel *label;
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Vertical:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = 10;
    [toolbar addSubview:label];
    
    _verticalSwitch = [UISwitch new];
    [_verticalSwitch sizeToFit];
    _verticalSwitch.centerY = toolbar.height / 2;
    _verticalSwitch.left = label.right - 5;
    _verticalSwitch.layer.transformScale = 0.8;
    [_verticalSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [_self.textView endEditing:YES];
        if (switcher.isOn) {
            [_self setExclusionPathEnabled:NO];
            _self.exclusionSwitch.on = NO;
        }
        _self.exclusionSwitch.enabled = !switcher.isOn;
        _self.textView.verticalForm = switcher.isOn; /// Set vertical form
    }];
    [toolbar addSubview:_verticalSwitch];
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Debug:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = _verticalSwitch.right + 5;
    [toolbar addSubview:label];
    
    _debugSwitch = [UISwitch new];
    [_debugSwitch sizeToFit];
    _debugSwitch.on = [YYTextExampleHelper isDebug];
    _debugSwitch.centerY = toolbar.height / 2;
    _debugSwitch.left = label.right - 5;
    _debugSwitch.layer.transformScale = 0.8;
    [_debugSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [YYTextExampleHelper setDebug:switcher.isOn];
    }];
    [toolbar addSubview:_debugSwitch];
    
    label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Exclusion:";
    label.size = CGSizeMake([label.text widthForFont:label.font] + 2, toolbar.height);
    label.left = _debugSwitch.right + 5;
    [toolbar addSubview:label];
    
    _exclusionSwitch = [UISwitch new];
    [_exclusionSwitch sizeToFit];
    _exclusionSwitch.centerY = toolbar.height / 2;
    _exclusionSwitch.left = label.right - 5;
    _exclusionSwitch.layer.transformScale = 0.8;
    [_exclusionSwitch addBlockForControlEvents:UIControlEventValueChanged block:^(UISwitch *switcher) {
        [_self setExclusionPathEnabled:switcher.isOn];
    }];
    [toolbar addSubview:_exclusionSwitch];
    
    
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}
- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}


- (BOOL)testSave:(TempModel *)tempModel {
    // 获取doc的目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接保存的路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"OAuth.data"];
    // 存储返回的用户信息
    return  [NSKeyedArchiver archiveRootObject:tempModel toFile:filePath];
}

- (TempModel *)tempModel
{
    // 获取doc的目录
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 拼接保存的路径
    NSString *filePath = [docPath stringByAppendingPathComponent:@"OAuth.data"];
    // 获取用户存储的授权信息
    TempModel *OAuth = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    if (!OAuth) {
        OAuth = [[TempModel alloc]init];
    }
    return OAuth;
}


- (void)setExclusionPathEnabled:(BOOL)enabled {
    if (enabled) {
        [self.textView addSubview:self.imageView];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.frame
                                                        cornerRadius:self.imageView.layer.cornerRadius];
        self.textView.exclusionPaths = @[path]; /// Set exclusion paths
    } else {
        [self.imageView removeFromSuperview];
        self.textView.exclusionPaths = nil;
    }
}

- (void)initImageView {
    NSData *data = [NSData dataNamed:@"dribbble256_imageio.png"];
    UIImage *image = [[UIImage alloc] initWithData:data scale:2];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.layer.cornerRadius = imageView.height / 2;
    imageView.center = CGPointMake(kScreenWidth / 2, kScreenWidth / 2);
    self.imageView = imageView;
    
    
    __weak typeof(self) _self = self;
    UIPanGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(UIPanGestureRecognizer *g) {
        __strong typeof(_self) self = _self;
        if (!self) return;
        CGPoint p = [g locationInView:self.textView];
        self.imageView.center = p;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.imageView.frame
                                                        cornerRadius:self.imageView.layer.cornerRadius];
        self.textView.exclusionPaths = @[path];
    }];
    [imageView addGestureRecognizer:g];
}

- (void)edit:(UIBarButtonItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}


- (void)showMessage:(NSString *)msg {
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.width = self.view.width;
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
    
    label.bottom = (kiOS7Later ? 64 : 0);
    [self.view addSubview:label];
    [UIView animateWithDuration:0.3 animations:^{
        label.top = (kiOS7Later ? 64 : 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = (kiOS7Later ? 64 : 0);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect {
    NSLog(@"tap text range:...%@",highlight.attributes);
    
    
    
    
}
#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
}


- (NSMutableAttributedString *)archiveStr {
    if (!_archiveStr) {
        _archiveStr = [[NSMutableAttributedString alloc]init];
    }
    return _archiveStr;
}

@end
