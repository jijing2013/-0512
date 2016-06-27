//
//  CYYTopicVoiceView.m
//  百思不得姐01
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopicVoiceView.h"
#import "CYYTopic.h"
#import "UIImageView+WebCache.h"
#import "CYYShowPictureController.h"

@interface CYYTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

/**播放器 */
@property (nonatomic, strong) AVPlayer *player;
/**播放器的layer*/
@property (nonatomic, strong) AVPlayerItem * playerItem;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;
@end
@implementation CYYTopicVoiceView



+ (instancetype)voiceView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    
    self.autoresizingMask = UIViewAutoresizingNone;
    //给图片添加监听事件
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
    
    
}

- (void)setTopic:(CYYTopic *)topic{
    _topic = topic;
    
    //加载图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    //播放次数
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
//    //时长
//    NSInteger minute = topic.voicetime / 60;
//    NSInteger second =  topic.voicetime% 60;
//    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute, second];
    
}


- (AVPlayer *)player{
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        NSURL *url = [NSURL URLWithString:self.topic.voiceuri];
        self.playerItem = [AVPlayerItem playerItemWithURL:url];
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}
#pragma mark - 图片响应事件
- (IBAction)playVoice:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        self.playButton.hidden = YES;
        [self addProgressTimer];
    }else{
        [self.player pause];
        self.playButton.hidden = NO;
        [self removeProgressTimer];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
    }];
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
    self.voicetimeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}


- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)updateProgressInfo
{
    // 1.更新时间
    self.voicetimeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
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

- (NSString *)timeString
{
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime duration:duration];
}


- (void)showPicture{
    
    [self.player pause];
    self.playButton.hidden = NO;
//    CYYShowPictureController *showPicture = [[CYYShowPictureController alloc] init];
//    showPicture.topic = self.topic;
//    //拿到根控制器
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}



@end
