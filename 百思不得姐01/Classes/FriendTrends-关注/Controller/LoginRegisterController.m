//
//  LoginRegisterController.m
//  百思不得姐01
//
//  Created by ma c on 16/4/14.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "LoginRegisterController.h"

@interface LoginRegisterController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *passFiled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation LoginRegisterController
- (IBAction)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor grayColor]};
    
    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dict];
    
    self.phoneFiled.attributedPlaceholder = placeholder;
    
    NSAttributedString *pass = [[NSAttributedString alloc] initWithString:@"密码" attributes:dict];
    
    self.passFiled.attributedPlaceholder = pass;
    //设置光标颜色
    self.phoneFiled.tintColor = [UIColor whiteColor];
    self.passFiled.tintColor = [UIColor whiteColor];
    //设置圆角
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    
    [self.view insertSubview:self.bgView atIndex:0];
}
- (IBAction)showLoginRegister:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) {
        self.loginViewLeftMargin.constant = - self.view.width;
        button.selected = YES;
//        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else{
        
        self.loginViewLeftMargin.constant = 0;
        button.selected = NO;
//        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前控制器对应的状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
