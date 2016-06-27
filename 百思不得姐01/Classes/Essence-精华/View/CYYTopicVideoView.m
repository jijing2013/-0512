//
//  CYYTopicVideoView.m
//  百思不得姐01
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopicVideoView.h"
#import "UIImageView+WebCache.h"
#import "CYYTopic.h"
#import "CYYShowPictureController.h"
#import "CYYFullViewController.h"



@interface CYYTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;

@property (weak, nonatomic) IBOutlet UIView *ToolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

/** 播放器*/
@property (nonatomic, strong) AVPlayer *player;
// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

/* 记录当前是否显示了工具栏*/
@property (assign, nonatomic) BOOL isShowToolView;
/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;


@end
@implementation CYYTopicVideoView

+ (instancetype)videoView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    

    
    //设置toolView
    self.ToolView.alpha = 0;
    self.isShowToolView = NO;
    //设置进度条
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    //给图片添加监听事件
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
    
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    
}
//设置数据
- (void)setTopic:(CYYTopic *)topic{
    _topic = topic;
    //加载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    //时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second =  topic.videotime % 60;
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute, second];
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
 //   [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player play];
}


#pragma mark - 响应事件


// 是否显示工具的View
- (IBAction)playButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.playButton.hidden = YES;
   
        [self.player play];
        [self addProgressTimer];
        
    }else{
        self.playButton.hidden = NO;
        [self.player pause];
        [self removeProgressTimer];
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.ToolView.alpha = 0;//隐藏
            self.isShowToolView = NO;
        } else {
            self.ToolView.alpha = 1;
            self.isShowToolView = YES;
        }
    }];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];

    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    
}
//暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.playButton.hidden = YES;
        self.ToolView.hidden = NO;
        [self.player play];
        [self addProgressTimer];
    } else {
        self.playButton.hidden = NO;
        [self.player pause];
        [self removeProgressTimer];
    }
}

- (IBAction)switchOrientation:(UIButton *)sender {
    CYYFullViewController *fullVC = [[CYYFullViewController alloc] init];
    fullVC.url = self.topic.videouri;
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:fullVC animated:YES completion:nil];
//    [root presentViewController:fullVC animated:YES completion:^{
//        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.topic.videouri]];
//        
//        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//        self.playerLayer.frame = fullVC.view.frame;
//        [fullVC.view.layer addSublayer:self.playerLayer];
//    }];
//   
}
- (IBAction)slider:(id)sender {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
    
}


- (IBAction)startSlider:(id)sender {
    [self removeProgressTimer];
}
- (IBAction)sliderValueChange:(id)sender {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

- (void)suspendPlayVideo {
    
    
    self.playOrPauseBtn.selected = NO;
    self.ToolView.alpha = 1;
    self.isShowToolView = YES;
    
    [self.player pause];
    
    [self removeProgressTimer];
}

- (void)showPicture{
    
    [self.player pause];
    self.playButton.hidden = NO;
    
  //  self.ToolView.hidden = YES;
//    CYYShowPictureController *showPicture = [[CYYShowPictureController alloc] init];
//    showPicture.topic = self.topic;
//    //拿到根控制器
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}



//设置时间
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    dMin = dMin<0?0:dMin;
    dSec = dSec<0?0:dSec;
    cMin = cMin<0?0:cMin;
    cSec = cSec<0?0:cSec;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}


- (void)updateProgressInfo
{
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}
- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}



-(void)resetPlayView {
    [self suspendPlayVideo];
    
    [self.playerLayer removeFromSuperlayer];
    // 替换PlayerItem为nil
    [self.player replaceCurrentItemWithPlayerItem:nil];
    // 把player置为nil
    self.player = nil;
    
    [self removeFromSuperview];
    
    
}
//释放KVO
-(void)dealloc {
 //   [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
@end
