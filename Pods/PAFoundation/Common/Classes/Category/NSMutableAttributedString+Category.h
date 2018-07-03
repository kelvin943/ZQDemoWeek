//
//  NSMutableAttributedString+Category.h
//  manpanxiang
//
//  Created by Linkou Bian on 23/08/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Category)

/**
 添加指定格式的字符串

 @param string 新拼接的字符串
 @param font 字体
 @param color 颜色
 @return 拼接后的字符串
 */
- (NSAttributedString *)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

- (NSAttributedString *)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color baselineOffset:(NSNumber *)offset;

@end
