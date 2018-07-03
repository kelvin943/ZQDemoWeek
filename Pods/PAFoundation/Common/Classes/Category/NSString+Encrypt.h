//
//  NSString+Encrypt.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/17.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

/**
 获取字符串的 MD5 值

 @return 字符串
 */
- (NSString *)md5;


/**
 获取字符串的 Base64 编码

 @return 字符串
 */
- (NSString *)base64EncodeString;

/**
 根据 Base64 编码后的字符串返回原始值

 @return 字符串
 */
- (NSString *)decodeBase64String;

@end
