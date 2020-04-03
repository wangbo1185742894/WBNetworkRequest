//
//  NSString+Custom.m
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/19.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import "NSString+Custom.h"
#import "NSString+Judge.h"

@implementation NSString (Custom)


- (NSMutableAttributedString *)stringConvertArrStrWithHeadIndent:(CGFloat)headIndent
                                             firstLineHeadIndent:(CGFloat)firstLineHeadIndent
                                                     lineSpacing:(CGFloat)lineSpacing {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, attStr.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = headIndent;                      //整体缩进
    style.firstLineHeadIndent = firstLineHeadIndent;    //首行锁进
    style.lineSpacing = lineSpacing;                    //行距
    
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attStr.length)];
    return attStr;
}


- (NSMutableAttributedString *)changeTextColorWithColor:(UIColor *)color subStringsArray:(NSArray *)subStringsArray {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self];
    for (NSString *string in subStringsArray) {
        //获取某个子字符串在某个总字符串中位置数组
        NSMutableArray *array = [self getRangeForSubString:string];
        for (NSNumber *rangeNum in array) {
            NSRange range = [rangeNum rangeValue];
            [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        }
    }
    return attributedString;
}



- (NSMutableArray *)getRangeForSubString:(NSString *)subString {
    
    NSMutableArray *arrayRanges = [NSMutableArray array];
    
    if (subString == nil && [subString isEqualToString:@""]) {
        return nil;
    }
    
    NSRange rang = [self rangeOfString:subString];
    
    if (rang.location != NSNotFound && rang.length != 0) {
        
        [arrayRanges addObject:[NSNumber valueWithRange:rang]];
        
        NSRange      rang1 = {0,0};
        NSInteger location = 0;
        NSInteger   length = 0;
        
        for (int i = 0;; i++) {
            
            if (0 == i) {
                
                location = rang.location + rang.length;
                length = self.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
                
            } else {
                
                location = rang1.location + rang1.length;
                length = self.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            
            rang1 = [self rangeOfString:subString options:NSCaseInsensitiveSearch range:rang1];
            
            if (rang1.location == NSNotFound && rang1.length == 0) {
                
                break;
            } else {
                
                [arrayRanges addObject:[NSNumber valueWithRange:rang1]];
            }
        }
        
        return arrayRanges;
    }
    
    return nil;
}


- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                    color:(UIColor *)color
                           subStringArray:(NSArray *)subStringArray {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    for (NSString *string in subStringArray) {
        //获取某个子字符串在某个总字符串中位置数组
        NSMutableArray *array = [self getRangeForSubString:string];
        for (NSNumber *rangeNum in array) {
            NSRange range = [rangeNum rangeValue];
            //改变颜色
            [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            //改变字体
            [attributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
    }
    return attributedStr;
}



- (NSMutableAttributedString *)addLineWithColor:(UIColor *)lineColor subStringArray:(NSArray *)subStringArray {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    for (NSString *string in subStringArray) {
        NSMutableArray *array = [self getRangeForSubString:string];
        for (NSNumber *rangeNum in array) {
            NSRange range = [rangeNum rangeValue];
            [attributedStr addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSUnderlineColorAttributeName:lineColor,NSForegroundColorAttributeName:lineColor}  range:range];
        }
    }
    return attributedStr;
}


- (NSMutableAttributedString *)addMiddleLine {
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    return [[NSMutableAttributedString alloc]initWithString:self attributes:attribtDic];
}


- (NSString *)hideMobiCenterFourStr {
    if (!self || [self isPhoneNumber] == NO) {
        return @"";
    }else{
        NSString *string = [self substringWithRange:NSMakeRange(3,4)];
        return [self stringByReplacingOccurrencesOfString:string withString:@"****"];
    }
}


- (NSString *)moneyStr {
    return [NSString stringWithFormat:@"%.2lf", [self doubleValue]];
}


- (NSString *)safeStrin {
    // 是有长度的字符串
    if ([self isKindOfClass:[NSString class]] && 0 < [self length]) {
        return self;
    }
    
    // 是空对象
    if (!self) {
        return @"";
    }
    
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    // 其他类型的对象不做处理，直接返回
    return self;
}



- (int)calculateStringLength {
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}



- (NSString *)changeChineseToPinYin {
    NSMutableString *pinyin = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}


+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}


- (NSDictionary *)JsonToDictionary {
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


- (NSString *)replaceChinaeseUrl {
    NSString *urlStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return urlStr;
}

-(NSString *)safeString{
    if (self == nil || [self isEqualToString:@"(null)"] || [self isEqualToString:@"<null>"]) {
        return @"";
    }
    return self;
}


+ (CGSize)labelText:(NSString *)text fontSize:(float)size width:(CGFloat)width{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
       NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
       
       CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, 0) options:option attributes:attribute context:nil].size;
       
       return textSize;
}







@end
