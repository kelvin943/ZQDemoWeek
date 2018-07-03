//
//  NSMutableAttributedString+Category.m
//  haofang
//
//  Created by Aim on 14-3-31.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "NSMutableAttributedString+Category.h"

@implementation NSMutableAttributedString (Category)

- (NSAttributedString *)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    NSAttributedString *resultString = [self appendString:string font:font color:color alignment:NSTextAlignmentLeft baselineOffset:@0];
    return resultString;
}

- (NSAttributedString *)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color baselineOffset:(NSNumber *)offset {
    NSAttributedString *resultString = [self appendString:string font:font color:color alignment:NSTextAlignmentLeft baselineOffset:offset];
    return resultString;
}

- (NSAttributedString *)appendString:(NSString *)string font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment baselineOffset:(NSNumber *)offset {
    if ([string length] == 0) {
        return self;
    }

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = alignment;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

    NSDictionary *attributes = @{NSFontAttributeName              : font,
                                 NSBaselineOffsetAttributeName    : offset,
                                 NSForegroundColorAttributeName   : color,
                                 NSParagraphStyleAttributeName    : paragraphStyle
                                 };
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    [self appendAttributedString:attributedString];

    return self;
}

@end
