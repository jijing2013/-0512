//
//  CYYPushGuideView.m
//  百思不得姐01
//
//  Created by ma c on 16/4/17.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYPushGuideView.h"

@implementation CYYPushGuideView

+  (void)show{
    NSString *key = @"CFBundleShortVersionString";
    //当前版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    //以前版本号
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (![currentVersion isEqualToString:sanboxVersion]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        CYYPushGuideView *guide = [CYYPushGuideView guideView];
        guide.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [window addSubview:guide];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

+ (instancetype)guideView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


- (IBAction)close:(id)sender {
    [self removeFromSuperview];
    
}

@end
