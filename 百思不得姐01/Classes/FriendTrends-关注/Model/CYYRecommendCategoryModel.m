//
//  CYYRecommendCategory.m
//  百思不得姐01
//
//  Created by ma c on 16/4/7.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import "CYYRecommendCategoryModel.h"

@implementation CYYRecommendCategoryModel

- (NSMutableArray *)users{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

@end
