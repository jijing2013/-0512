//
//  UIImageView+CYYExtension.m
//  百思不得姐01
//
//  Created by ma c on 16/5/10.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "UIImageView+CYYExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (CYYExtension)
- (void)setHeader:(NSString *)url{
    //设置头像
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholderImage;
    }];
}
@end
