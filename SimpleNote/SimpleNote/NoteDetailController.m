//
//  NoteDetailController.m
//  SimpleNote
//
//  Created by 徐臻 on 15/3/19.
//  Copyright (c) 2015年 xuzhen. All rights reserved.
//

#import "NoteDetailController.h"
#import "SVProgressHUD.h"
#import "VNConstants.h"

#import "Colours.h"
#import "UIColor+VNHex.h"


@import MessageUI;

static const CGFloat kViewOriginY = 70;
static const CGFloat kTextFieldHeight = 30;
static const CGFloat kToolbarHeight = 44;
static const CGFloat kVoiceButtonWidth = 100;

@interface NoteDetailController () <UIActionSheetDelegate,
                                    MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UITextFieldDelegate>
{
  VNNote *_note;
  UITextView *_contentTextView;

  UIButton *_encryptButton;
    DeformationButton* ton;
    UITextField *_titleFiled;
    UITextField *encryptTxt;
    UITextField *encryptTxt2;
    NSString *encryptStr;
    NSString *changeStr;
    NSString *changeStr2;
    UISlider *mySlider;
    NSArray *colorArr;
    NSInteger colorCount;
    

  BOOL _isEditingTitle;
}
@property(nonatomic,strong)SCLAlertView *alert;
@end

@implementation NoteDetailController

- (instancetype)initWithNote:(VNNote *)note
{
  self = [super init];
  if (self) {
    _note = note;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
    
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self initComps];
  [self setupNavigationBar];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
    
    mySlider = [[UISlider alloc]initWithFrame:CGRectMake(kDeviceWidth/2 - 80, KDeviceHeight/2 - 50, 160, 50)];
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"font"];
    
    mySlider.value = [str floatValue];
    mySlider.maximumValue = 30;
    mySlider.minimumValue = 12;
    mySlider.alpha = .8;
    mySlider.backgroundColor = [UIColor whiteColor];
    [mySlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavigationBar
{
  UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ActionSheetSave", @"")
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(save)];

  UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(moreActionButtonPressed)];
  self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:moreItem, saveItem, nil];
}
-(void)changeColor
{
    
    colorArr = [NSArray arrayWithObjects:DefaultGreen,DefaultColor,DefaultRed,DefaultYellow,DefaultBlack,nil];
    colorCount = (colorCount + 1)%5;
    NSNumber *numObj = [NSNumber numberWithInteger:colorCount];
    [[NSUserDefaults standardUserDefaults]setObject:numObj forKey:@"contentTextView"];
    _contentTextView.textColor = colorArr[colorCount];
}

