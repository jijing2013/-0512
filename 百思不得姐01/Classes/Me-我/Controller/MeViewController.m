//
//  MeViewController.m
//  百思不得姐
//
//  Created by ma c on 16/4/5.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "MeViewController.h"
#import "CYYMeCell.h"
#import "CYYMeFooterView.h"
#import "CYYSettingTableViewController.h"


static NSString *CYYMeID = @"me";
@interface MeViewController ()<UITableViewDataSource>

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //设置导航栏左边按钮
//    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
//    [settingButton setBackgroundImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
//    settingButton.size = settingButton.currentBackgroundImage.size;
//    [settingButton addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *nightMoonButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [nightMoonButton setBackgroundImage:[UIImage imageNamed:@"mine-sun-icon"] forState:UIControlStateNormal];
//    [nightMoonButton setBackgroundImage:[UIImage imageNamed:@"mine-sun-icon-click"] forState:UIControlStateHighlighted];
//    nightMoonButton.size = nightMoonButton.currentBackgroundImage.size;
//    [nightMoonButton addTarget:self action:@selector(nightModeClick) forControlEvents:UIControlEventTouchUpInside];
    [self setupNavigation];
    [self setupTableView];

}
- (void)setupTableView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //注册
    [self.tableView registerClass:[CYYMeCell class] forCellReuseIdentifier:CYYMeID];
   
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    self.tableView.sectionHeaderHeight = 0;
    
    // 设置footerView
    self.tableView.tableFooterView = [[CYYMeFooterView alloc] init];
    

}

- (void)setupNavigation{
    //设置导航栏内容
    self.navigationItem.title = @"我的关注";
    UIBarButtonItem *settingitem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" hightImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)]; ;
    UIBarButtonItem *nightMoonitem = [UIBarButtonItem itemWithImage:@"mine-sun-icon" hightImage:@"mine-sun-icon-click" target:self action:@selector(nightModeClick)];
    

    self.navigationItem.rightBarButtonItems = @[settingitem, nightMoonitem];
    self.view.backgroundColor = RGB(223, 223, 223);
}
- (void)settingClick{
    
    [self.navigationController pushViewController:[[CYYSettingTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    
}
- (void)nightModeClick{
    CYYLog(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource> methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYYMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CYYMeID];
   
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登陆/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

@end
