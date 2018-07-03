//
//  UIColor+Category.h
//  haofang
//
//  Created by PengFeiMeng on 3/26/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

/**
 根据 Hex 颜色值构造 UIColor

 @discussion 支持形如 0xffcc00 的 24 位 hex 颜色值；
             若想指定 alpha 则可以使用形如 0x33ffcc00 这样的 32 位 hex 颜色值，
             前 8 位 0x33 除以 0xFF 则为 alpha
 @param hex 形如 0xffcc00 的 hex 颜色值
 @return UIColor
 */
+ (UIColor *)colorWithHex:(NSUInteger)hex;

@end
