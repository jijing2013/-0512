//
//  CYYCommentHeaderView.h
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYYCommentHeaderView : UITableViewHeaderFooterView
/** 文字数据*/
@property (nonatomic, copy) NSString *title;

+(instancetype) headerViewWithTableView:(UITableView *)tableView;
@end
