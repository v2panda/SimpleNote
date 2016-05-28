//
//  EditNoteViewController.m
//  SimpleNote
//
//  Created by v2panda on 16/4/7.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import "EditNoteViewController.h"
#import "YYText.h"
#import "TZImagePickerController.h"
#import "SNRealmHelper.h"
#import <IQKeyboardManager.h>
#define YYFont(_i_) [UIFont fontWithName:@"Avenir Next" size:_i_]

@interface EditNoteViewController ()<
YYTextViewDelegate,
YYTextKeyboardObserver,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate>

@property (nonatomic, assign) YYTextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, assign) NSInteger yyFontSize;
@property (nonatomic, strong) UIImage *pickerImage;

@end

@implementation EditNoteViewController

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(noteSaved)];
    [self initYYTextView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}

- (void)initYYTextView {

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
    text.yy_font = YYFont(self.yyFontSize);
    text.yy_lineSpacing = 4;
    text.yy_firstLineHeadIndent = 20;
    
    YYTextView *textView = [YYTextView new];
    
    if (self.noteModel.data) {
        text = [NSMutableAttributedString yy_unarchiveFromData:self.noteModel.data];
    }else {
        textView.font = YYFont(self.yyFontSize);
    }
    self.titleTextField.text = self.noteModel.noteTitle;
    
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(45, 10, 10, 10);
    textView.delegate = self;
    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    textView.inputAccessoryView = self.toolBar;
    
    [self.view insertSubview:textView belowSubview:self.titleTextField];
    self.textView = textView;
    [[YYTextKeyboardManager defaultManager] addObserver:self];
}
- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 30) {
        kTipAlert(@"标题长度不能超过30个字符");
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.pickerImage  = photos.firstObject;
}

#pragma mark - event response

- (void)noteSaved {
    [self.view endEditing:YES];
    
    [SNRealmHelper updateDataInRealm:^{
        self.noteModel.data = [self.textView.attributedText yy_archiveToData];
        self.noteModel.noteTitle = self.titleTextField.text;
        if (self.pickerImage) {
            self.noteModel.noteThumbnailData = UIImagePNGRepresentation(self.pickerImage);
        }
    }];
    
    if (![[SNRealmHelper readAllNotesFromNotebook] containsObject:self.noteModel]) {
        [SNRealmHelper addNewNote:self.noteModel];
    }
    
    [self.delegate reloadNotes];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openCamera {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)openPhotos {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = SNColor(117, 106, 102);
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)increaseFont {
    NSMutableAttributedString *text = [self.textView.attributedText mutableCopy];
    self.yyFontSize = text.yy_font.pointSize;
    text.yy_font = YYFont(++self.yyFontSize);
    self.textView.attributedText = text;
}

- (void)decreaseFont {
    NSMutableAttributedString *text = [self.textView.attributedText mutableCopy];
    self.yyFontSize = text.yy_font.pointSize;
    text.yy_font = YYFont(--self.yyFontSize);
    self.textView.attributedText = text;
}

- (void)rotateText {
    [self.textView endEditing:YES];
    self.textView.verticalForm = !self.textView.verticalForm;
}

- (void)hideKeyBoard {
    [self.textView resignFirstResponder];
}

- (void)insertImage:(UIImage *)image {
    NSMutableAttributedString *text = [self.textView.attributedText mutableCopy];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:YYFont(18) alignment:YYTextVerticalAlignmentCenter];
    [text insertAttributedString:attachment atIndex:self.textView.selectedRange.location];
    self.textView.attributedText = text;
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        self.pickerImage = image;
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters

- (NoteModel *)noteModel {
    if (!_noteModel) {
        _noteModel = [NoteModel new];
        _noteModel.owner = [SNRealmHelper getNowNoteBook];
        _noteModel.noteTitle = @"默认笔记";
        _noteModel.noteCreateDate = [NSDate date];
    }
    return _noteModel;
}

- (void)setPickerImage:(UIImage *)pickerImage {
    if (pickerImage) {
        if (pickerImage.size.width > self.view.width && pickerImage.size.height > self.view.height) {
            pickerImage = [pickerImage imageByScalingAndCroppingForSize:CGSizeMake(self.view.width - 20, self.view.height - 100)];
        }else if (pickerImage.size.width > self.view.width || pickerImage.size.height > self.view.height) {
            pickerImage = [pickerImage imageByResizeToSize:CGSizeMake(200, 200)];
        }
        [self insertImage:pickerImage];
    }
    _pickerImage = pickerImage;
}

- (NSInteger)yyFontSize {
    if (!_yyFontSize) {
        _yyFontSize = 18;
    }else if (_yyFontSize) {
        if (_yyFontSize > 26) {
            _yyFontSize = 26;
        }else if (_yyFontSize < 12) {
            _yyFontSize = 12;
        }
    }
    return _yyFontSize;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc]init];
        [_toolBar setSize:CGSizeMake(self.view.width, 40)];
        [_toolBar setBarStyle:UIBarStyleDefault];
        _toolBar.translucent = YES;
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:NULL];
        fixedItem.width = 30;
        UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"CompactCameraFilled"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(openCamera)];
        UIBarButtonItem *photoItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"CameraPhoto"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(openPhotos)];
        UIBarButtonItem *increaseItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"IncreaseFont"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(increaseFont)];
        UIBarButtonItem *decreaseItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"DecreaseFont"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(decreaseFont)];
        UIBarButtonItem *rotateItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Rotate to Landscape Filled"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(rotateText)];
        
        UIBarButtonItem *hideItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Expand Arrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyBoard)];
        
        [_toolBar setItems:[NSArray arrayWithObjects:increaseItem,fixedItem,decreaseItem,fixedItem,rotateItem,fixedItem,cameraItem,fixedItem,photoItem,flexibleItem,hideItem, nil] animated:YES];
    }
    return _toolBar;
}

@end
