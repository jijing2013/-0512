//
//  CYYTopicCell.m
//  百思不得姐01
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopicCell.h"
#import "UIImageView+WebCache.h"
#import "CYYTopicPictureView.h"
#import "UIImageView+WebCache.h"
#import "CYYTopicVoiceView.h"
#import "CYYTopicVideoView.h"

#import "CYYComment.h"
#import "CYYUser.h"

@interface CYYTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
/** 分享 */
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
/** 新浪加v*/
@property (weak, nonatomic) IBOutlet UIImageView *sinaVView;
/**帖子内容*/
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/**图片帖子中间的内容*/
@property (nonatomic, weak) CYYTopicPictureView *picureView;
/**声音帖子中间的内容*/
@property (nonatomic, weak) CYYTopicVoiceView *voiceView;
/**视频帖子中间的内容*/
@property (nonatomic, weak) CYYTopicVideoView *videoView;

/** 最热评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/** 最热评论整体*/
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@end


@implementation CYYTopicCell

+ (instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (CYYTopicPictureView *)picureView{
    if (!_picureView) {
        CYYTopicPictureView *picureView = [CYYTopicPictureView pictureView];
        [self.contentView addSubview:picureView];
        _picureView = picureView;
    }
    return _picureView;
}
- (CYYTopicVoiceView *)voiceView{
    if (!_voiceView){
        CYYTopicVoiceView *voiceView = [CYYTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (CYYTopicVideoView *)videoView{
    if (!_videoView) {
        CYYTopicVideoView *videoView = [CYYTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (void)setTopic:(CYYTopic *)topic{
    _topic = topic;
    
    //新浪加v
    self.sinaVView.hidden = !topic.isSina_V;
    
    //设置头像
    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage] ;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:topic. profile_image] placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.profileImageView.image = image ? [image circleImage] : placeholderImage;
    }];
    
   
    self.nameLabel.text = topic.name;
    self.createTimeLabel.text = topic.create_time;
    
    // 设置按钮文字
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    //帖子文字内容
    self.text_label.text = topic.text;
    //根据帖子类型添加内容 （要注意呢循环引用的问题）
    if (topic.type == 10) {//图片帖子
        self.picureView.hidden = NO;
        self.picureView.topic = topic;
        self.picureView.frame = topic.pictureF;
        
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == 31){//音频帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        
        self.picureView.hidden = YES;
        self.videoView.hidden = YES;
    }else if (topic.type == 41){//视频帖子
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        
        self.picureView.hidden = YES;
        self.voiceView.hidden = YES;
    }else{//段子帖子
        self.picureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }
    
    //处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",topic.top_cmt.user.username,topic.top_cmt.content];
    }else{
        self.topCmtView.hidden = YES;
    }
    
}

//设置时间
//- (void)testDate:(NSString *)create_time
//{
//    // 当前时间
//    NSDate *now = [NSDate date];
//
//    // 发帖时间
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSDate *create = [fmt dateFromString:create_time];
//    NSTimeInterval delta = [now timeIntervalSinceDate:create];
//}

- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder
{
    //    NSString *title = nil;
    //    if (count == 0) {
    //        title = placeholder;
    //    } else if (count > 10000) {
    //        title = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    //    } else {
    //        title = [NSString stringWithFormat:@"%zd", count];
    //    }
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}
- (void)setFrame:(CGRect)frame
{
    static CGFloat margin = 10;
    
//    frame.origin.x = margin;
//    frame.size.width -= 2 * margin;
//    frame.size.height -= margin;
    frame.size.height = self.topic.cellHeight - margin;
    frame.origin.y += margin;
    
    [super setFrame:frame];
}
- (IBAction)more:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alert3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:alert1];
    [alertController addAction:alert2];
    [alertController addAction:alert3];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
