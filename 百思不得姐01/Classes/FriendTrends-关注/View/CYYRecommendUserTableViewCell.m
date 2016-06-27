//
//  CYYRecommendUserTableViewCell.m
//  百思不得姐01
//
//  Created by ma c on 16/4/8.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecommendUserTableViewCell.h"
#import "CYYRecommendUserModel.h"
#import "UIImageView+WebCache.h"


@interface CYYRecommendUserTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation CYYRecommendUserTableViewCell


- (void)setUser:(CYYRecommendUserModel *)user{
    _user = user;
    
    self.screenNamelabel.text = user.screen_name;
    NSString *fansCount = nil;
    
    if (user.fans_count < 10000) {
        fansCount = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    }else{
        fansCount = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count /10000.0];
    }
    self.fansCountLabel.text = fansCount;
    
  //  [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    [self.headerImageView setHeader:user.header];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
