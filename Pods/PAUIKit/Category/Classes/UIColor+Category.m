//
//  UIColor+Category.m
//  haofang
//
//  Created by PengFeiMeng on 3/26/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor *)colorWithHex:(NSUInteger)hex {
    CGFloat red, green, blue, alpha;
    
    red     = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
    green   = ((CGFloat)((hex >> 8)  & 0xFF)) / ((CGFloat)0xFF);
    blue    = ((CGFloat)((hex >> 0)  & 0xFF)) / ((CGFloat)0xFF);
    
    // If you do not specify an alpha "prefix" value, the default will be fully opaque.
    alpha   = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;
    
    return [UIColor colorWithRed: red green:green blue:blue alpha:alpha];
}

@end
