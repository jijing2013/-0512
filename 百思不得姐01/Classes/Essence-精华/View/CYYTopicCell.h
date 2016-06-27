//
//  CYYTopicCell.h
//  百思不得姐01
//
//  Created by ma c on 16/4/29.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYYTopic.h"

@interface CYYTopicCell : UITableViewCell
/** model数据*/
@property (nonatomic, strong) CYYTopic *topic;

+ (instancetype)cell;
@end
