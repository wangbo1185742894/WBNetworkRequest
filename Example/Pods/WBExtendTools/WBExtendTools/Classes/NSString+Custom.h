//
//  NSString+Custom.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/19.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Custom)


/**
 *  设置字符缩进，行间距
 *  @param headIndent    整体缩进
 *  @param firstLineHeadIndent 首行缩进
 *  @param lineSpacing 行间距
 *  @return 生成的富文本
*/
- (NSMutableAttributedString *)stringConvertArrStrWithHeadIndent:(CGFloat)headIndent
                                             firstLineHeadIndent:(CGFloat)firstLineHeadIndent
                                                     lineSpacing:(CGFloat)lineSpacing;


/**
 *  改变一句话中的某些字的颜色（一种颜色）
 *  @param color    需要改变成的颜色
 *  @param subStringsArray 需要改变颜色的文字数组(字符串中所有的 相同的字)
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)changeTextColorWithColor:(UIColor *)color subStringsArray:(NSArray *)subStringsArray;

/**
 *  获取某个字符串中子字符串的位置数组 (字符串中所有的 相同的字)
 *  @param subString   子字符串
 *  @return 位置数组
 */
- (NSMutableArray *)getRangeForSubString:(NSString *)subString;


/**
 *  改变某些文字的颜色 并单独设置其字体
 *  @param font        设置的字体
 *  @param color       颜色
 *  @param subStringArray    想要变色的字符数组
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                    color:(UIColor *)color
                           subStringArray:(NSArray *)subStringArray;


/**
 *  为某些文字下面画线
 *  @param subStringArray    需要画线的文字数组
 *  @param lineColor   线条的颜色
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)addLineWithColor:(UIColor *)lineColor subStringArray:(NSArray *)subStringArray;


/**
 *  为文字加中划线
 *  @return 生成的富文本
 */
- (NSMutableAttributedString *)addMiddleLine;


/**
 *  计算字符串长度，UILabel自适应高度
 *  @param text  需要计算的字符串
 *  @param size  字号大小
 *  @param width 最大宽度
 *  @return 返回大小
 */
+ (CGSize)labelText:(NSString *)text fontSize:(float)size width:(CGFloat)width;


/**
 *  替换电话号码中间四位为*
 */
- (NSString *)hideMobiCenterFourStr;


/**
 *  精确到小数点后两位
 */
- (NSString *)moneyStr;


/**
 *  判空判异常，确保返回有值
 */
- (NSString *)safeString;


/**
 *  判断中文和英文字符串的长度
 */
- (int)calculateStringLength;


/**
 *  将汉字转化成拼音
 *  @return 拼音字符串
 */
- (NSString *)changeChineseToPinYin;


/**
 *  字典转json
 *  @param dic 字典数据
 *  @return NSString
 */
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;


/**
 *  json转字典
 *  @return NSDictionary
 */
- (NSDictionary *)JsonToDictionary;


/**
 *  带汉字的URL转义成utf8
 *  @return NSString
 */
- (NSString *)replaceChinaeseUrl;


@end

NS_ASSUME_NONNULL_END
