//
//  UIViewController+PAFullscreenPage.m
//  haofang
//
//  Created by Linkou Bian on 4/12/16.
//  Copyright © 2016 平安好房. All rights reserved.
//

#import "UIViewController+PAFullscreenPage.h"
#import <objc/runtime.h>

#pragma mark - UIViewController+PAFullscreenPagePrivate

@implementation UIViewController (PAFullscreenPagePrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(pa_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        // viewWillDisappear
    });
}

- (void)pa_viewWillAppear:(BOOL)animated {
    [self pa_viewWillAppear:animated];
    
    if (!self.pa_willAppearInjectBlockIgnored && self.pa_willAppearInjectBlock) {
        self.pa_willAppearInjectBlock(self, animated);
    }
}

@end

#pragma mark - UIViewController+PAFullscreenPage

@implementation UIViewController (PAFullscreenPage)

- (BOOL)pa_willAppearInjectBlockIgnored {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPa_willAppearInjectBlockIgnored:(BOOL)ignore {
    objc_setAssociatedObject(self, @selector(pa_willAppearInjectBlockIgnored), @(ignore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (_PAViewControllerWillAppearInjectBlock)pa_willAppearInjectBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setPa_willAppearInjectBlock:(_PAViewControllerWillAppearInjectBlock)block {
    objc_setAssociatedObject(self, @selector(pa_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)pa_prefersNavigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setPa_prefersNavigationBarHidden:(BOOL)hidden {
    objc_setAssociatedObject(self, @selector(pa_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pa_fromTabbarSelection {
    return [objc_getAssociatedObject(self, _cmd) boolValue];;
}

- (void)setPa_fromTabbarSelection:(BOOL)fromTabSel {
    objc_setAssociatedObject(self, @selector(pa_fromTabbarSelection), @(fromTabSel), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
