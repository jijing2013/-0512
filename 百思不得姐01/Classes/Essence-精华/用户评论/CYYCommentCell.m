//
//  CYYCommentCell.m
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYCommentCell.h"
#import "CYYComment.h"
#import "UIImageView+WebCache.h"
#import "CYYUser.h"

@interface CYYCommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (weak, nonatomic) IBOutlet UILabel *useLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceButton;

@end

@implementation CYYCommentCell
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}
- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    self.backgroundView = bgView;
}

- (void)setComment:(CYYComment *)comment{
    _comment = comment;
    
    //设置头像
//    UIImage *placeholderImage = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
//    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.profileImageView.image = image ? [image circleImage] : placeholderImage;
//    }];
    [self.profileImageView setHeader:comment.user.profile_image];
    //设置行别图片
    self.sexImage.image = [comment.user.sex isEqualToString:CYYUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
    
    self.useLabel.text = comment.user.username;
    self.contentLabel.text = comment.content;
    
    NSString *like_count = nil;
    if (comment.like_count < 10000) {
        like_count = [NSString stringWithFormat:@"%zd", comment.like_count];
    }else{
        like_count = [NSString stringWithFormat:@"%.2ld万",comment.like_count / 10000];
    }
    self.likeCountLabel.text = like_count;
    
    if (comment.user.voiceuri.length) {
        self.voiceButton.hidden = NO;
        [self.voiceButton setTitle:[NSString stringWithFormat:@"%zd''",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceButton.hidden = YES;
    }
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
