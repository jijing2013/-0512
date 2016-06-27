//
//  CYYTopicVideoView.h
//  百思不得姐01
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class CYYTopic;
//设置协议
@protocol VideoPlayViewDelegate <NSObject>



@end

@interface CYYTopicVideoView : UIView

+ (instancetype)videoView;
@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;

@property (nonatomic, strong) AVPlayerItem *playerItem;

-(void)suspendPlayVideo;

-(void)resetPlayView;



/**帖子数据*/
@property (nonatomic, strong) CYYTopic *topic;
@end
