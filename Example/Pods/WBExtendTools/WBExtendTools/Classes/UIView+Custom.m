//
//  UIView+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/10/9.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "UIView+Custom.h"
#import "UIColor+Custom.h"
#import "UIView+Frame.h"

@implementation UIView (Custom)

- (void)showGradualChangeBackgroundColor {
    self.backgroundColor = [UIColor colorGradientChangeWithSize:self.size direction:IHGradientChangeDirectionLevel startColor:[UIColor colorWithHex:0xFB5D4E] endColor:[UIColor colorWithHex:0xFC3569]];
}

- (void)setBorderDirectionArray:(NSArray <NSString *>*)array color:(UIColor *)color {
    if ([array containsObject:@"left"] &&
        [array containsObject:@"right"] &&
        [array containsObject:@"top"] &&
        [array containsObject:@"bottom"]) {
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 0.3;
        return;
    }
    
    if ([array containsObject:@"left"]) {
        CALayer *lineLayer = [CALayer new];
        lineLayer.frame = CGRectMake(0, 0, 0.3, self.frame.size.height);
        lineLayer.backgroundColor = color.CGColor;
        [self.layer addSublayer:lineLayer];
    }
    
    if ([array containsObject:@"right"]) {
        CALayer *lineLayer = [CALayer new];
        lineLayer.frame = CGRectMake(self.frame.size.width - 0.3, 0, 0.3, self.frame.size.height);
        lineLayer.backgroundColor = color.CGColor;
        [self.layer addSublayer:lineLayer];
    }
    
    if ([array containsObject:@"top"]) {
        CALayer *lineLayer = [CALayer new];
        lineLayer.frame = CGRectMake(0, 0, self.frame.size.width, 0.3);
        lineLayer.backgroundColor = color.CGColor;
        [self.layer addSublayer:lineLayer];
    }
    
    if ([array containsObject:@"bottom"]) {
        CALayer *lineLayer = [CALayer new];
        lineLayer.frame = CGRectMake(0, self.frame.size.height - 0.3, self.bounds.size.width, 0.3);
        lineLayer.backgroundColor = color.CGColor;
        [self.layer addSublayer:lineLayer];
    }
}


// 绘制圆形
- (UIImage *)drawCircleRadius:(float)radius
                    outerSize:(CGSize)outerSize
                    fillColor:(UIColor *)fillColor {
    UIGraphicsBeginImageContextWithOptions(outerSize, false, [UIScreen mainScreen].scale);

    // 1、获取当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext();

    //2.描述路径
    // ArcCenter:中心点 radius:半径 startAngle起始角度 endAngle结束角度 clockwise：是否逆时针
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outerSize.width * 0.5, outerSize.height * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
    [bezierPath closePath];

    // 3.外边
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(outerSize.width, 0)];
    [bezierPath addLineToPoint:CGPointMake(outerSize.width, outerSize.height)];
    [bezierPath addLineToPoint:CGPointMake(0, outerSize.height)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath closePath];

    //4.设置颜色
    [fillColor setFill];
    [bezierPath fill];

    CGContextDrawPath(contextRef, kCGPathStroke);
    UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return antiRoundedCornerImage;
}


@end
