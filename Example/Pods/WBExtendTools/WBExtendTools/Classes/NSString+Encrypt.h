//
//  NSString+Encrypt.h
//  
//
//  Created by Charles on 14/9/22.
//  Copyright © 2015年 Com.Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/**
 *  字符串md5加密
 */
- (NSString *) stringWithMD5;

/**
 *  字符串sha1加密
 */
- (NSString *) stringWithSha1;

/**
 *  字符串DES3加密
 */
+ (NSString *)encryptWithText:(NSString *)sText;

/**
 *  字符串DES3解密
 */
+ (NSString *)decryptWithText:(NSString *)sText;

@end
