//
//  UIColor+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/11.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "UIColor+Custom.h"

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}


@implementation UIColor (Custom)

+ (UIColor *)masterColor
{
    return [UIColor colorWithHex:0xF52D36];
}

+ (UIColor *)gray333Color
{
    return [UIColor colorWithHex:0x333333];
}

+ (UIColor *)gray666Color
{
    return [UIColor colorWithHex:0x666666];
}

+ (UIColor *)gray999Color
{
    return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithHex:0xf5f5f5];
}

+ (UIColor *)popupViewbackgroundColor
{
    return [UIColor colorWithR:0 g:0 b:0 a:0.3];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithHex:0xf5f5f5];
}

+ (UIImage *)gradientRampColorWithSize:(CGSize)size
{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    gradientLayer.startPoint = CGPointZero;
    
    CGPoint endPoint = CGPointMake(1.0, 0.0);
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHex:0xFB5D4E].CGColor, (__bridge id)[UIColor colorWithHex:0xFC3569].CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIColor *)randomColor
{
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
}

+ (UIColor *)colorWithR:(float)r g:(float)g b:(float)b a:(float)a
{
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a];
}

+ (UIColor*)colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (UIColor *)colorWithHexStr:(NSString *)hexColor {
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    @try {
        if ([hexColor hasPrefix:@"#"]) {
            hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        if ([hexColor length] > 6) {
            range.location = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        }
    }
    @catch (NSException * e) {
        
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(1.0f)];
}



+ (UIImage *)gradientRampColorWithSize:(CGSize)size
                             direction:(IHGradientChangeDirection)direction
                            startColor:(UIColor *)startcolor
                              endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == IHGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case IHGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case IHGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case IHGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case IHGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    return UIGraphicsGetImageFromCurrentImageContext();
}


+ (UIColor *)colorGradientChangeWithSize:(CGSize)size
                                  direction:(IHGradientChangeDirection)direction
                                 startColor:(UIColor *)startcolor
                                   endColor:(UIColor *)endColor {
    
    UIImage*image = [self gradientRampColorWithSize:size direction:direction startColor:startcolor endColor:endColor];
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}


+ (UIColor *)colorWithMobile:(NSString *)mobile {
    if (mobile.length >= 11 && ![mobile isEqualToString:@"(null)"]) {
        NSString *telephone = mobile;
        
        CGFloat r = 0.0,g = 0.0,b = 0.0;
        
        r = [UIColor caculateWithNum:[[telephone substringToIndex:4] intValue] % 255 / 255.0];
        g = [UIColor caculateWithNum:[[telephone substringWithRange:NSMakeRange(4, 4)] intValue] % 255 / 255.0];
        b = [UIColor caculateWithNum:[[telephone substringFromIndex:8] intValue] % 255 / 255.0];
        UIColor *color = [UIColor colorWithRed:r green:g  blue:b alpha:1.0];
        return color;
    }else {
        return [UIColor blueColor];
    }
}

+ (CGFloat)caculateWithNum:(CGFloat)num {
    if (80.0 < num < 200.0) {
        return num;
    } else {
        if (num > 200.0) {
            return 205.f;
        }
        if (num < 80.0) {
            return 80.0;;
        }
    }
    return 0.0;
}


+ (UIColor *)transitionColorWithcurrentColor:(UIColor*)currentColor
                                 changeColor:(UIColor *)changeColor
                                       ratio:(CGFloat)ratio
                                       alpha:(CGFloat)alpha {
    
    const CGFloat *component = CGColorGetComponents(currentColor.CGColor);
    const CGFloat *nextcomponent = CGColorGetComponents(changeColor.CGColor);

    CGFloat rColorOffset = component[0] * 255 + (nextcomponent[0] * 255 - component[0] * 255) * ratio;
    CGFloat gColorOffset = component[1] * 255 + (nextcomponent[1] * 255 - component[1] * 255) * ratio;
    CGFloat bColorOffset = component[2] * 255 + (nextcomponent[2] * 255 - component[2] * 255) * ratio;
        
    return [UIColor colorWithR:rColorOffset * 0.8f g:gColorOffset * 0.8f b:bColorOffset * 0.8f a:alpha];
}


+ (UIColor *)masterColorWithImage:(UIImage *)image {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(120, 120);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        
    }
    
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


@end
