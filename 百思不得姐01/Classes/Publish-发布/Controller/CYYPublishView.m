//
//  CYYPublishView.m
//  百思不得姐01
//
//  Created by ma c on 16/5/2.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYPublishView.h"
#import "CYYVerticalButton.h"
#import "POP.h"
#import "CYYPostWordViewController.h"
#import "CYYNavigationViewController.h"


#define CYYRootView [UIApplication sharedApplication].keyWindow.rootViewController.view
static CGFloat const CYYAnimationDelay = 0.05;
@interface CYYPublishView ()

@end

@implementation CYYPublishView

+ (instancetype)publishView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    
    //动画下降过程中不能点击
    self.userInteractionEnabled = NO;
    CYYRootView.userInteractionEnabled = NO;
    
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    //中间的按钮
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 50;
    CGFloat buttonStartY = (SCREEN_HEIGHT - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    int maxCols = 3;
    CGFloat xMargin = (SCREEN_WIDTH - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    for (NSInteger i = 0; i < images.count; i++) {
        CYYVerticalButton *button = [[CYYVerticalButton alloc] init];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        
        //计算XY
        NSInteger row = i / maxCols;
        NSInteger col = i % maxCols;
//        button.x = buttonStartX + col * (buttonW + xMargin);
//        button.y = buttonStartY + row * buttonH;
        CGFloat buttonX = buttonStartX + col * (buttonW + xMargin);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - SCREEN_HEIGHT;
        [self addSubview:button];
        
        
        //添加按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = 8;
        anim.springSpeed = 5;
        anim.beginTime = CACurrentMediaTime() + CYYAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
    }
    
    //添加标语
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview:sloganView];
    //添加标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = SCREEN_WIDTH * 0.5;
    CGFloat centerEndY = SCREEN_HEIGHT * 0.2;
    CGFloat centerBeginY = centerEndY - SCREEN_HEIGHT;
    
    sloganView.centerX = centerX;
    sloganView.centerY = centerBeginY;
    
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.springBounciness = 8;
    anim.springSpeed = 5;
    anim.beginTime = CACurrentMediaTime() + images.count * CYYAnimationDelay;
    //回复点击事件
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        self.userInteractionEnabled = YES;
        CYYRootView.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
    
}


#pragma mark - click methods
/**
 动画执行完在执行block
 */
- (void)cancelWithCompletionBlock:(void (^)())completionBlock{
    //让控制器不能点击
    self.userInteractionEnabled = NO;
    CYYRootView.userInteractionEnabled = NO;
    int beginIndex = 1;
    
    for (NSInteger i = beginIndex; i < self.subviews.count; i++) {
        UIView *subView = self.subviews[i];
        
        //基本动画
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subView.centerY + SCREEN_HEIGHT;
        //动画的执行节奏
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subView.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * CYYAnimationDelay;
        [subView pop_addAnimation:anim forKey:nil];
        
        //监听最后一个动画
        if (i == self.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                CYYRootView.userInteractionEnabled = YES;
                [self removeFromSuperview];
                
                //执行传进来的completionBlock参数
//                if (completionBlock) {
//                    completionBlock();
//                }
                !completionBlock ? :completionBlock();
            }];
        }
    }
}
- (void)buttonClick:(UIButton *)button{
    [self cancelWithCompletionBlock:^{
        if (button.tag == 2) {
            CYYPostWordViewController *postWord = [[CYYPostWordViewController alloc] init];
            CYYNavigationViewController *nav = [[CYYNavigationViewController alloc] initWithRootViewController:postWord];
            
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
        }
    }];
    

    
}
- (IBAction)cancel:(id)sender {

    [self cancelWithCompletionBlock:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}

@end
