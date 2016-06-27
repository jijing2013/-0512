//
//  CYYFullViewController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/18.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYFullViewController.h"

#import <AVFoundation/AVFoundation.h>
@interface CYYFullViewController ()

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation CYYFullViewController
- (instancetype)init
{
    if (self = [super init]) {
        // self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
    
}

//
//-(void)viewDidLoad{
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];

// 
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    
//    layer.frame = self.view.frame;
//    [self.view.layer addSublayer:layer];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, 50, 50);
//    button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//}
//- (void)click:(UIButton *)button{
//    [self.player play];
//}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskAll;
//}

@end
