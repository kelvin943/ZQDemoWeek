//
//  UINavigationController+PAFullscreenPage.m
//  haofang
//
//  Created by Linkou Bian on 4/12/16.
//  Copyright © 2016 平安好房. All rights reserved.
//

#import "UINavigationController+PAFullscreenPage.h"
#import "UIViewController+PAFullscreenPage.h"
#import <objc/runtime.h>

@implementation UINavigationController (PAFullscreenPage)

+ (void)load {
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(pa_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)pa_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Handle perferred navigation bar appearance.
    [self pa_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self pa_pushViewController:viewController animated:animated];
    }
}

- (void)pa_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController {
    if (!self.pa_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _PAViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.pa_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    if (!appearingViewController.pa_willAppearInjectBlockIgnored) {
        appearingViewController.pa_willAppearInjectBlock = block;
    }
    
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.pa_willAppearInjectBlockIgnored && !disappearingViewController.pa_willAppearInjectBlock) {
        disappearingViewController.pa_willAppearInjectBlock = block;
    }
}

- (BOOL)pa_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.pa_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setPa_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(pa_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
