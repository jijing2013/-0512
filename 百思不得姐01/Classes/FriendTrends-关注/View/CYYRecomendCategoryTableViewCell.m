//
//  CYYRecomendCategoryTableViewCell.m
//  百思不得姐01
//
//  Created by ma c on 16/4/7.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecomendCategoryTableViewCell.h"
#import "CYYRecommendCategoryModel.h"

@interface CYYRecomendCategoryTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end

@implementation CYYRecomendCategoryTableViewCell

- (void)awakeFromNib {
    self.backgroundColor = RGB(244, 244, 244);
    self.textLabel.textColor = RGB(78, 78, 78);
    self.selectedIndicator.backgroundColor = RGB(219, 21, 26);
//    self.textLabel.highlightedTextColor = RGB(219, 21, 26);
    
//    UIView *back = [[UIView alloc] init];
//    back.backgroundColor = [UIColor clearColor];
//    self.selectedBackgroundView = back;
    
}
- (void)setCategory:(CYYRecommendCategoryModel *)category{
    
    _category = category;
    self.textLabel.text = category.name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //重新调整textLabel的高度
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - self.textLabel.y * 2;
}
//可以监听cell的取消与选中
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedIndicator.hidden = !selected;
    
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : RGB(78, 78, 78);
   // NSLog(@"%@---%s",self.category.name, selected);
}

@end
