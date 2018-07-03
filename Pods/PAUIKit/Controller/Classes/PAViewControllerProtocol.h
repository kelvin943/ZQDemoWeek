//
//  PAViewControllerProtocol.h
//  manpanxiang
//
//  Created by Linkou Bian on 23/08/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 以协议的方式约束项目的 Controller，由具体的页面按需实现。
 
 @discussion 在设计公共组件，如 PAStatsAOP、PAFullscreenPage 等时，直接给 Controller 注入属性并提供默认值。
             其实也可以提供诸如 PAStatsProtocol、PAFullscreenProtocol 等协议，由相应的页面去实现。
 */
@protocol PAViewControllerProtocol <NSObject>

@required

/**
 左上是否需要默认的返回按钮

 @discussion 1) 其实这个方法也可以放到 optional 部分，调用前判断下即可。

             2) 业务代码也可以不 override 此方法，而是通过覆写扩展的 setBackBarButton 达到目的。
 @return BOOL
 @code - (void)setBackBarButton {
 
 }
 */
- (BOOL)shouldSetBackBarButton;

@optional

/**
 当前页面是否需要禁掉侧滑返回功能

 @return BOOL
 */
- (BOOL)disableInteractiveGesture;

/**
 设置导航栏上的按钮等
 */
- (void)initNavigationBar;

/**
 清除导航栏上的按钮等
 */
- (void)clearNavigationBar;

@end
