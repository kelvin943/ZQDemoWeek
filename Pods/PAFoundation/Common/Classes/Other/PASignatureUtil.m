//
//  PASignatureUtil.m
//  haofang
//
//  Created by BlackDev on 5/9/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PASignatureUtil.h"
#import "NSString+Encrypt.h"

@implementation PASignatureUtil

#pragma mark - Public Methods

// api标识，该api在注册时的身份标识。
+ (NSString *)getAPISequenceFromURL:(NSString *)urlPath{
    NSString *sequence = nil;
    NSString *url = [PASignatureUtil getSegmentFromAbsoluteURL:urlPath];
    sequence = [url md5];
    
    return sequence;
}

// 根据URL参数获取签名字符串
+ (NSString *)getSignatureFromParameters:(NSDictionary *)parameters
                                    time:(NSString *)time
                               apiSecret:(NSString *)apiSecret
                              signFuncID:(NSString *)signFuncID
                             apiSequence:(NSString *)apiSequence{
    NSString *signature = nil;
    NSString *parameterString = nil;
    
    NSArray *keys = [parameters allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *p1, NSString *p2){
        return [p1 compare:p2];
    }];
    
    parameterString = [NSString stringWithFormat:@""];
    
    if (sortedKeys.count > 0) {
        parameterString = [parameterString stringByAppendingString:@"{"];
        for (NSString *temp in sortedKeys) {
            NSString *value = [parameters objectForKey:temp];
            parameterString = [parameterString stringByAppendingString:[NSString stringWithFormat:@"\"%@\":\"%@\",", temp, value]];
        }
        
        // 去除最后多余的逗号
        parameterString = [parameterString substringToIndex:parameterString.length-1];
        parameterString = [parameterString stringByAppendingString:@"}"];
    }
    
    signature = [NSString stringWithFormat:@"data=%@&time=%@&apiSequence=%@&signFuncID=%@%@", parameterString, time, apiSequence, signFuncID, apiSecret];
    signature = [signature md5];
    
    return  signature;
}

#pragma mark - Private Methods

// 根据URL获取域名之后的segment
+ (NSString *)getSegmentFromAbsoluteURL:(NSString *)absoluteURL {
    NSString *path = @"";
    NSURL * URL = [NSURL URLWithString:absoluteURL];
    
    if (URL.path && URL.path.length) {
        path = URL.path;
    }
    
    return path;
}

@end
