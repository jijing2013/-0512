//
//  CYYAddTagViewController.h
//  百思不得姐01
//
//  Created by ma c on 16/5/15.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYYAddTagViewController : UIViewController

/** 获取tags的block */
@property (nonatomic, copy) void (^tagsBlock)(NSArray *tags);
/** 所有的标签 */
@property (nonatomic, strong) NSArray *tags;
@end
