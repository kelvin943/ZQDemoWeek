//
//  PANoticeUtil.h
//  haofang
//
//  Created by shakespeare on 14-4-22.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PANoticeUtil : NSObject

// 显示提示信息， s代表提示内容，view为要展示信息得view，一般为self.view
+ (void)showNotice:(NSString *)text;
+ (void)showNotice:(NSString *)text inView:(UIView *)view;
+ (void)showNotice:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration;
+ (void)showNotice:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration completion:(void(^)(void))completion;

+ (void)hideNotice;

@end
