//
//  PAViewController.h
//  haofang
//
//  Created by PengFeiMeng on 3/17/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PANavigatorProtocol.h"
#import "PAViewControllerProtocol.h"

/**
 默认支持键盘监听相关功能，需手动调用 register 和 unregister 方法。
 */
@interface PAViewController : UIViewController <PANavigatorProtocol, PAViewControllerProtocol>

/*!
 @property
 @abstract      是否需要在键盘显示之后点击页面让键盘消失
 */
@property (nonatomic, retain) NSNumber *needsTapToDismissKeyborad;

/**
 注册键盘通知事件监听
 
 @warning 如果注册了通知（比如键盘监听），那么在 Controller 被销毁之前一定要调用 unregisterNotification 方法。
 */
- (void)registerKeyboardNotification;

/**
 移除事件监听
 
 @warning 旧版代码在 PAViewController 的 dealloc 中调用了此方法；现在改成由使用者主动管理
 */
- (void)unregisterNotification;

/**
 让键盘将要显示事件通知
 */
- (void)keyboardWillShow:(NSNotification *)notification;

/**
 让键盘将要隐藏事件通知
 */
- (void)keyboardWillHide:(NSNotification *)notification;

/**
 让键盘消失
 */
- (void)dismissKeyboard;

/**
 返回上级视图
 */
- (void)backTo;

/**
 通用返回按钮
 */
- (void)setBackBarButton;

/**
 清空返回按钮
 
 @discussion 隐藏左上的按钮可以通过赋 leftBarButtonItem 值为 nil 并将 hidesBackButton 置为 YES，
 但是这样会导致 push / pop 偶现类型为 UINavigationItemButtonView 文本为 ... 的视图。
 所以，采用赋 leftBarButtonItem 值为不可见的对象达到目的。
 */
- (void)hideBackBarButton;

@end