- (void)initComps
{
  CGRect frame = CGRectMake(kHorizontalMargin, kViewOriginY, self.view.frame.size.width - kHorizontalMargin * 2, kTextFieldHeight);

  UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
  doneBarButton.width = ceilf(self.view.frame.size.width) / 3 - 30;

  UIBarButtonItem *voiceBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"20150427041642990_easyicon_net_32"] style:UIBarButtonItemStylePlain target:self action:@selector(changeColor)];
  voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;

  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight)];
    UIBarButtonItem *itemLine = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  toolbar.tintColor = [UIColor systemColor];
  toolbar.items = [NSArray arrayWithObjects:itemLine,voiceBarButton, itemLine,doneBarButton,itemLine, nil];

    //标题
    _titleFiled = [[UITextField alloc]initWithFrame:CGRectMake(kHorizontalMargin, 70, kDeviceWidth - kHorizontalMargin * 2, 44)];
    _titleFiled.borderStyle     = UITextBorderStyleRoundedRect;
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 45.0f, 44.0f)];
    leftView.text   = NSLocalizedString(@"标题:", nil);
    leftView.font = [UIFont systemFontOfSize:18];
    leftView.textColor = [UIColor systemDarkColor];
    _titleFiled.textColor = [UIColor systemDarkColor];
    _titleFiled.leftView = leftView;
    _titleFiled.leftViewMode    = UITextFieldViewModeAlways;
    _titleFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    _titleFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if (_note) {
        _titleFiled.text = _note.title;
    }
    _titleFiled.inputAccessoryView = toolbar;
    _titleFiled.delegate = self;
    [self.view addSubview:_titleFiled];
    
  frame = CGRectMake(kHorizontalMargin,
                     kViewOriginY+44,
                     kDeviceWidth - kHorizontalMargin * 2,
                     KDeviceHeight -kVoiceButtonWidth - kVerticalMargin * 2 - kViewOriginY-44);
  _contentTextView = [[UITextView alloc] initWithFrame:frame];

    colorArr = [NSArray arrayWithObjects:DefaultGreen,DefaultColor,DefaultRed,DefaultYellow,DefaultBlack,nil];
    
    colorCount = [[[NSUserDefaults standardUserDefaults]objectForKey:@"contentTextView"] integerValue];
      _contentTextView.textColor = colorArr[colorCount];
    
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"font"];
    if (!str) {
        _contentTextView.font = [UIFont systemFontOfSize:16];
    }else{
  _contentTextView.font = [UIFont systemFontOfSize:[str floatValue]];
    }
  _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
  _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
  [_contentTextView setScrollEnabled:YES];
   
  if (_note) {
      self.title = _note.title;
    _contentTextView.text = _note.content;
  }
  _contentTextView.inputAccessoryView = toolbar;
  [self.view addSubview:_contentTextView];
    
    if (_note.encryptStr) {
//        _encryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_encryptButton setFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
//        [_encryptButton setTitle:NSLocalizedString(@"修改密码", nil) forState:UIControlStateNormal];
//        [_encryptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _encryptButton.layer.cornerRadius = kVoiceButtonWidth / 2;
//        _encryptButton.layer.masksToBounds = YES;
//        [_encryptButton setBackgroundColor:[UIColor systemColor]];
//        [_encryptButton addTarget:self action:@selector(changeCode) forControlEvents:UIControlEventTouchUpInside];
//        [_encryptButton setTintColor:[UIColor whiteColor]];
//        [self.view addSubview:_encryptButton];
        ton = [[DeformationButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
        [ton.forDisplayButton setTitle:NSLocalizedString(@"修改密码", @"") forState:UIControlStateNormal];
        [ton.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ton.contentColor = [UIColor systemColor];
        ton.progressColor = [UIColor whiteColor];
        [ton.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        
        ton.layer.cornerRadius = kVoiceButtonWidth / 2;
        ton.layer.masksToBounds = YES;
        [ton  setBackgroundColor:[UIColor systemColor]];
        [ton addTarget:self action:@selector(changeCode) forControlEvents:UIControlEventTouchUpInside];
        [ton setTintColor:[UIColor whiteColor]];
        [self.view addSubview:ton];
    }
    else
    {
//        _encryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_encryptButton setFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
//        [_encryptButton setTitle:NSLocalizedString(@"EncryptInput", @"") forState:UIControlStateNormal];
//        [_encryptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _encryptButton.layer.cornerRadius = kVoiceButtonWidth / 2;
//        _encryptButton.layer.masksToBounds = YES;
//        [_encryptButton setBackgroundColor:[UIColor systemColor]];
//        [_encryptButton addTarget:self action:@selector(encryptInput) forControlEvents:UIControlEventTouchUpInside];
//        [_encryptButton setTintColor:[UIColor whiteColor]];
//        [self.view addSubview:_encryptButton];
        
        //
        ton = [[DeformationButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
        [ton.forDisplayButton setTitle:NSLocalizedString(@"EncryptInput", @"") forState:UIControlStateNormal];
       [ton.forDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ton.contentColor = [UIColor systemColor];
        ton.progressColor = [UIColor whiteColor];
        [ton.forDisplayButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, 0)];
        
        ton.layer.cornerRadius = kVoiceButtonWidth / 2;
        ton.layer.masksToBounds = YES;
        [ton  setBackgroundColor:[UIColor systemColor]];
        [ton addTarget:self action:@selector(encryptInput) forControlEvents:UIControlEventTouchUpInside];
        [ton setTintColor:[UIColor whiteColor]];
        [self.view addSubview:ton];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self save];
}
#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toBeString.length > 10 &&_titleFiled.text.length > 5)
    {
        return NO;
    }else
    {
        return YES;
    }
}
-(void)changeCode
{
    _alert = [[SCLAlertView alloc] init];
    encryptTxt = [_alert addTextField:NSLocalizedString(@"输入旧密码", nil)];
    encryptTxt.delegate = self;
    encryptTxt.secureTextEntry = YES;
    encryptTxt2 = [_alert addTextField:NSLocalizedString(@"输入新密码", nil)];
    encryptTxt2.delegate = self;
    encryptTxt2.secureTextEntry = YES;
    [_alert addButton:NSLocalizedString(@"确定", nil) actionBlock:^(void) {
        
        if ([encryptTxt.text isEqualToString:_note.encryptStr] )
        {
            if ([self isBlankString:encryptTxt2.text]) {
                changeStr = encryptTxt.text;
                changeStr2 = nil;
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showSuccess:self title:NSLocalizedString(@"成功", nil) subTitle:NSLocalizedString(@"解密成功", nil) closeButtonTitle:NSLocalizedString(@"确定", nil) duration:0.0f];
            }else{
            changeStr = encryptTxt2.text;
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showSuccess:self title:NSLocalizedString(@"成功", nil) subTitle:NSLocalizedString(@"加密成功", nil) closeButtonTitle:NSLocalizedString(@"确定", nil) duration:0.0f];
            }
        }else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:NSLocalizedString(@"失败", nil) subTitle:NSLocalizedString(@"旧密码输入错误", nil) closeButtonTitle:NSLocalizedString(@"确定", nil) duration:0.0f];
        }
    }];
    [_alert showSuccess:self title:NSLocalizedString(@"至简加密", nil) subTitle:NSLocalizedString(@"请出入新旧密码", nil) closeButtonTitle:nil duration:0.0f];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [_alert.view addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    UIView *view1 = [_alert getShadowView];
    [view1 addGestureRecognizer:tap1];
}
-(void)tapClick
{
    if ([encryptTxt isFirstResponder] || [encryptTxt2 isFirstResponder]) {
        [self hideKeyboard];
        [UIView animateWithDuration:0.1 animations:^{
            UIView *view1 = [_alert getView];
            CGRect r = view1.frame;
            r.origin.y = r.origin.y +70;
            view1.frame =  r;
        }];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [encryptTxt resignFirstResponder];
     [encryptTxt2 resignFirstResponder];
}
-(void)encryptInput
{
    _alert = [[SCLAlertView alloc] init];
    
    encryptTxt = [_alert addTextField:NSLocalizedString(@"输入旧密码", nil)];
    encryptTxt.delegate = self;
    encryptTxt.secureTextEntry = YES;
    
    encryptTxt2 = [_alert addTextField:NSLocalizedString(@"再次输入", nil)];
    encryptTxt2.delegate = self;
    encryptTxt2.secureTextEntry = YES;
    __weak typeof(self) _weakSelf=self;
    [_alert addButton:NSLocalizedString(@"确定", nil) actionBlock:^(void) {
       
        if ([encryptTxt.text isEqualToString:encryptTxt2.text] && ![self isBlankString:encryptTxt.text])
        {
            encryptStr = encryptTxt.text;
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showSuccess:_weakSelf title:NSLocalizedString(@"成功", nil) subTitle:NSLocalizedString(@"加密成功", nil) closeButtonTitle:NSLocalizedString(@"确定", nil) duration:0.0f];
        }else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:_weakSelf title:NSLocalizedString(@"失败", nil) subTitle:NSLocalizedString(@"两次输入的密码不一致", nil) closeButtonTitle:NSLocalizedString(@"确定", nil) duration:0.0f];
        }
    }];
    [_alert showSuccess:self title:NSLocalizedString(@"至简加密", nil) subTitle:NSLocalizedString(@"请输入加密密码", nil) closeButtonTitle:nil duration:0.0f];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [_alert.view addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap1.numberOfTapsRequired = 1;
    tap1.numberOfTouchesRequired = 1;
    UIView *view1 = [_alert getShadowView];
    [view1 addGestureRecognizer:tap1];
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
//  became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    UIView *view1 = [_alert getView];
    [UIView animateWithDuration:0.1 animations:^{
        CGRect r = view1.frame;
        r.origin.y = r.origin.y - 70;
        view1.frame =  r;
    }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        UIView *view1 = [_alert getView];
        CGRect r = view1.frame;
        r.origin.y = r.origin.y +70;
        view1.frame =  r;
    }];
    return YES;
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;
  [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                        delay:0.f
                      options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                   animations:^
   {
     CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
     CGFloat keyboardHeight = keyboardFrame.size.height;

     CGRect frame = _contentTextView.frame;
       
       frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight - kVerticalMargin - kToolbarHeight,
     _contentTextView.frame = frame;
   }               completion:NULL];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
  NSDictionary *userInfo = notification.userInfo;
  [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                        delay:0.f
                      options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                   animations:^
   {
     CGRect frame = _contentTextView.frame;
       frame.size.height = KDeviceHeight -kVoiceButtonWidth - kVerticalMargin * 2 - kViewOriginY-44;
     _contentTextView.frame = frame;
   }               completion:NULL];
}

