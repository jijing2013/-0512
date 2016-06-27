//
//  CYYPlaceholderTextView.h
//  百思不得姐01
//
//  Created by ma c on 16/5/14.
//  Copyright © 2016年 ma c. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYYPlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
@end
