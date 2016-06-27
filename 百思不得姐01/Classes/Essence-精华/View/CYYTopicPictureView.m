//
//  CYYTopicPictureView.m
//  百思不得姐01
//
//  Created by ma c on 16/4/30.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopicPictureView.h"
#import "CYYTopic.h"
#import "UIImageView+WebCache.h"
#import "DALabeledCircularProgressView.h"
#import "CYYShowPictureController.h"


@interface CYYTopicPictureView ()
/**图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**gif标识*/
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/**查看大图按钮*/
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end
@implementation CYYTopicPictureView

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 2;
    self.progressView.progressLabel.textColor = RGB(200, 200, 200);
    
    //给图片添加监听事件
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

#pragma mark - 图片响应事件

- (void)showPicture{
    CYYShowPictureController *showPicture = [[CYYShowPictureController alloc] init];
    showPicture.topic = self.topic;
    //拿到根控制器
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
+ (instancetype)pictureView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)setTopic:(CYYTopic *)topic{
    _topic = topic;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //立马显示最新的进度值(防止因为网速慢，导致显示的是其他图片的下载进度)
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    //设置图片 进度条
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        //计算进度值
        CGFloat progress = 1.0 * receivedSize / expectedSize;
        progress = (progress < 0 ? 0 : progress);
        //显示进度值
        [self.progressView setProgress:progress animated:NO];
    
        topic.pictureProgress = progress;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress * 100];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //如果是大图片才需要绘图
        if (topic.isBigPicture == NO) return;
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        //将下载完的image对象绘制图形上下文
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        //结束上下文
        UIGraphicsEndImageContext();
        
    }];
    
    /**
     *  在不知道图片的扩展名时，通过图片的第一个字节判断图片的真正类型
     */
    
    //判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    //判断是否显示按钮
    if (topic.isBigPicture) {//大图
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }else{
        self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
}
@end
