//
//  UIViewController+PAFullscreenPage.h
//  haofang
//
//  Created by Linkou Bian on 4/12/16.
//  Copyright © 2016 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^_PAViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

/*!
 @abstract  允许vc自己控制导航栏是否显示
 */
@interface UIViewController (PAFullscreenPage)

// 由框架代码使用, 客户程序勿用!!!
@property (nonatomic, copy) _PAViewControllerWillAppearInjectBlock pa_willAppearInjectBlock;

// 好房APP的tabbar controller是包含在navigation controller中的, 该tabbar controller的
// 每个子vc不会受UINavigationController+PAFullscreenPage的管理;
// 故当前面提的子vc单独被处理时, 应确保将pa_willAppearInjectBlockIgnored置为YES, 这样就会
// 避免受UINavigationController+PAFullscreenPage注入代码的影响!
@property (nonatomic, assign) BOOL pa_willAppearInjectBlockIgnored;

// 如果受nav controller管理的vc需要全屏显示, 则置为YES. 默认为NO, 因为全屏是少数!
@property (nonatomic, assign) BOOL pa_prefersNavigationBarHidden;

// 当tabbar controller的子vc是因为在tabbar上点击切换而来, 则置为YES;
// 主要是因为tabbar切换时导航栏隐藏或显示不需要动画, 而push/po进入该vc时
// 隐藏或显示导航栏是需要动画. 故增加此变量.
@property (nonatomic, assign) BOOL pa_fromTabbarSelection;

@end
