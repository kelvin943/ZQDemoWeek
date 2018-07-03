//
//  NSString+URL.h
//  manpanxiang
//
//  Created by Linkou Bian on 28/06/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 获取 url 里面的参数

 @return 参数字典
 */
- (NSDictionary *)getURLParams;

/**
 对字符串添加 url 参数

 @param params 参数字典
 @return 拼接参数后的 url
 */
- (NSString *)stringByAddingURLParams:(NSDictionary *)params;

@end
