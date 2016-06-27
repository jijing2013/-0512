//
//  FriendTrendsViewController.m
//  百思不得姐
//
//  Created by ma c on 16/4/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "FriendTrendsViewController.h"
#import "CYYRecommendViewController.h"
#import "LoginRegisterController.h"

@interface FriendTrendsViewController ()


@end

@implementation FriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏内容
    self.navigationItem.title = @"我的关注";
    
    /**
     *  前一句效果等同于后两句
     */
//    self.title = @"我的关注";
//    self.navigationItem.title = @"我的关注";
//    self.tabBarItem.title = @"我的关注";
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" hightImage:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];

    self.view.backgroundColor = RGB(223, 223, 223);
    
}

- (void)friendClick{
    CYYRecommendViewController *vc = [[CYYRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginRegister:(id)sender {
    
    LoginRegisterController *login = [[LoginRegisterController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}



@end
