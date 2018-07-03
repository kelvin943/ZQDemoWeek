//
//  NSString+Encrypt.m
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/17.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "NSString+Encrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

- (NSString *)md5 {
    if(self == nil || [self length] == 0){
        return nil;
    }
    
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(src, (CC_LONG)strlen(src), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)base64EncodeString{
    if(self == nil || [self length] == 0){
        return nil;
    }
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeStr = [data base64EncodedStringWithOptions:0];
    
    return encodeStr;
}

- (NSString *)decodeBase64String{
    if(self == nil || [self length] == 0){
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString *decodeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

@end
