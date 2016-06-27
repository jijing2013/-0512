//
//  CYYTopicPictureView.h
//  百思不得姐01
//
//  Created by ma c on 16/4/30.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYYTopic;
@interface CYYTopicPictureView : UIView

+(instancetype)pictureView;
/**帖子数据*/
@property (nonatomic, strong) CYYTopic *topic;
@end
