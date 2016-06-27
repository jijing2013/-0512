//
//  UIImage+CYYExtension.m
//  百思不得姐01
//
//  Created by ma c on 16/5/10.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "UIImage+CYYExtension.h"

@implementation UIImage (CYYExtension)
- (UIImage *)circleImage{
    //no 代表不透明 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //获得图形上下文
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    //将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
