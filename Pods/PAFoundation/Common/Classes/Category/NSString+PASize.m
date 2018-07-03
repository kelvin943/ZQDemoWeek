//
//  NSString+PASize.m
//  PAFoundation
//
//  Created by 董天天(外包) on 2017/12/26.
//

#import "NSString+PASize.h"

@implementation NSString (PASize)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
