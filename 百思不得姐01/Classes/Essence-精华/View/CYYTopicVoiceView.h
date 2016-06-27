//
//  CYYTopicVoiceView.h
//  百思不得姐01
//
//  Created by ma c on 16/5/3.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@class CYYTopic;
@interface CYYTopicVoiceView : UIView

+ (instancetype)voiceView;
/**帖子数据*/
@property (nonatomic, strong) CYYTopic *topic;
@end
