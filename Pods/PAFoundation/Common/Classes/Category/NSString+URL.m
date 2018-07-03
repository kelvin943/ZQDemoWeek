//
//  NSString+URL.m
//  manpanxiang
//
//  Created by Linkou Bian on 28/06/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSDictionary *)getURLParams{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSRange range1  = [self rangeOfString:@"?"];
    NSRange range2  = [self rangeOfString:@"#"];
    NSRange range;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    }else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    }else{
        range = NSMakeRange(-1, 1);
    }
    
    if (range.location != NSNotFound) {
        NSString * paramString = [self substringFromIndex:range.location+1];
        NSArray * paramCouples = [paramString componentsSeparatedByString:@"&"];
        for (int i = 0; i < [paramCouples count]; i++) {
            NSArray * param = [[paramCouples objectAtIndex:i] componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                NSString *tmpStr = [[param objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [dic setObject:tmpStr?:@"" forKey:[[param objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        return dic;
    }
    return nil;
}

- (NSString *)stringByAddingURLParams:(NSDictionary *)params{
    NSString * string           = self;
    
    if (params) {
        NSMutableArray * pairArray  = [NSMutableArray array];
        
        for (NSString * key in params) {
            NSString * value        = [[params objectForKey:key] stringValue];
            NSString * keyEscaped   = [key urlEncoding];
            NSString * valueEscaped = [value urlEncoding];
            NSString * pair         = [NSString stringWithFormat:@"%@=%@",keyEscaped,valueEscaped];
            [pairArray addObject:pair];
        }
        
        NSString * query            = [pairArray componentsJoinedByString:@"&"];
        string                      = [NSString stringWithFormat:@"%@?%@",self,query];
    }
    
    return string;
}

- (NSString *)urlEncoding {
    NSString *result = (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self,NULL,(CFStringRef)@"!#[]'*;/?:@&=$+{}<>,",kCFStringEncodingUTF8);
    return result;
}

@end
