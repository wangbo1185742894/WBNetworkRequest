//
//  UIImage+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/22.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Custom.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Custom)


/**
 *  截取整个view
 *  @param view  待截图的View
 *  @return         截取图片
 */
+ (UIImage*)cutOutView:(UIView *)view;


/**
 *  截取view上某一部分
 *  @param image    待截图的图片
 *  @param cropRect 尺寸
 *  @return         截取图片
 */
+ (UIImage *)cutOutImage:(UIImage *)image rect:(CGRect)cropRect;


/**
 *  截取整个Scrollview
 *  @param scrollView  待截图的Scrollview
 *  @return         截取图片
 */
+ (UIImage *)cutOutScrollView:(UIScrollView *)scrollView;


/**
 *  拼接多图
 *  @param firstImage  待拼接的View
 *  @param lastImage  待拼接的View
 *  @return         截取图片
 */
+ (UIImage *)jointImageWithFirstImage:(UIImage *)firstImage lastImage:(UIImage *)lastImage;


/**
 *  获取视频第一帧截图
 *  @param videoUrl 视频url
 *  @param time 时间
 *  @return 截图
 */
+ (UIImage *)imageFirstForVideoUrl:(NSURL *)videoUrl Time:(NSTimeInterval)time;


/**
 *  压缩图片尺寸
 *  @param image    带压缩图片
 *  @param viewSize 目标Size
 *  @return UIImage
 */
+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewSize;


/**
 *  拉伸图片
 *  @param image 图片
 *  @return 返回拉伸后的图片
 */
+ (UIImage *)stretchableImage:(UIImage *)image;


/**
 *  通过颜色生成图片
 *  @param color color
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


/**
 *  通过链接生成二维码图片
 *  @param url 路径
 *  @param size 大小
 */
+ (UIImage *)imageQRCodeUrL:(NSString *)url size:(CGSize)size;

/**
 *  通过链接生成条形码图片
 *  @param url 路径
 *  @param size 大小
 */
+ (UIImage *)imageBarCodeUrL:(NSString *)url size:(CGSize)size;


/**
 *  给图片加一层模糊蒙版
 *  @param blur color
 */
- (UIImage *)imageblurryBlurLevel:(CGFloat)blur;

/**
 渐变色生成图片(水平方向)
 */
+ (UIImage *)gradientRampColorWithSize:(CGSize)size;

/**
 创建渐变颜色图片
 
 @param size 渐变的size
 @param direction 渐变方式
 @param startcolor 开始颜色
 @param endColor 结束颜色
 @return 创建的渐变图片
 */
+ (UIImage *)gradientRampColorWithSize:(CGSize)size
                             direction:(IHGradientChangeDirection)direction
                            startColor:(UIColor *)startcolor
                              endColor:(UIColor *)endColor;

@end

NS_ASSUME_NONNULL_END
