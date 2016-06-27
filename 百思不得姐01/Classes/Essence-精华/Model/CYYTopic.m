//
//  CYYTopic.m
//  百思不得姐01
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYTopic.h"
#import "MJExtension.h"
#import "CYYUser.h"
#import "CYYComment.h"

@interface CYYTopic ()
{
    CGFloat _cellHeight;
    CGRect _pictureF;
}

@end
@implementation CYYTopic

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}


- (NSString *)create_time{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //帖子创建时间
    NSDate *creat = [fmt dateFromString:_create_time];
    
    if (creat.isThisYear) {//今年
        if (creat.isToday) {//今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:creat];
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if (cmps.minute >= 1){
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else{//小于一分钟
                return @"刚刚";
            }
        }else if (creat.isYesterday){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:creat];
        }else{//其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:creat];
        }
    }else{//非今年
        return _create_time;
    }
}

- (CGFloat)cellHeight{

    //cell的高度
    if (!_cellHeight) {
        CGFloat textY = 55;
        //文字的高度
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT);
        //绘制属性
        NSDictionary *fontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:fontDict context:nil].size.height;
        //    CGFloat textH = [topic.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize].height;
        _cellHeight = textY + textH + 10;
        //根据段子的类型来计算cell的高度
        if (self.type == 10) {
            if (self.width != 0 && self.height != 0) {
                //图片显示出来的大小
                CGFloat pictureW = maxSize.width;
                CGFloat pictureH = pictureW * self.height / self.width;
                
                //显示出来的高度
                if (pictureH >= CYYTopicPictureH) {//图片的高度过长
                    pictureH = CYYTopicPictureBreakH;
                    self.bigPicture = YES;//图片过大
                }
                
                //计算图片控件的frame
                CGFloat pictureY = textY + textH + 10;
                _pictureF = CGRectMake(10, pictureY, pictureW, pictureH);
                
                _cellHeight += pictureH + 10;
            }
        }
        else if (self.type == 31){
            CGFloat voiceX = 10;
            CGFloat voiceY = textY + textH + 10;
            CGFloat voiceW = maxSize.width;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight += voiceH + 10;
        }else if (self.type == 41){
            CGFloat videoX = 10;
            CGFloat videoY = textY + textH + 10;
            CGFloat videoW = maxSize.width;
            CGFloat videoH = videoW * self.height / self.width;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight += videoH + 10;
        }
        
       //如果有最热评论
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += CYYTopicCellTopCmtTitleH + contentH + 10;
        }
        //底部工具条的高度+间距
        _cellHeight += 35 + 10;
    }
    return _cellHeight;
}
@end
