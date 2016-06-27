//
//  CYYAddTagToolBar.m
//  百思不得姐01
//
//  Created by ma c on 16/5/14.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYAddTagToolBar.h"
#import "CYYAddTagViewController.h"

@interface CYYAddTagToolBar ()

/**顶部View*/
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;

/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
@end
@implementation CYYAddTagToolBar

- (NSMutableArray *)tagLabels{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

+ (instancetype)toolBar{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    //添加一个加号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
//    addButton.size = [UIImage imageNamed:@"tag_add_icon"].size;
//    addButton.size = [addButton imageForState:UIControlStateNormal].size;
    addButton.size = addButton.currentImage.size;
    addButton.x = CYYTagMargin;
    [self addSubview:addButton];
    self.addButton = addButton;
    
    
    //默认有两个标签
    [self creatTagLabels:@[@"吐槽",@"糗事"]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];

        
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + CYYTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + CYYTagMargin;
            }
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + CYYTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + CYYTagMargin;
    }
    //整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.y -= (self.height - oldH);

}

- (void)addButtonClick{
    CYYAddTagViewController *VC = [[CYYAddTagViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [VC setTagsBlock:^(NSArray *tags) {
        [weakSelf creatTagLabels:tags];
    }];
    VC.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    //拿到当前控制器
    UINavigationController *nav = (UINavigationController *)rootVC.presentedViewController;
    
    [nav pushViewController:VC animated:YES];
}

- (void)creatTagLabels:(NSArray *)tags{
    //删除所有label
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //清空数组
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = RGB(74, 139, 209);
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = CYYTagFont;
        // 应该要先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * CYYTagMargin;
        tagLabel.height = CYYTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
        
        }
    //重新布局子控件
    
    [self setNeedsLayout];
}

@end
