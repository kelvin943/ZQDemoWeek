//
//  UIFont+IconFont.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/17.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (IconFont)

/**
 根据指定字号返回 IconFont 字体

 @param size 字号
 @return IconFont 字体
 */
+ (UIFont *)iconFontWithSize:(CGFloat)size;

@end
