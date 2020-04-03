//
//  UIColor+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/11.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel = 0,             //水平渐变
    IHGradientChangeDirectionVertical,              //竖直渐变
    IHGradientChangeDirectionUpwardDiagonalLine,    //向下对角线渐变
    IHGradientChangeDirectionDownDiagonalLine,      //向上对角线渐变
};


@interface UIColor (Custom)


/**
 主色调红色
 */
+ (UIColor *)masterColor;

/**
 深灰色字体
 */
+ (UIColor *)gray333Color;

/**
 中灰色字体
 */
+ (UIColor *)gray666Color;

/**
 浅灰色字体
 */
+ (UIColor *)gray999Color;

/**
 背景色
 */
+ (UIColor *)backgroundColor;

/**
 弹出视图半透明黑背景色
 */
+ (UIColor *)popupViewbackgroundColor;

/**
 分割线颜色
 */
+ (UIColor *)separatorColor;

/**
 渐变色生成图片(水平方向)
 */
+ (UIImage *)gradientRampColorWithSize:(CGSize)size;

/**
 生成随机颜色
 */
+ (UIColor *)randomColor;

/**
 设置RGB颜色
 */
+ (UIColor *)colorWithR:(float)r g:(float)g b:(float)b a:(float)a;

/**
 设置Hex颜色
 */
+ (UIColor *)colorWithHex:(long)hexColor;

/**
 设置Hex颜色
 */
+ (UIColor *)colorWithHexStr:(NSString *)hexColor;

/**
 设置Hex颜色，带透明度
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha;


/**
 * 创建渐变颜色
 *  @param size       渐变的size
 *  @param direction  渐变方式
 *  @param startcolor 开始颜色
 *  @param endColor   结束颜色
 *  @return 创建的渐变颜色
 */
+ (UIColor *)colorGradientChangeWithSize:(CGSize)size
                               direction:(IHGradientChangeDirection)direction
                              startColor:(UIColor *)startcolor
                                endColor:(UIColor *)endColor;



/**
 *  通过手机号码生成固定颜色
 *  @param mobile 手机号码
 *  @return 颜色
 */
+ (UIColor *)colorWithMobile:(NSString *)mobile;


/// 根据图片生成主色调颜色
/// @param image 图片
+ (UIColor *)masterColorWithImage:(UIImage *)image;


/// 两个颜色根据比例生成过度颜色
/// @param currentColor 当前颜色
/// @param changeColor 过度颜色
/// @param ratio 过度系数
/// @param alpha 生成颜色的透明度
+ (UIColor *)transitionColorWithcurrentColor:(UIColor*)currentColor
                                 changeColor:(UIColor *)changeColor
                                       ratio:(CGFloat)ratio
                                       alpha:(CGFloat)alpha;


@end

NS_ASSUME_NONNULL_END
