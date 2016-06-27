//
//  CYYNavigationViewController.m
//  百思不得姐
//
//  Created by ma c on 16/4/7.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYNavigationViewController.h"

@interface CYYNavigationViewController ()

@end

@implementation CYYNavigationViewController

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
     [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];

    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSDictionary *itemAttr = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
   
    [item setTitleTextAttributes:itemAttr forState:UIControlStateNormal];
    
    NSDictionary *itemAttrDisabled = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    [item setTitleTextAttributes:itemAttrDisabled forState:UIControlStateDisabled];
    
}
/**
 颜色：24bit颜色：R G B
 #ff0000 红
 #00ff00 绿
 #0000ff 蓝
 #ffffff 白
 #000000 黑
 
 灰色的特点：RGB一样
 32bit颜色：A R G B
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    //第一种
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    
    //如果滑动移除控制器的功能失效，清空代理
    self.interactivePopGestureRecognizer.delegate = nil;
    
    //第二种
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:];
//    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationBar.tintColor = [UIColor blackColor];
    
}
//自定义导航栏的返回键 拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {//如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        //让按钮内部的所有东西靠左
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
   //     [button sizeToFit];
  //      button.backgroundColor = [UIColor yellowColor];
        button.size = CGSizeMake(70, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        //隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
