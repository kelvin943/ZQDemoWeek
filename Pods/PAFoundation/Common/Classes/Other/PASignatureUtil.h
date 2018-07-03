//
//  PASignatureUtil.h
//  haofang
//
//  Created by BlackDev on 5/9/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PASignatureUtil : NSObject

/**
 @brief api标识，该api在注册时的身份标识。生成规则：对域名之后的segment到url结束不包括参数部分求 md5 值。
 
        例如：md5(/manage/api/example.html)

 @param urlPath 域名之后的segment到url结束不包括参数部分
 @return apiSequence
 */
+ (NSString *)getAPISequenceFromURL:(NSString *)urlPath;

/**
 @brief api所有非系统参数升序排序，比如 {"a":"3","ab":"1","ac":"hello"}，再按一定顺序拼接其他字符串，最后取 md5 值。
        
        签名算法策略参考 http://pms.ipo.com/pages/viewpage.action?pageId=3506361
 
 @param parameters api所有非系统参数（签名相关的参数称为系统参数，除了 apiKey）
 @param time 当前时间戳10位
 @param apiSecret 40位SHA 1
 @param signFuncID 标识签名算法ID（不同业务的签名算法可能不同）
 @param apiSequence 对域名之后的segment到url结束不包括参数部分的md5，如 md5(/manage/api/example.html)
 @return 签名字符串
 */
+ (NSString *)getSignatureFromParameters:(NSDictionary *)parameters
                                    time:(NSString *)time
                               apiSecret:(NSString *)apiSecret
                              signFuncID:(NSString *)signFuncID
                             apiSequence:(NSString *)apiSequence;

@end
