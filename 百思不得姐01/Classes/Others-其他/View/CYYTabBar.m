//
//  CYYTabBar.m
//  百思不得姐
//
//  Created by ma c on 16/4/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTabBar.h"
#import "CYYPublishView.h"

@interface CYYTabBar()

@property (nonatomic, weak) UIButton *publishButton;
@end
@implementation CYYTabBar


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        //添加一个发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        
        //添加发布事件
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        //设置完图片就可以设置尺寸
        publishButton.size = publishButton.currentBackgroundImage.size;
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
#pragma mark- 发布按钮
- (void)publishClick{
    
    CYYPublishView *publish = [CYYPublishView publishView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    publish.frame = window.bounds;
    [window addSubview:publish];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    //设置发布按钮的frame
//    self.publishButton.width = self.publishButton.currentBackgroundImage.size.width;
//    self.publishButton.height = self.publishButton.currentBackgroundImage.size.height;

    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
   //设置其他按钮的frame
    
    CGFloat buttonY = 0;
    CGFloat buttonW = width / 5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    for (UIButton *button in self.subviews) {
        if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        //计算按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1) : index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
        
        if (added == NO) {
            //监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
       
    }

    added = YES;
}

- (void)buttonClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:CYYTabBarDidSelectNotification object:nil userInfo:nil];
}
@end
