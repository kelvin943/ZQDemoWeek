//
//  PAURLMap.h
//  haofang
//
//  Created by PengFeiMeng on 4/30/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAURLHelper.h"

#ifndef PAURLMapSectName
#define PAURLMapSectName "PAURLMap"
#endif


#define PAURLMapDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))


#define PAURLMap(identifier,controller) \
import Foundation; \
char * k##controller##_view_identifier PAURLMapDATA(PAURLMap) = "{ \""#identifier"\" : \""#controller"\"}";

#define PAURLMapX(identifier,controller) \
char * k##controller##_view_identifier PAURLMapDATA(PAURLMap) = "{ \""#identifier"\" : \""#controller"\"}";

@interface PAURLMap : NSObject

/*!
 @method
 @abstract      生成view跳转url
 @param         identifier view 标识
 @param         params 初始化参数
 @discussion    参数必须全部为NSString类型的,示例；
                [PAURLMap urlForViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW params:@{@"_url": @"http://www.baidu.com", @"_title": @"你好"}];
 @return        NSString,生成的view跳转url
 */
+ (NSString *)urlForViewWithIdentifier:(NSString *)identifier params:(NSDictionary *)params;

/*!
 @method
 @abstract      生成调用应用服务的url
 @param         identifier 应用提供的服务标识
 @param         params 初始化参数
 @discussion    参数必须全部为NSString类型的,示例；
                [PAURLMap urlForViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW params:@{@"_url": @"http://www.baidu.com", @"_title": @"你好"}];
 @return        NSString,生成的view跳转url
 */
+ (NSString *)urlForServiceWithIdentifier:(NSString *)identifier params:(NSDictionary *)params;

@end
