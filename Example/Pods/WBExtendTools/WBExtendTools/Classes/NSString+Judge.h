//
//  NSString+Judge.h
//  CommunityPeople
//
//  Created by 彭睿 on 2019/7/19.
//  Copyright © 2019 彭睿. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Judge)

/**
 *  判断国际手机号
 */
- (BOOL)isPhoneNumberGloabel;


/**
 *  判断手机号是否合法
 *  @return 返回YES合法 返回NO不合法
 */
- (BOOL)isPhoneNumber;

/**
 *  判断字符传中是否包含Emoji表情
 *  @return 结果 @{@"isContains":@(BOOL),@"emojiCount":@(NSUInteger)}
 */
- (BOOL)isContainsEmoji;


/**
 *  判断字符串是否为全中文
 *  @return 判断返回
 */
- (BOOL)IsChinese;

/**
 *  判断字符串是否包含特殊字符
 *  @return 判断返回
 */
- (BOOL)isContainsCharacter;

/**
 *  判断字符串是否为空（@"" nil NULL (null)）
 *  @return 判断返回
 */
- (BOOL)isBlank;


/**
 *  验证邮箱
 *  @return 判断返回
 */
- (BOOL)isEmail;


/**
 *  判断是否为全数字
 *  @return 判断返回
 */
- (BOOL)isNumber;


/**
 *  是否是银行卡
 *  @return 判断返回
 */
- (BOOL)isBankCard;


/**
 *  验证身份证号正则
 *  @return 是否合法  0/1  否／是
 */
- (BOOL)isIDCard;


@end

NS_ASSUME_NONNULL_END
