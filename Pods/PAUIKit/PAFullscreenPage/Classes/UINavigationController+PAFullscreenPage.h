//
//  UINavigationController+PAFullscreenPage.h
//  haofang
//
//  Created by Linkou Bian on 4/12/16.
//  Copyright © 2016 平安好房. All rights reserved.
//
//  ref: https://github.com/forkingdog/FDFullscreenPopGesture
//

#import <UIKit/UIKit.h>

/*!
 @class
 @abstract  给导航栏控制器负责切换的页面增加全屏支持
 */
@interface UINavigationController (PAFullscreenPage)

// 是否由各vc自己控制其导航栏是否显示，默认为YES
@property (nonatomic, assign) BOOL pa_viewControllerBasedNavigationBarAppearanceEnabled;

@end


