//
//  CYYTopic.h
//  百思不得姐01
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CYYComment;

@interface CYYTopic : NSObject

/** id */
@property (nonatomic, copy) NSString *ID;
/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像URL */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/** 是否为新浪加V用户 */
@property (nonatomic, assign, getter=isSina_V) BOOL isSina_V;

/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图片的URL */
@property (nonatomic, copy) NSString *small_image;
/** 中图片的URL */
@property (nonatomic, copy) NSString *middle_image;
/** 大图片的URL */
@property (nonatomic, copy) NSString *large_image;
/** 帖子的类型 */
@property (nonatomic, assign)  NSInteger type;

/** 音频时长 */
@property (nonatomic, assign)  NSInteger voicetime;
/** 视频时长*/
@property (nonatomic, assign)  NSInteger videotime;
/** 视频地址*/
@property (nonatomic, copy) NSString *videouri;

/** 播放次数 */
@property (nonatomic, assign)  NSInteger playcount;
/** 音频地址*/
@property (nonatomic, copy) NSString *voiceuri;


/** 最热评论 */
@property (nonatomic, strong) CYYComment *top_cmt;

/**** 辅助属性*****/
/**cell的高度*/
@property (nonatomic, assign, readonly) CGFloat cellHeight;
/**图片的frame*/
@property (nonatomic, assign, readonly) CGRect pictureF;
/**图片是否过大*/
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
/**图片的下载进度*/
@property (nonatomic, assign) CGFloat pictureProgress;

/**声音的frame*/
@property (nonatomic, assign, readonly) CGRect voiceF;
/**视频的frame*/
@property (nonatomic, assign, readonly) CGRect videoF;
@end
