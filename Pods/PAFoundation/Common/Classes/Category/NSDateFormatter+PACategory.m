//
//  NSDateFormatter+PACategory.m
//  PAFoundation
//
//  Created by 董天天(外包) on 2017/12/23.
//

#import "NSDateFormatter+PACategory.h"

@implementation NSDateFormatter (PACategory)

+ (NSDateFormatter *)staticDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *staticDateFormatter;
    dispatch_once(&onceToken, ^{
        staticDateFormatter = [[NSDateFormatter alloc] init];
    });
    return staticDateFormatter;
}

@end
