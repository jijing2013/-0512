//
//  CYYTagTextField.m
//  百思不得姐01
//
//  Created by ma c on 16/5/15.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTagTextField.h"

@implementation CYYTagTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // 设置了占位文字内容以后, 才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = CYYTagH;
    }
    return self;
}
- (void)deleteBackward{
    
    
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
}
@end
