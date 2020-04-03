//
//  WbLabel.m
//  CommunityPeople
//
//  Created by 黄坤 on 2018/12/3.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "WbLabel.h"

@interface WbLabel ()
@property (nonatomic,copy)NSString *strText;
@end


@implementation WbLabel

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = [UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_strText drawInRect:self.bounds withAttributes:@{NSFontAttributeName : self.font}];
    CGImageRef textMask = CGBitmapContextCreateImage(context);
    
    // 清空画布
    CGContextClearRect(context, rect);
    
    // 设置蒙层
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, textMask);
    
    // 绘制渐变(r:0.98 g:0.36 b:0.31 a:1.00) CGFloat colors[] = {0.98 ,0.36 ,0.31,1.00,
//    0.99 ,0.21 ,0.41,1.00};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0 ,1};
    CGFloat colors[] = {0.98 ,0.36 ,0.31,1.00,
                        0.99 ,0.21 ,0.41,1.00
    };
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, colors, locations, 2);
    CGPoint start = CGPointMake(0, self.bounds.size.height / 2.0);
    CGPoint end = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
    
    // 释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    CGImageRelease(textMask);
}

-(void)setWbText:(NSString *)text{
    _strText = text;
    self.text = text;
}

@end
