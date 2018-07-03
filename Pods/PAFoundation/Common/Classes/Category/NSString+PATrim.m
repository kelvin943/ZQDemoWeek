//
//  NSString+PATrim.m
//  PAFoundation
//
//  Created by 董天天(外包) on 2017/12/23.
//

#import "NSString+PATrim.h"

@implementation NSString (PATrim)

- (NSString *)trim {
    if(nil == self){
        return nil;
    }
    
    NSMutableString *re = [NSMutableString stringWithString:self];
    CFStringTrimWhitespace((CFMutableStringRef)re);
    return (NSString *)re;
}

@end
