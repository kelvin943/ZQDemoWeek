//
//  UIBarButtonItem+Category.m
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/11.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "UIBarButtonItem+Category.h"
#import "UIFont+IconFont.h"
#import "PAMediator+AppConfig.h"
#import "UIColor+Category.h"

@implementation UIBarButtonItem (Category)

+ (id)barItemWithIconTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [UIBarButtonItem barItemWithTitle:title font:[UIFont iconFontWithSize:18.0f] target:target action:action];
}

+ (id)barItemWithTextTitle:(NSString *)title target:(id)target action:(SEL)action {
    return [UIBarButtonItem barItemWithTitle:title font:[UIFont systemFontOfSize:16.0] target:target action:action];
}

+ (id)barItemWithTitle:(NSString *)title font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btn.exclusiveTouch = YES;
    btn.showsTouchWhenHighlighted = YES;
    btn.backgroundColor = [UIColor clearColor];
    
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:title forState:UIControlStateNormal];
    
    NSUInteger hex = [[PAMediator sharedInstance] BAR_BUTTON_TITLE_COLOR_HEX];
    [btn setTitleColor:[UIColor colorWithHex:hex] forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
