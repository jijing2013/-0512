//
//  CYYRecommendUserModel.h
//  百思不得姐01
//
//  Created by ma c on 16/4/9.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYYRecommendUserModel : NSObject
/**
 *  	introduction : ,
	uid : 15264834,
	header : http://wimg.spriteapp.cn/profile/large/2016/03/08/56dedca02c60f_mini.jpg,
	gender : 2,
	is_vip : 0,
	fans_count : 559,
	tiezi_count : 24,
	is_follow : 0,
	screen_name : 不伶哥

 */

@property (nonatomic, copy) NSString *header;
@property (nonatomic, assign) NSInteger fans_count;
@property (nonatomic, copy) NSString *screen_name;



@end
