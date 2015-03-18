//
//  NoteDetailController.m
//  Voice2Note
//
//  Created by liaojinxing on 14-6-11.
//  Copyright (c) 2014年 jinxing. All rights reserved.
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

  UIBarButtonItem *voiceBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_more_white@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(changeColor)];
  voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;

  UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kToolbarHeight)];
    UIBarButtonItem *itemLine = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  toolbar.tintColor = [UIColor systemColor];
  toolbar.items = [NSArray arrayWithObjects:itemLine,voiceBarButton, itemLine,doneBarButton,itemLine, nil];

    //标题
    _titleFiled = [[UITextField alloc]initWithFrame:CGRectMake(kHorizontalMargin, 70, kDeviceWidth - kHorizontalMargin * 2, 44)];
    _titleFiled.borderStyle     = UITextBorderStyleRoundedRect;
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 45.0f, 44.0f)];
    leftView.text   = @"标题:";
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
        _encryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_encryptButton setFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
        [_encryptButton setTitle:@"修改密码" forState:UIControlStateNormal];
        [_encryptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _encryptButton.layer.cornerRadius = kVoiceButtonWidth / 2;
        _encryptButton.layer.masksToBounds = YES;
        [_encryptButton setBackgroundColor:[UIColor systemColor]];
        [_encryptButton addTarget:self action:@selector(changeCode) forControlEvents:UIControlEventTouchUpInside];
        [_encryptButton setTintColor:[UIColor whiteColor]];
        [self.view addSubview:_encryptButton];
    }
    else
    {
        _encryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_encryptButton setFrame:CGRectMake((self.view.frame.size.width - kVoiceButtonWidth) / 2, self.view.frame.size.height - kVoiceButtonWidth - kVerticalMargin, kVoiceButtonWidth, kVoiceButtonWidth)];
        [_encryptButton setTitle:NSLocalizedString(@"EncryptInput", @"") forState:UIControlStateNormal];
        [_encryptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _encryptButton.layer.cornerRadius = kVoiceButtonWidth / 2;
        _encryptButton.layer.masksToBounds = YES;
        [_encryptButton setBackgroundColor:[UIColor systemColor]];
        [_encryptButton addTarget:self action:@selector(encryptInput) forControlEvents:UIControlEventTouchUpInside];
        [_encryptButton setTintColor:[UIColor whiteColor]];
        [self.view addSubview:_encryptButton];
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
   
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    encryptTxt = [alert addTextField:@"输入旧密码"];
    encryptTxt.delegate = self;
    encryptTxt.secureTextEntry = YES;
    encryptTxt2 = [alert addTextField:@"输入新密码"];
    encryptTxt2.delegate = self;
    encryptTxt2.secureTextEntry = YES;
    [alert addButton:@"确定" actionBlock:^(void) {
        
        if ([encryptTxt.text isEqualToString:_note.encryptStr] )
        {
            if ([self isBlankString:encryptTxt2.text]) {
                changeStr = encryptTxt.text;
                changeStr2 = nil;
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showSuccess:self title:@"成功" subTitle:@"解密成功" closeButtonTitle:@"确定" duration:0.0f];
            }else{
            changeStr = encryptTxt2.text;
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showSuccess:self title:@"成功" subTitle:@"加密成功" closeButtonTitle:@"确定" duration:0.0f];
            }
        }else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"失败" subTitle:@"旧密码输入错误" closeButtonTitle:@"确定" duration:0.0f];
        }
    }];
    [alert showSuccess:self title:@"至简加密" subTitle:@"请输入新旧密码" closeButtonTitle:nil duration:0.0f];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [encryptTxt resignFirstResponder];
     [encryptTxt2 resignFirstResponder];
}
-(void)encryptInput
{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    encryptTxt = [alert addTextField:@"输入密码"];
    encryptTxt.delegate = self;
    encryptTxt.secureTextEntry = YES;
    
    encryptTxt2 = [alert addTextField:@"再次输入"];
    encryptTxt2.delegate = self;
    encryptTxt2.secureTextEntry = YES;
    [alert addButton:@"确定" actionBlock:^(void) {
       
        if ([encryptTxt.text isEqualToString:encryptTxt2.text] && ![self isBlankString:encryptTxt.text])
        {
            encryptStr = encryptTxt.text;
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showSuccess:self title:@"成功" subTitle:@"加密成功" closeButtonTitle:@"确定" duration:0.0f];
        }else
        {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showWarning:self title:@"失败" subTitle:@"两次输入密码不一致" closeButtonTitle:@"确定" duration:0.0f];
        }
    }];
    [alert showSuccess:self title:@"至简加密" subTitle:@"请输入加密密码" closeButtonTitle:nil duration:0.0f];
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
       
       frame.size.height = KDeviceHeight   - keyboardHeight;
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
    } else {
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
    [composer setSubject:@"来自至简笔记的一封信"];
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
