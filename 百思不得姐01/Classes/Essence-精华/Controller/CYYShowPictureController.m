//
//  CYYShowPictureController.m
//  百思不得姐01
//
//  Created by ma c on 16/5/1.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYShowPictureController.h"
#import "UIImageView+WebCache.h"
#import "CYYTopic.h"
#import "SVProgressHUD.h"
#import "DALabeledCircularProgressView.h"

@interface CYYShowPictureController ()
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end

@implementation CYYShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加图片
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
    //图片尺寸
    CGFloat pictureW = SCREEN_WIDTH;
    CGFloat pictureH = pictureW * self.topic.height / self.topic.width;
    if (pictureH > SCREEN_HEIGHT) {
        self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else {
        self.imageView.size = CGSizeMake(pictureW, pictureH);
        self.imageView.centerY = SCREEN_HEIGHT * 0.5;
    }
    
    //马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    //显示图片
     [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         self.progressView.hidden = NO;
         [self.progressView setProgress:1.0 * receivedSize / expectedSize animated:NO];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         self.progressView.hidden = YES;
     }];
}
#pragma mark- 点击事件
- (IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    //将图片写入相册  
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
       [SVProgressHUD showSuccessWithStatus:@"保存失败"];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
}
- (IBAction)share:(id)sender {
}
@end
