//
//  EssenceViewController.m
//  百思不得姐
//
//  Created by ma c on 16/4/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "EssenceViewController.h"
#import "CYYRecommendTagsTableViewController.h"
#import "CYYAllViewController.h"
#import "CYYVideoViewController.h"
#import "CYYVoiceViewController.h"
#import "CYYPictureViewController.h"
#import "CYYWordViewController.h"

@interface EssenceViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *indicatorView;
//选中的button
@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIScrollView *contentView;

@end

@implementation EssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航栏
    [self setupNav];
    
    //初始化子控制器
    [self setupChildVces];
    
    //设置顶部标签栏
    [self setupTitleView];
    
    //底部的scrollView
    [self setupContentView];
    

    
}


/**
 *  初始化子控制器
 */
- (void)setupChildVces{
    CYYAllViewController *all = [[CYYAllViewController alloc] init];
    [self addChildViewController:all];
    
    CYYVideoViewController *video = [[CYYVideoViewController alloc] init];
    [self addChildViewController:video];
    
    CYYVoiceViewController *voice = [[CYYVoiceViewController alloc] init];
    [self addChildViewController:voice];
    
    CYYPictureViewController *picture = [[CYYPictureViewController alloc] init];
    [self addChildViewController:picture];
    
    CYYWordViewController *word = [[CYYWordViewController alloc] init];
    [self addChildViewController:word];
}

- (void)setupNav{
    //设置导航栏内容
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.view.backgroundColor = RGB(223, 223, 223);
}
//设置内容view
- (void)setupContentView{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //添加第一个控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

//设置顶部标签栏
- (void)setupTitleView{
    //标签栏整体
    UIView *titleView = [[UIView alloc] init];
//    titleView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleView.width = self.view.width;
    titleView.height = CYYTitlesViewH;
    titleView.y = CYYTitlesViewY;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titleView.height - indicatorView.height;

    self.indicatorView = indicatorView;
    
    //内部的子标签
    NSArray *titleName = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    
    CGFloat width = titleView.width / titleName.count;
    CGFloat height = titleView.height;
    for (NSInteger i = 0; i < titleName.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button .height = height;
        button.width = width;
        button.x = i * button.width;
        [button setTitle:titleName[i] forState:UIControlStateNormal];
        //强制布局（强制更新子控件的frame）
        [button layoutIfNeeded];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        //不能被点击UIControlStateDisabled
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
       
        //默认点击第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            //根据文字内容计算宽度
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    
    }
        [titleView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button{
    //修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    //动画
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}
- (void)tagClick{
    
    CYYRecommendTagsTableViewController *tags = [[CYYRecommendTagsTableViewController alloc] init];
    [self.navigationController pushViewController:tags animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    //当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    //取出子控制器
    UIViewController *VC = self.childViewControllers[index];
    VC.view.x = scrollView.contentOffset.x;
    VC.view.y = 0;// 设置控制器view的y值为0(默认是20)
    VC.view.height = scrollView.height;// 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)

    [scrollView addSubview:VC.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
