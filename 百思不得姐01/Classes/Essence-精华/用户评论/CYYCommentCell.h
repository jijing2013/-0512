//
//  CYYCommentCell.h
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYYComment;
@interface CYYCommentCell : UITableViewCell

/**评论模型*/
@property (nonatomic, strong) CYYComment *comment;
@end
