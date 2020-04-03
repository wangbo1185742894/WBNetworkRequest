//
//  UIView+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/10/9.
//  Copyright © 2019 彭睿. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Custom)

/// 设置渐变背景色
- (void)showGradualChangeBackgroundColor;


/// 设置某个方向或所有方向的边框
/// @param array 方向数组   @[@"left",@"right",@"top",@"buttom"]
/// @param color 边框颜色
- (void)setBorderDirectionArray:(NSArray <NSString *>*)array color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
