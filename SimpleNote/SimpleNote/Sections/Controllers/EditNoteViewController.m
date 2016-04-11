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

#define YYFont(_i_) [UIFont fontWithName:@"Avenir Next" size:_i_]

@interface EditNoteViewController ()<
YYTextViewDelegate,
YYTextKeyboardObserver,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

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
    // Do any additional setup after loading the view.
    NSLog(@"EditNoteViewController - %@",self.noteModel);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(noteSaved)];
    
    self.titleTextField.backgroundColor = [UIColor whiteColor];
    
    [self initYYTextView];
}

- (void)initYYTextView {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the season of light, it was the season of darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us. We were all going direct to heaven, we were all going direct the other way.\n\n这是最好的时代，这是最坏的时代；这是智慧的时代，这是愚蠢的时代；这是信仰的时期，这是怀疑的时期；这是光明的季节，这是黑暗的季节；这是希望之春，这是失望之冬；人们面前有着各样事物，人们面前一无所有；人们正在直登天堂，人们正在直下地狱。"];
    text.yy_font = [UIFont fontWithName:@"Avenir Next" size:self.yyFontSize];
    text.yy_lineSpacing = 4;
    text.yy_firstLineHeadIndent = 20;
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"noteData"]) {
        NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"noteData"];
        text =  [NSMutableAttributedString yy_unarchiveFromData:data];
    }
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(35, 10, 10, 10);
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

#pragma mark - YYTextViewDelegate
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    [self.titleTextField resignFirstResponder];
    NSLog(@"should.selectedRange.location:%ld",textView.selectedRange.location);
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    self.pickerImage  = photos.firstObject;
}

#pragma mark - event response

- (void)noteSaved {
    [self.view endEditing:YES];
    NSData *data = [self.textView.attributedText yy_archiveToData];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"noteData"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.noteModel.data = [self.textView.attributedText yy_archiveToData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)openCamera {
    NSLog(@"openCamera");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)openPhotos {
    NSLog(@"openPhotos");
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.navigationBar.barTintColor = SNColor(117, 106, 102);
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)increaseFont {
    self.textView.font = YYFont(++self.yyFontSize);
}

- (void)decreaseFont {
    self.textView.font = YYFont(--self.yyFontSize);
}

- (void)rotateText {
    [self.textView endEditing:YES];
    self.textView.verticalForm = !self.textView.verticalForm;
}

- (void)hideKeyBoard {
    [self.textView resignFirstResponder];
}

- (void)insertImage:(UIImage *)image {
    // 插入图片
    NSMutableAttributedString *text = [self.textView.attributedText mutableCopy];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:YYFont(18) alignment:YYTextVerticalAlignmentCenter];
    [text insertAttributedString:attachment atIndex:self.textView.selectedRange.location];
    self.textView.attributedText = text;
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getters and setters

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
