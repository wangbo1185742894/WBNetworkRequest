//
//  UIView+Layer.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/12.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

////参数指定了要成为圆角的角, 枚举类型如下:
//typedef NS_OPTIONS(NSUInteger, UIRectCorner) {
//    UIRectCornerTopLeft     = 1 <&lt; 0,
//    UIRectCornerTopRight    = 1 <&lt; 1,
//    UIRectCornerBottomLeft  = 1 <&lt; 2,
//    UIRectCornerBottomRight = 1 <&lt; 3,
//    UIRectCornerAllCorners  = ~0UL
//};


@interface UIView (Layer)

/**
 *  设置圆角边框
 */
- (void)layerRadius:(CGFloat)cornerRadius
        borderWidth:(CGFloat)borderWidth
        borderColor:(UIColor *)borderColor;

/**
 *  边角半径
 */
@property (nonatomic, assign) CGFloat layerCornerRadius;
/**
 *  边线宽度
 */
@property (nonatomic, assign) CGFloat layerBorderWidth;
/**
 *  边线颜色
 */
@property (nonatomic, strong) UIColor *layerBorderColor;


/// 绘制圆角（可以指定方向）
/// @param directions 方向 使用“|”来组合
/// @param cornerRadius 圆角半径
- (void)drawCircularBeadParamsdirections:(UIRectCorner)directions
                            cornerRadius:(CGFloat)cornerRadius;


/// 绘制圆角和边框（可以指定方向
/// @param directions 方向 使用“|”来组合
/// @param cornerRadius 圆角半径
/// @param borderWidth 边框宽度
/// @param borderColor 边框颜色
- (void)drawCircularBeadParamsdirections:(UIRectCorner)directions
                            cornerRadius:(CGFloat)cornerRadius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor;


@end

NS_ASSUME_NONNULL_END
