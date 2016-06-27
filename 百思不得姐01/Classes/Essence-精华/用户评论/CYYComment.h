//
//  CYYComment.h
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYYUser;
@interface CYYComment : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论的文字内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;

/** 用户 */
@property (nonatomic, strong) CYYUser *user;
@end
