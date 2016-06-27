//
//  CYYUser.h
//  百思不得姐01
//
//  Created by ma c on 16/5/6.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYYUser : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 性别 */
@property (nonatomic, copy) NSString *sex;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 音频文件路径 */
@property (nonatomic, assign) NSString *voiceuri;

@end
