//
//  UIBarButtonItem+Category.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/11.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)

/**
 根据图标字构造 UIBarButtonItem

 @param title 图标字
 @param target 事件响应者
 @param action 响应方法
 @return UIBarButtonItem
 */
+ (id)barItemWithIconTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 根据普通文本字符串构造 UIBarButtonItem
 
 @param title 普通文本字符串
 @param target 事件响应者
 @param action 响应方法
 @return UIBarButtonItem
 */
+ (id)barItemWithTextTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
