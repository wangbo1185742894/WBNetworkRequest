//
//  CAAnimation+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/22.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "CAAnimation+Custom.h"

@implementation CAAnimation (Custom)

+ (void)animationAddToShoppingCartGoodsImage:(UIImage *)goodsImage
                                  startPoint:(CGPoint)startPoint
                                    endPoint:(CGPoint)endPoint
                                  completion:(void (^)(BOOL finished,CABasicAnimation *animation))completion {
    //创建shapeLayer
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.frame = CGRectMake(startPoint.x - 20, startPoint.y - 20, 40, 40);
    animationLayer.contents = (id)goodsImage.CGImage;
    animationLayer.cornerRadius = 20;
    animationLayer.masksToBounds = YES;
    
    // 获取window的最顶层视图控制器
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    UIViewController *parentVC = rootVC;
    while ((parentVC = rootVC.presentedViewController) != nil ) {
        rootVC = parentVC;
    }
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    // 添加layer到顶层视图控制器上
    [rootVC.view.layer addSublayer:animationLayer];
    
    //创建移动轨迹
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:startPoint];
    [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(200,100)];
    //轨迹动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.duration = 1;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.path = movePath.CGPath;
    
    //创建缩小动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.duration = 1.0;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    //添加轨迹动画
    [animationLayer addAnimation:pathAnimation forKey:nil];
    //添加缩小动画
    [animationLayer addAnimation:scaleAnimation forKey:nil];
    
    //动画结束后执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
        //颤抖吧
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:0.6];
        animation.duration = 0.08;
        animation.repeatCount = 3;//颤抖两次
        animation.autoreverses = YES;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        completion(YES,animation);
    });
}



+ (void)animationShakeView:(UIView *)view {
    CGPoint position = view.layer.position;
    CGPoint x = CGPointMake(position.x + 3, position.y);
    CGPoint y = CGPointMake(position.x - 3, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [view.layer addAnimation:animation forKey:nil];
}


@end
