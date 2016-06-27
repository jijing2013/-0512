//
//  CYYTagTextField.h
//  百思不得姐01
//
//  Created by ma c on 16/5/15.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYYTagTextField : UITextField

/**按删除键的回调*/
@property (nonatomic, copy) void(^deleteBlock)();
@end
