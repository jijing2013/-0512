//
//  CYYPostWordViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/12.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYPostWordViewController.h"
#import "CYYPlaceholderTextView.h"
#import "CYYAddTagToolBar.h"

@interface CYYPostWordViewController ()<UITextViewDelegate>

/** 文本输入控件 */
@property (nonatomic, weak) CYYPlaceholderTextView *textView;
/** 工具条 */
@property (nonatomic, weak) CYYAddTagToolBar *toolbar;
@end

@implementation CYYPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupTextView];

    [self setupToolBar];
}

- (void)setupToolBar{
    CYYAddTagToolBar *toolBar = [CYYAddTagToolBar toolBar];
    
    toolBar.width = self.view.width;
    toolBar.y = self.view.height - toolBar.height;
    
    [self.view addSubview:toolBar];
    self.toolbar = toolBar;
    //添加通知，监听键盘变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}


- (void)setupNav{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认不能点击
    //强制刷新
    
    [self.navigationController.navigationBar layoutIfNeeded];
}
- (void)setupTextView{

    CYYPlaceholderTextView *textView = [[CYYPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;

    [textView becomeFirstResponder];
    textView.delegate = self;
    textView.placeholder = @"把好玩的图片，好笑的段子或糗事发到这里，接受千万网友膜拜吧！发布违反国家法律内容的，我们将依法提交给有关部门处理。";
    
    [self.view addSubview:textView];
    self.textView = textView;
    
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)post{
    NSLog(@"发表");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘监听 methods
- (void)keyboardWillChangeFrame:(NSNotification *)note{
    //键盘最终的frame
    CGRect keyBoardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, keyBoardF.origin.y - SCREEN_HEIGHT);
    }];
}
#pragma mark - UITextViewDelegate methods
- (void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}
@end
