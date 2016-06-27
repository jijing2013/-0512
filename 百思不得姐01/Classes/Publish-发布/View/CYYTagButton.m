//
//  CYYTagButton.m
//  百思不得姐01
//
//  Created by ma c on 16/5/15.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTagButton.h"

@implementation CYYTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = RGB(74, 139, 209);
        self.titleLabel.font = CYYTagFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * CYYTagMargin;
    self.height = CYYTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.x = CYYTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + CYYTagMargin;
}


@end
