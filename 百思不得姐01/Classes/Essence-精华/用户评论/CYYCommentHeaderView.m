//
//  CYYCommentHeaderView.m
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYCommentHeaderView.h"

@interface CYYCommentHeaderView ()

/**文字标签*/
@property (nonatomic, strong) UILabel *label;
@end
@implementation CYYCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
      static NSString *ID = @"header";
    
    CYYCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {//缓存池中没有header，自己创建
        header = [[CYYCommentHeaderView alloc] initWithReuseIdentifier:ID];
        header.contentView.backgroundColor = RGB(223, 223, 223);;
    }
    return header;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(223, 223, 223);;
        //创建label
        UILabel * label = [[UILabel alloc] init];
        label.textColor = RGB(67, 67, 67);
        label.width = 200;
        label.x = 10;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    self.label.text = title;
}
@end
