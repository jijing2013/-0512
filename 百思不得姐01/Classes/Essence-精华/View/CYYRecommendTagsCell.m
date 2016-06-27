//
//  CYYRecommendTagsCell.m
//  百思不得姐01
//
//  Created by ma c on 16/4/9.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecommendTagsCell.h"
#import "CYYRecommendTagsModel.h"
#import "UIImageView+WebCache.h"


@interface CYYRecommendTagsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end
@implementation CYYRecommendTagsCell

- (void)setRecommendTag:(CYYRecommendTagsModel *)recommendTag{
    _recommendTag = recommendTag;
    //设置头像
    [self.imageListImageView setHeader:recommendTag.image_list];
 //   [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text = recommendTag.theme_name;

    NSString *subNumber = nil;
    
    if (recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }else{
        subNumber = [NSString stringWithFormat:@"%.1f万人订阅",recommendTag.sub_number /10000.0];
    }
    self.subNumberLabel.text = subNumber;
}


- (void)setFrame:(CGRect)frame{

    frame.size.height -= 1;
    [super setFrame:frame];
   
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
