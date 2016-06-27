//
//  CYYAddTagViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/15.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYAddTagViewController.h"
#import "CYYTagButton.h"
#import "CYYTagTextField.h"
#import <SVProgressHUD.h>

@interface CYYAddTagViewController ()<UITextFieldDelegate>
/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) CYYTagTextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation CYYAddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNav];
    [self setupContentView];
    
    [self setupTextField];
    
    [self setupTags];
}
#pragma mark - 懒加载 methods
- (NSMutableArray *)tagButtons{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton{
    if (!_addButton) {
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addButton.width = self.contentView.width;
        addButton.height = 35;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, CYYTagMargin, 0, CYYTagMargin);
        // 让按钮内部的文字和图片都左对齐
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addButton.backgroundColor = RGB(74, 139, 209);
        [self.contentView addSubview:addButton];
        _addButton = addButton;

    }
    return _addButton;
}

#pragma mark - 初始化 methods
- (void)setupTags{
    for (NSString *tag in self.tags) {
        self.textField.text = tag;
        [self addButtonClick];
    }
}
- (void)setupContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.x = CYYTagMargin;
    contentView.width = self.view.width - 2 * contentView.x;
    contentView.y = 64 + CYYTagMargin;
    contentView.height = SCREEN_HEIGHT;
    [self.view addSubview:contentView];
    self.contentView = contentView;
}
- (void)setupTextField{
    
    __weak typeof (self) weakSelf = self;
    CYYTagTextField *textField = [[CYYTagTextField alloc] init];
    textField.width = self.contentView.width;
    
    textField.delegate = self;
    
    //deleteBlock
    textField.deleteBlock = ^(){
        if (weakSelf.textField.hasText) return;
        
        [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
    };
    
    
    
    [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    
    [self.contentView addSubview:textField];
    self.textField = textField;
    
}
/**
 *  监听文字改变
 */
- (void)textDidChange{
    
    // 更新标签和文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) {//有文字
        
       //显示添加标签的按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + CYYTagMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
        //获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len  = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","] || [lastLetter isEqualToString:@"，"]) {
            
            //去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            [self addButtonClick];
        };
        
    }else{//没有文字
        //隐藏添加标签的按钮
        self.addButton.hidden = YES;
    }
    
  
}
- (void)setupNav{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}
- (void)done{

    //传递tags给这个block
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - UITextFieldDelegate methods
/**
 * 按return key键插入标签
 */
- (BOOL)textFieldShouldReturn:(CYYTagTextField *)textField{
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}
#pragma mark - 监听按钮点击 methods
- (void)addButtonClick{
    
    if (self.tagButtons.count == 5) {
        [SVProgressHUD showErrorWithStatus:@"最多添加五个标签"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    // 添加一个"标签按钮"
    CYYTagButton *tagButton = [CYYTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    tagButton.titleLabel.font = CYYTagFont;
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
//     更新标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
    // 清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
}
/**
 * 标签按钮的点击
 */
- (void)tagButtonClick:(CYYTagButton *)tagButton
{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

/**
 * 专门用来更新标签按钮的frame
 */
- (void)updateTagButtonFrame
{
    // 更新标签按钮的frame
    for (int i = 0; i<self.tagButtons.count; i++) {
        CYYTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        } else { // 其他标签按钮
           CYYTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + CYYTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + CYYTagMargin;
            }
        }
    }
    

}


- (void)updateTextFieldFrame{
    // 最后一个标签按钮
    CYYTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + CYYTagMargin;
    
    // 更新textField的frame
    if (self.contentView.width - leftWidth >= [self textFieldTextWidth]) {
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    } else {
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY(lastTagButton.frame) + CYYTagMargin;
    }
}

/**
 * textField的文字宽度
 */
- (CGFloat)textFieldTextWidth
{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
