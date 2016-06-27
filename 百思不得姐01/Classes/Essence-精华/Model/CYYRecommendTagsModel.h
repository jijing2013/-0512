//
//  CYYRecommendTagsModel.h
//  百思不得姐01
//
//  Created by ma c on 16/4/9.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYYRecommendTagsModel : NSObject
/**
 *  image_list : http://img.spriteapp.cn/ugc/2016/03/10/092924_69853.jpg,
	theme_id : 3096,
	theme_name : 百思红人,
	is_sub : 0,
	is_default : 0,
	sub_number : 52387
 */

@property (nonatomic, strong) NSString *image_list;
@property (nonatomic, strong) NSString *theme_name;
@property (nonatomic, assign) NSInteger sub_number;
@end
