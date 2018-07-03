//
//  NSString+PADate.m
//  PAFoundation
//
//  Created by 董天天(外包) on 2017/12/23.
//

#import "NSString+PADate.h"
#import "NSDateFormatter+PACategory.h"

@implementation NSString (PADate)

+ (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter staticDateFormatter];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *retStr = [formatter stringFromDate:date];
    
    return retStr;
}

@end