- (void)hideKeyboard
{
  if ([_contentTextView isFirstResponder]) {
    _isEditingTitle = NO;
    [_contentTextView resignFirstResponder];
  }
    if ([_titleFiled isFirstResponder]) {
        _isEditingTitle = YES;
        [_titleFiled resignFirstResponder];
    }
    if ([encryptTxt isFirstResponder]) {
        _isEditingTitle = YES;
        [encryptTxt resignFirstResponder];
    }
    if ([encryptTxt2 isFirstResponder]) {
        _isEditingTitle = YES;
        [encryptTxt2 resignFirstResponder];
    }
}

#pragma mark - Save

- (void)save
{
  [self hideKeyboard];
  if (((_contentTextView.text == nil || _contentTextView.text.length == 0)&&  (_titleFiled.text == nil || _titleFiled.text.length == 0))) {
    return;
  }
  NSDate *createDate;
    NSString *codeStr;
  if (_note && _note.createdDate) {
    createDate = _note.createdDate;
  } else {
    createDate = [NSDate date];
  }
    if (_note && _note.encryptStr) {
        if (changeStr) {
            codeStr = changeStr2;
        }else{
        codeStr = _note.encryptStr;
        }
    }else
    {
        codeStr = encryptStr;
        if ([self isBlankString:encryptStr]) {
            codeStr = nil;
        }
    }
    
  VNNote *note = [[VNNote alloc] initWithTitle:_titleFiled.text
                                       content:_contentTextView.text
                                   createdDate:createDate
                                    updateDate:[NSDate date] encrypt:codeStr];
    
  _note = note;
  BOOL success = [note Persistence];
  if (success) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];
  } else {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SaveFail", @"")];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - More Action

- (void)moreActionButtonPressed
{
  [self hideKeyboard];
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"ActionSheetCancel", @"")
                                             destructiveButtonTitle:nil
                                   otherButtonTitles:NSLocalizedString(@"ActionSheetFont", @""),NSLocalizedString(@"ActionSheetCopy", @""),
                                NSLocalizedString(@"ActionSheetMail", @""),
                                nil];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
      //  _contentTextView.font = [UIFont systemFontOfSize:20];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        contentView.backgroundColor = [UIColor redColor];

        [KWPopoverView showPopoverAtPoint:CGPointMake(0, 0) inView:self.view withContentView:mySlider];
       
    }
  if (buttonIndex == 1) {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contentTextView.text;
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CopySuccess", @"")];
  } else if (buttonIndex == 2) {
    if ([MFMailComposeViewController canSendMail]) {
      [self sendEmail];
    } else  {
      [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CanNoteSendMail", @"")];
    }
  }
}

-(void)sliderChange:(UISlider *)slider
{
     _contentTextView.font = [UIFont systemFontOfSize:slider.value];
    NSString *str = [NSString stringWithFormat:@"%lf",slider.value];
    [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"font"];
}

#pragma mark - Eail

- (void)sendEmail
{
  MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
  [composer setMailComposeDelegate:self];
  if ([MFMailComposeViewController canSendMail]) {
    [composer setSubject:NSLocalizedString(@"来自至简笔记的一封信", nil)];
    [composer setMessageBody:_contentTextView.text isHTML:NO];
    [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:composer animated:YES completion:nil];
  } else {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"CanNoteSendMail", @"")];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  if (result == MFMailComposeResultFailed) {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendEmailFail", @"")];
  } else if (result == MFMailComposeResultSent) {
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendEmailSuccess", @"")];
  }
  [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
