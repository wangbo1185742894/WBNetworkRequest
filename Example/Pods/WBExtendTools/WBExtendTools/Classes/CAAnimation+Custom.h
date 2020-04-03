//
//  CAAnimation+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/22.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAAnimation (Custom)

/**
 * 加入购物车的动画效果
 * @param goodsImage 商品图片
 * @param startPoint 动画起点
 * @param endPoint   动画终点
 * @param completion 动画执行完成后的回调
 */
+ (void)animationAddToShoppingCartGoodsImage:(UIImage *)goodsImage
                                  startPoint:(CGPoint)startPoint
                                    endPoint:(CGPoint)endPoint
                                  completion:(void (^)(BOOL finished,CABasicAnimation *animation))completion;


/**
 * 抖动
 * @param view 被抖动view
 */
+ (void)animationShakeView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
